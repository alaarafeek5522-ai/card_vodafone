import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const _githubToken = 'GITHUB_TOKEN_PLACEHOLDER';
const _repoApi = 'https://api.github.com/repos/alaarafeek5522-ai/vf_keys/contents/keys.json';

enum LicenseStatus { valid, invalidKey, usedOnOtherDevice, networkError }

Map<String, String> get _headers => {
  'Authorization': 'token $_githubToken',
  'Accept': 'application/vnd.github.v3.raw',
  'Cache-Control': 'no-cache',
};

class LicenseService {
  static Future<String> getDeviceId() async {
    final info = DeviceInfoPlugin();
    final android = await info.androidInfo;
    return android.id;
  }

  static Future<String?> getSavedKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('license_key');
  }

  static Future<void> saveKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('license_key', key);
  }

  static Future<List<Map<String, dynamic>>> _fetchKeys() async {
    final res = await http.get(Uri.parse(_repoApi), headers: _headers);
    if (res.statusCode != 200) throw Exception('fetch failed: ${res.statusCode}');
    final data = json.decode(res.body);
    return List<Map<String, dynamic>>.from(data['keys']);
  }

  static Future<String> _fetchSha() async {
    final res = await http.get(
      Uri.parse(_repoApi),
      headers: {
        'Authorization': 'token $_githubToken',
        'Accept': 'application/vnd.github.v3+json',
      },
    );
    return json.decode(res.body)['sha'];
  }

  static Future<LicenseStatus> activate(String inputKey) async {
    try {
      final deviceId = await getDeviceId();
      final keys = await _fetchKeys();

      final idx = keys.indexWhere((k) => k['key'] == inputKey);
      if (idx == -1) return LicenseStatus.invalidKey;

      final entry = keys[idx];
      if (entry['active'] != true) return LicenseStatus.invalidKey;

      final savedDevice = entry['device_id'];

      if (savedDevice != null && savedDevice != deviceId) {
        return LicenseStatus.usedOnOtherDevice;
      }

      if (savedDevice == deviceId) {
        await saveKey(inputKey);
        return LicenseStatus.valid;
      }

      // أول تسجيل — نسجل الـ device_id
      keys[idx]['device_id'] = deviceId;
      final updated = json.encode({'keys': keys});
      final sha = await _fetchSha();

      final updateRes = await http.put(
        Uri.parse(_repoApi),
        headers: {
          'Authorization': 'token $_githubToken',
          'Accept': 'application/vnd.github.v3+json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'message': 'activate key $inputKey',
          'content': base64Encode(utf8.encode(updated)),
          'sha': sha,
        }),
      );

      if (updateRes.statusCode == 200 || updateRes.statusCode == 201) {
        await saveKey(inputKey);
        return LicenseStatus.valid;
      }

      return LicenseStatus.networkError;
    } catch (e) {
      debugPrint('License error: $e');
      return LicenseStatus.networkError;
    }
  }

  static Future<bool> isActivated() async {
    try {
      final key = await getSavedKey();
      if (key == null) return false;

      final deviceId = await getDeviceId();
      final keys = await _fetchKeys();

      final entry = keys.firstWhere((k) => k['key'] == key, orElse: () => {});
      if (entry.isEmpty) return false;
      if (entry['active'] != true) return false;
      if (entry['device_id'] != deviceId) return false;

      return true;
    } catch (_) {
      return true; // offline grace
    }
  }
}
