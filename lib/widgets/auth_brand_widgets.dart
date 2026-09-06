import 'package:flutter/material.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class AuthYellowButton extends StatelessWidget {
  const AuthYellowButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow,
          foregroundColor: AppColors.darkLiver,
          disabledBackgroundColor: AppColors.yellow.withValues(alpha: 0.7),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.darkLiver,
                ),
              )
            : Text(
                label,
                style: AppFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.4,
                  color: AppColors.darkLiver,
                ),
              ),
      ),
    );
  }
}

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.showVisibilityToggle = false,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool showVisibilityToggle;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final showToggle = widget.showVisibilityToggle || widget.obscureText;

    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscured,
      style: AppFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.darkLiver,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF9A9A9A),
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: showToggle
            ? IconButton(
                onPressed: () => setState(() => _obscured = !_obscured),
                icon: Icon(
                  _obscured
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.darkLiver.withValues(alpha: 0.55),
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class AuthMascotBadge extends StatefulWidget {
  const AuthMascotBadge({super.key, this.size = 180});

  final double size;

  @override
  State<AuthMascotBadge> createState() => _AuthMascotBadgeState();
}

class _AuthMascotBadgeState extends State<AuthMascotBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final circle = widget.size * 0.89;

    return AnimatedBuilder(
      animation: _float,
      builder: (context, child) {
        final dy = Tween<double>(
          begin: -5,
          end: 5,
        ).evaluate(CurvedAnimation(parent: _float, curve: Curves.easeInOut));
        return Transform.translate(offset: Offset(0, dy), child: child);
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: circle,
              height: circle,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'asset/benjamin-avatar-removebg-preview.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            const Positioned(
              top: 8,
              left: 4,
              child: Icon(Icons.flare, color: AppColors.white, size: 32),
            ),
            const Positioned(
              bottom: 4,
              right: 0,
              child: Icon(
                Icons.wb_sunny_rounded,
                color: AppColors.yellow,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthWowNowWatermark extends StatelessWidget {
  const AuthWowNowWatermark({super.key});

  @override
  Widget build(BuildContext context) {
    final style = AppFonts.montserrat(
      fontSize: 96,
      fontWeight: FontWeight.w800,
      color: AppColors.white.withValues(alpha: 0.07),
      height: 0.9,
      letterSpacing: 2,
    );

    return IgnorePointer(
      child: OverflowBox(
        maxWidth: 900,
        maxHeight: 1400,
        child: Transform.rotate(
          angle: -0.26,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              8,
              (index) => Padding(
                padding: EdgeInsets.only(
                  left: index.isEven ? 0 : 80,
                  bottom: 28,
                ),
                child: Text(
                  'WOW NOW  WOW NOW  WOW NOW',
                  maxLines: 1,
                  softWrap: false,
                  style: style,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthBrandTitle extends StatelessWidget {
  const AuthBrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'WOW NOW',
          style: AppFonts.montserrat(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'CLEANING SERVICES',
          style: AppFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.white.withValues(alpha: 0.92),
            letterSpacing: 3.2,
          ),
        ),
      ],
    );
  }
}
