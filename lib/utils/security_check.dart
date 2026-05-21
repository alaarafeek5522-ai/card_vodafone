import 'dart:io';
import 'package:flutter/services.dart';

class SecurityCheck {
  static const _channel = MethodChannel('com.card.developerAlaa/security');

  // SHA-256 of your release keystore — تغيره بعد أول بيلد
  static const _validSignature = 'REPLACE_AFTER_FIRST_BUILD';

  static Future<SecurityResult> verify() async {
    // 1. VPN check
    if (await _isVpnActive()) {
      return SecurityResult.blocked('VPN مش مسموح به');
    }

    // 2. Signature check (لو الـ signature اتعمل)
    if (_validSignature != 'REPLACE_AFTER_FIRST_BUILD') {
      final sig = await _getSignature();
      if (sig != _validSignature) {
        return SecurityResult.blocked('التطبيق تم التلاعب به');
      }
    }

    return SecurityResult.ok();
  }

  static Future<bool> _isVpnActive() async {
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.any,
      );
      for (final iface in interfaces) {
        final name = iface.name.toLowerCase();
        if (name.contains('tun') ||
            name.contains('ppp') ||
            name.contains('tap') ||
            name.contains('vpn') ||
            name.contains('wg')) {
          return true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
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
