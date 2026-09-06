import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({super.key, required this.onBackHome});

  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    final s = S.current;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'WOW NOW',
                    style: AppFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pictonBlue,
                    ),
                  ),
                  const Spacer(),
                  ClipOval(
                    child: Image.asset(
                      'asset/benjamin.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.pictonBlue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.pictonBlue.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                s.bookingConfirmedTitle,
                textAlign: TextAlign.center,
                style: AppFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGray,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                s.bookingConfirmedSubtitle,
                textAlign: TextAlign.center,
                style: AppFonts.body(
                  fontSize: 16,
                  color: AppColors.darkGray.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 28),
              Image.asset(
                'asset/benjamin-full.png',
                height: 320,
                fit: BoxFit.contain,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: onBackHome,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF004B6F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    s.backToHome,
                    style: AppFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: AppColors.pictonBlue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    s.sparkleGuaranteed,
                    style: AppFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.pictonBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
