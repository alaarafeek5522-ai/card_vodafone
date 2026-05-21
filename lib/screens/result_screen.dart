import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/charge_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChargeProvider>();
    final success = provider.state == ChargeState.success;

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (success ? AppTheme.red : Colors.orange).withOpacity(0.15),
                ),
                child: Icon(
                  success ? Icons.check_circle_rounded : Icons.error_rounded,
                  color: success ? AppTheme.red : Colors.orange,
                  size: 60,
                ),
              )
                  .animate()
                  .scale(begin: const Offset(0.3, 0.3), duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: 28),
              // Title
              Text(
                success ? 'تم بنجاح! 🎉' : 'فشل الشحن',
                style: GoogleFonts.cairo(
                  color: AppTheme.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 12),
              // Message
              Text(
                provider.message,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  color: AppTheme.greyLight,
                  fontSize: 15,
                ),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 48),
              // Back button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    provider.reset();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (_) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: success ? AppTheme.red : AppTheme.cardBg,
                    foregroundColor: AppTheme.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: success
                          ? BorderSide.none
                          : const BorderSide(color: AppTheme.cardBorder),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'العودة للرئيسية',
                    style: GoogleFonts.cairo(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
            ],
          ),
        ),
      ),
    );
  }
}
