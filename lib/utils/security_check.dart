import 'dart:io';
import 'package:flutter/services.dart';

class SecurityCheck {
  static const _channel = MethodChannel('com.card.developerAlaa/security');

  // حط الـ signature بتاعتك هنا بعد أول بيلد
  static const _validSignature = '4e2240735ff825f83500973d8fa5b22eb9eedb797e65d029ccd9b16ac815aeda';

  static Future<SecurityResult> verify() async {
    // 1. Root check
    if (await _isRooted()) {
      return SecurityResult.blocked('الجهاز مروت — مش مسموح');
    }

    // 2. Emulator check
    if (await _isEmulator()) {
      return SecurityResult.blocked('مش مسموح تشغيل على محاكي');
    }

    // 3. Tamper check
    if (_validSignature != '4e2240735ff825f83500973d8fa5b22eb9eedb797e65d029ccd9b16ac815aeda') {
      final sig = await _getSignature();
      if (sig != _validSignature) {
        return SecurityResult.blocked('التطبيق تم التلاعب به');
      }
    }

    return SecurityResult.ok();
  }

  static Future<bool> _isRooted() async {
    // فحص ملفات الروت الشائعة
    final rootPaths = [
      '/system/app/Superuser.apk',
      '/system/xbin/su',
      '/system/bin/su',
      '/sbin/su',
      '/data/local/su',
      '/data/local/bin/su',
      '/data/local/xbin/su',
      '/system/sd/xbin/su',
      '/system/bin/failsafe/su',
      '/dev/com.koushikdutta.superuser.daemon/',
      '/system/app/SuperSU.apk',
      '/system/xbin/daemonsu',
      '/system/etc/init.d/99SuperSUDaemon',
      '/system/bin/.ext/.su',
      '/system/usr/we-need-root/su-backup',
      '/system/xbin/mu',
    ];

    for (final path in rootPaths) {
      if (await File(path).exists()) return true;
    }

    // فحص su command
    try {
      final result = await Process.run('which', ['su']);
      if (result.stdout.toString().isNotEmpty) return true;
    } catch (_) {}

    // فحص build tags
    try {
      final result = await _channel.invokeMethod<String>('getBuildTags');
      if (result != null && result.contains('test-keys')) return true;
    } catch (_) {}

    return false;
  }

  static Future<bool> _isEmulator() async {
    try {
      final result = await _channel.invokeMethod<Map>('getDeviceInfo');
      if (result == null) return false;

      final fingerprint = result['fingerprint']?.toString().toLowerCase() ?? '';
      final model = result['model']?.toString().toLowerCase() ?? '';
      final manufacturer = result['manufacturer']?.toString().toLowerCase() ?? '';
      final brand = result['brand']?.toString().toLowerCase() ?? '';
      final device = result['device']?.toString().toLowerCase() ?? '';
      final hardware = result['hardware']?.toString().toLowerCase() ?? '';
      final product = result['product']?.toString().toLowerCase() ?? '';

      if (fingerprint.contains('generic') ||
          fingerprint.contains('unknown') ||
          fingerprint.contains('emulator') ||
          fingerprint.contains('sdk') ||
          model.contains('emulator') ||
          model.contains('android sdk') ||
          model.contains('google_sdk') ||
          manufacturer.contains('genymotion') ||
          brand.startsWith('generic') ||
          device.contains('generic') ||
          hardware.contains('goldfish') ||
          hardware.contains('ranchu') ||
          product.contains('sdk') ||
          product.contains('google_sdk') ||
          product.contains('emulator')) {
        return true;
      }
    } catch (_) {}

    return false;
  }

  static Future<String> _getSignature() async {
    try {
      final result = await _channel.invokeMethod<String>('getSignature');
      return result ?? '';
    } catch (_) {
      return '';
    }
  }
}

class SecurityResult {
  final bool allowed;
  final String reason;
  SecurityResult.ok() : allowed = true, reason = '';
  SecurityResult.blocked(this.reason) : allowed = false;
}
