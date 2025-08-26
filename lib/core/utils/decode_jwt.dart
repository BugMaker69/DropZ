import 'dart:convert';

Map<String, dynamic> decodeJwtPayload(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('Invalid JWT');
  }

  final payload = parts[1];
  var normalized = base64Url.normalize(payload);
  var payloadBytes = base64Url.decode(normalized);

  final payloadMap = json.decode(utf8.decode(payloadBytes));

  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('Invalid payload');
  }

  return payloadMap;
}
