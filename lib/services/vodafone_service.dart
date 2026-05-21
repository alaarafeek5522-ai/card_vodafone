import 'dart:convert';
import 'package:http/http.dart' as http;

class ChargeResult {
  final bool success;
  final String message;
  ChargeResult({required this.success, required this.message});
}

class VodafoneService {
  static const Map<String, String> _baseHeaders = {
    'User-Agent': 'okhttp/4.11.0',
    'Connection': 'Keep-Alive',
    'Accept-Encoding': 'gzip',
    'x-agent-operatingsystem': '13',
    'clientId': 'AnaVodafoneAndroid',
    'Accept-Language': 'ar',
    'x-agent-device': 'OPPO CPH2235',
    'x-agent-version': '2024.7.2.1',
    'x-agent-build': '1050',
    'digitalId': '24S0M31T0I9RK',
  };

  Future<ChargeResult> charge({
    required String receiver,
    required String pin,
    required String productId,
  }) async {
    try {
      // Step 1: Seamless token
      final seamlessRes = await http.get(
        Uri.parse(
          'http://mobile.vodafone.com.eg/checkSeamless/realms/vf-realm/protocol/openid-connect/auth?client_id=ana-vodafone-app-seamless',
        ),
        headers: {
          ..._baseHeaders,
          'x-dynatrace': 'MT_3_5_2386790616_1-0_a556db1b-4506-43f3-854a-1d2527767923_0_21317_157',
        },
      );

      final seamlessData = json.decode(seamlessRes.body);
      final seamlessToken = seamlessData['seamlessToken'];
      final senderMsisdn = seamlessData['msisdn']?.toString();

      if (seamlessToken == null) {
        return ChargeResult(success: false, message: 'فشل تسجيل الدخول — تأكد إن الشريحة فودافون');
      }

      // Step 2: Access token
      final tokenRes = await http.post(
        Uri.parse('https://mobile.vodafone.com.eg/auth/realms/vf-realm/protocol/openid-connect/token'),
        headers: {
          ..._baseHeaders,
          'Accept': 'application/json, text/plain, */*',
          'silentLogin': 'true',
          'seamlessToken': seamlessToken,
          'firstTimeLogin': 'true',
          'x-dynatrace': 'MT_3_5_2386790616_1-0_a556db1b-4506-43f3-854a-1d2527767923_0_21520_165',
        },
        body: {
          'grant_type': 'password',
          'client_secret': 'b86e30a8-ae29-467a-a71f-65c73f2ff5e3',
          'client_id': 'cash-app',
        },
      );

      final accessToken = json.decode(tokenRes.body)['access_token'];
      if (accessToken == null) {
        return ChargeResult(success: false, message: 'فشل الحصول على access token');
      }

      // Step 3: Order
      final msisdnFormatted = (senderMsisdn != null && !senderMsisdn.startsWith('0'))
          ? '0$senderMsisdn'
          : senderMsisdn;

      final orderBody = json.encode({
        "channel": {"name": "MobileApp"},
        "orderItem": [
          {
            "action": "insert",
            "id": productId,
            "product": {
              "characteristic": [
                {"name": "PaymentMethod", "value": "VFCash"},
                {"name": "USE_EMONEY", "value": "False"},
                {"name": "MerchantCode", "value": ""},
              ],
              "id": productId,
              "relatedParty": [
                {"id": senderMsisdn, "name": "MSISDN", "role": "Subscriber"},
                {"id": receiver, "name": "Receiver", "role": "Receiver"},
              ],
            },
            "@type": productId,
            "eCode": 0,
          }
        ],
        "relatedParty": [
          {"id": pin, "name": "pin", "role": "Requestor"}
        ],
        "@type": "CashFakkaAndMared",
      });

      final orderRes = await http.post(
        Uri.parse('https://mobile.vodafone.com.eg/services/dxl/pom/productOrder'),
        headers: {
          ..._baseHeaders,
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'api-host': 'ProductOrderingManagement',
          'useCase': 'CashFakkaAndMared',
          'x-dynatrace': 'MT_3_5_2386790616_1-0_a556db1b-4506-43f3-854a-1d2527767923_0_2_160',
          'api-version': 'v2',
          'msisdn': msisdnFormatted ?? '',
          'Authorization': 'Bearer $accessToken',
        },
        body: orderBody,
      );

      final result = json.decode(orderRes.body);
      if (result['state'] == 'Completed' || result['complete'] == true) {
        return ChargeResult(success: true, message: 'تم الشحن بنجاح ✅');
      } else {
        return ChargeResult(success: false, message: 'فشل: رصيدك غير كافي أو خطأ آخر');
      }
    } catch (e) {
      return ChargeResult(success: false, message: 'خطأ في الاتصال: $e');
    }
  }
}
