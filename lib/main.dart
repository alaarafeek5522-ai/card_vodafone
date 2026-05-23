import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/charge_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/blocked_screen.dart';
import 'theme/app_theme.dart';
import 'utils/security_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  final security = await SecurityCheck.verify();

  runApp(CardVodafoneApp(
    securityPassed: security.allowed,
    reason: security.reason,
  ));
}

class CardVodafoneApp extends StatelessWidget {
  final bool securityPassed;
  final String reason;
  const CardVodafoneApp({
    super.key,
    required this.securityPassed,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChargeProvider(),
      child: MaterialApp(
        title: '𝐂𝐚𝐫𝐝 𝐕𝐨𝐝𝐚𝐟𝐨𝐧𝐞',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: securityPassed
            ? const SplashScreen()
            : BlockedScreen(reason: reason),
      ),
    );
  }
}
