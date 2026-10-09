// author: juraj.suchan@gmail.com

import '../../core/json_utils.dart';

class TokenRequestResult {
  const TokenRequestResult({
    this.id,
    this.confirmationCode = '',
    this.token = '',
  });

  final int? id;
  final String confirmationCode;
  final String token;

  bool get isNew => id != null && id != -1;

  factory TokenRequestResult.fromJson(Map<String, dynamic> j) =>
      TokenRequestResult(
        id: asInt(j['id']),
        confirmationCode: asString(j['confirmation_code']) ?? '',
        token: asString(j['token']) ?? '',
      );
}
