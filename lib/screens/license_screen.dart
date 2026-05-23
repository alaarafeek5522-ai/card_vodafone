import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/license_service.dart';
import '../theme/app_theme.dart';
import '../widgets/spinning_logo.dart';
import 'home_screen.dart';

class LicenseScreen extends StatefulWidget {
  const LicenseScreen({super.key});

  @override
  State<LicenseScreen> createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  String _error = '';

  Future<void> _activate() async {
    final key = _ctrl.text.trim();
    if (key.isEmpty) {
      setState(() => _error = 'ادخل الـ Key');
      return;
    }
    setState(() { _loading = true; _error = ''; });

    final status = await LicenseService.activate(key);

    if (!mounted) return;
    setState(() => _loading = false);

    switch (status) {
      case LicenseStatus.valid:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      case LicenseStatus.invalidKey:
        setState(() => _error = '❌ الـ Key غير صحيح أو غير مفعل');
      case LicenseStatus.usedOnOtherDevice:
        setState(() => _error = '🚫 الـ Key ده مستخدم على جهاز تاني');
      case LicenseStatus.networkError:
        setState(() => _error = '⚠️ خطأ في الاتصال، تأكد من النت');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const SpinningLogo(size: 150)
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.7, 0.7)),
              const SizedBox(height: 40),
              Text(
                'تفعيل التطبيق',
                style: GoogleFonts.cairo(
                  color: AppTheme.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 8),
              Text(
                'ادخل الـ Key الخاص بيك لتفعيل التطبيق',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(color: AppTheme.grey, fontSize: 14),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 32),
              TextField(
                controller: _ctrl,
                style: GoogleFonts.cairo(
                  color: AppTheme.white,
                  fontSize: 16,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'MARO-XXXX-XXXX',
                  hintStyle: GoogleFonts.cairo(color: AppTheme.grey, letterSpacing: 2),
                  filled: true,
                  fillColor: AppTheme.cardBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.cardBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.red, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 16),
              if (_error.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(
                    _error,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(color: Colors.redAccent, fontSize: 13),
                  ),
                ).animate().shake(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null : _activate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.red,
                    foregroundColor: AppTheme.white,
                    disabledBackgroundColor: AppTheme.redDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'تفعيل',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),
            ],
          ),
        ),
      ),
    );
  }
}
