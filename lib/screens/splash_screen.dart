import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/license_service.dart';
import '../widgets/spinning_logo.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'license_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final activated = await LicenseService.isActivated();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => activated ? const HomeScreen() : const LicenseScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: Center(
        child: const SpinningLogo(size: 180)
            .animate()
            .fadeIn(duration: 800.ms)
            .scale(begin: const Offset(0.7, 0.7)),
      ),
    );
  }
}
