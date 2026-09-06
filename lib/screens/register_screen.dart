import 'package:flutter/material.dart';
import 'package:wow_cleaning/config/app_config.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/l10n/locale_controller.dart';
import 'package:wow_cleaning/screens/main_shell.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/session_store.dart';
import 'package:wow_cleaning/theme/app_theme.dart';
import 'package:wow_cleaning/widgets/auth_brand_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController(text: 'Test Client');
  final _emailController = TextEditingController(text: AppConfig.demoEmail);
  final _phoneController = TextEditingController(text: AppConfig.demoPhone);
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _api = ApiClient();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _submitRegister() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await _api.postJson('/client/auth/register', {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text,
        'password_confirmation': _passwordConfirmController.text,
      }, auth: false);

      if (!mounted) return;

      if (response['success'] != true) {
        setState(() {
          _error = response['message']?.toString() ?? 'Registration failed';
          _loading = false;
        });
        return;
      }

      final data = response['data'];
      if (data is! Map<String, dynamic>) {
        setState(() {
          _error = 'Unexpected auth payload';
          _loading = false;
        });
        return;
      }

      SessionStore.instance.save(
        token: data['token']?.toString(),
        authData: data,
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => MainShell(loginData: data)),
        (_) => false,
      );
    } on ApiException catch (error) {
      setState(() {
        _error = error.displayMessage;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _error = S.current.registerUnexpectedError;
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
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              tooltip: s.back,
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          const AuthMascotBadge(size: 140),
                          const SizedBox(height: 16),
                          const AuthBrandTitle(),
                          const SizedBox(height: 8),
                          Text(
                            s.createAccount,
                            style: AppFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          AuthTextField(
                            controller: _nameController,
                            hint: s.name,
                          ),
                          const SizedBox(height: 10),
                          AuthTextField(
                            controller: _emailController,
                            hint: s.email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 10),
                          AuthTextField(
                            controller: _phoneController,
                            hint: s.phone,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 10),
                          AuthTextField(
                            controller: _passwordController,
                            hint: s.password,
                            obscureText: true,
                          ),
                          const SizedBox(height: 10),
                          AuthTextField(
                            controller: _passwordConfirmController,
                            hint: s.confirmPassword,
                            obscureText: true,
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
                            label: s.createAccountBtn,
                            loading: _loading,
                            onPressed: _submitRegister,
                          ),
                        ],
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
