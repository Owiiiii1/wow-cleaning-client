import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wow_cleaning/config/app_config.dart';
import 'package:wow_cleaning/config/asset_precache.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/l10n/locale_controller.dart';
import 'package:wow_cleaning/screens/main_shell.dart';
import 'package:wow_cleaning/screens/register_screen.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/session_store.dart';
import 'package:wow_cleaning/theme/app_theme.dart';
import 'package:wow_cleaning/widgets/auth_brand_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enterController;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  final _emailController = TextEditingController(text: AppConfig.demoEmail);
  final _passwordController = TextEditingController();
  final _api = ApiClient();

  bool _loading = false;
  String? _error;
  late final TapGestureRecognizer _registerTap;

  @override
  void initState() {
    super.initState();
    _registerTap = TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const RegisterScreen()),
        );
      };
    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _enterController, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterController, curve: Curves.easeOut));
    _enterController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      AssetPrecache.warmUp(context);
    });
  }

  @override
  void dispose() {
    _registerTap.dispose();
    _enterController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = S.current.invalidCredentials);
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await _api.postJson(
        '/client/auth/login',
        {
          'email': email,
          'password': password,
        },
        auth: false,
      );

      if (!mounted) return;

      if (response['success'] != true) {
        setState(() {
          _error = S.current.invalidCredentials;
          _loading = false;
        });
        return;
      }

      final data = response['data'];
      if (data is! Map<String, dynamic>) {
        setState(() {
          _error = S.current.loginUnexpectedError;
          _loading = false;
        });
        return;
      }

      SessionStore.instance.save(
        token: data['token']?.toString(),
        authData: data,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MainShell(loginData: data),
        ),
      );
    } on ApiException catch (error) {
      setState(() {
        // One shared warning for wrong email and/or password (401/422).
        final code = error.statusCode;
        if (code == 401 || code == 422) {
          _error = S.current.invalidCredentials;
        } else {
          _error = error.displayMessage;
        }
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _error = S.current.loginUnexpectedError;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        final s = S.current;

        return Scaffold(
          backgroundColor: AppColors.pictonBlue,
          body: Stack(
            children: [
              const AuthWowNowWatermark(),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: FadeTransition(
                        opacity: _fade,
                        child: SlideTransition(
                          position: _slide,
                          child: Column(
                            children: [
                              const AuthMascotBadge(),
                              const SizedBox(height: 20),
                              const AuthBrandTitle(),
                              const SizedBox(height: 28),
                              AuthTextField(
                                controller: _emailController,
                                hint: s.email,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 12),
                              AuthTextField(
                                controller: _passwordController,
                                hint: s.password,
                                obscureText: true,
                                showVisibilityToggle: true,
                              ),
                              if (_error != null) ...[
                                const SizedBox(height: 12),
                                Text(
                                  _error!,
                                  textAlign: TextAlign.center,
                                  style: AppFonts.montserrat(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFFFE8E6),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              AuthYellowButton(
                                label: s.logIn,
                                loading: _loading,
                                onPressed: _submitLogin,
                              ),
                              const SizedBox(height: 20),
                              Text.rich(
                                TextSpan(
                                  style: AppFonts.montserrat(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        AppColors.white.withValues(alpha: 0.92),
                                  ),
                                  children: [
                                    TextSpan(text: s.noAccount),
                                    TextSpan(
                                      text: s.signUp,
                                      recognizer: _registerTap,
                                      style: AppFonts.montserrat(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.white,
                                      ).copyWith(
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
