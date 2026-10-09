// author: juraj.suchan@gmail.com

import '../../core/api/api_client.dart';
import '../../core/json_utils.dart';
import 'token_request_result.dart';

class AuthRepository {
  AuthRepository(this._api);

  final ApiClient _api;

  Future<TokenRequestResult> requestToken(String nick) async {
    final json = await _api.post('/create_token/${Uri.encodeComponent(nick)}');
    return TokenRequestResult.fromJson(asMap(json) ?? const {});
  }

  Future<void> registerPush(String authToken, String fcmToken) =>
      _api.post('/register_for_notifications/$authToken/nyxdroid/$fcmToken');

  Future<void> unregisterPush(String authToken) =>
      _api.post('/deregister_notifications/$authToken');
}
