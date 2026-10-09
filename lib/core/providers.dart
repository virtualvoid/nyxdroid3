// author: juraj.suchan@gmail.com

import 'dart:ui' show Brightness;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/appearance.dart';
import '../app/platform_brightness_notifier.dart';
import '../features/auth/auth_repository.dart';
import '../features/auth/auth_service.dart';
import '../features/bookmarks/bookmarks_repository.dart';
import '../features/discussion/discussion_repository.dart';
import '../features/mail/mail_repository.dart';
import '../features/notifications/notifications_repository.dart';
import '../features/search/search_repository.dart';
import 'api/api_client.dart';
import 'auth/auth_store.dart';
import 'prefs/app_prefs.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) =>
      throw UnimplementedError('sharedPreferencesProvider nie je nastavený'),
);

class AppPrefsNotifier extends Notifier<AppPrefs> {
  @override
  AppPrefs build() => AppPrefs(ref.watch(sharedPreferencesProvider));

  Future<void> setBool(String key, bool value) async {
    await state.putBool(key, value);
    state = AppPrefs(ref.read(sharedPreferencesProvider));
  }

  Future<void> setString(String key, String value) async {
    await state.putString(key, value);
    state = AppPrefs(ref.read(sharedPreferencesProvider));
  }
}

final appPrefsProvider = NotifierProvider<AppPrefsNotifier, AppPrefs>(
  AppPrefsNotifier.new,
);

final appearanceProvider = Provider(
  (ref) => Appearance.fromPrefs(
    ref.watch(appPrefsProvider),
    systemDark: ref.watch(platformBrightnessProvider) == Brightness.dark,
  ),
);

final authStoreProvider = Provider<AuthStore>((ref) => AuthStore());

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(authStoreProvider)),
);

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(ref.watch(apiClientProvider)),
);

final authServiceProvider = Provider(
  (ref) => AuthService(
    ref.watch(authStoreProvider),
    ref.watch(authRepositoryProvider),
  ),
);

final bookmarksRepositoryProvider = Provider(
  (ref) => BookmarksRepository(ref.watch(apiClientProvider)),
);

final discussionRepositoryProvider = Provider(
  (ref) => DiscussionRepository(
    ref.watch(apiClientProvider),
    nick: () => ref.read(authStoreProvider).nick,
  ),
);

final mailRepositoryProvider = Provider(
  (ref) => MailRepository(
    ref.watch(apiClientProvider),
    nick: () => ref.read(authStoreProvider).nick,
  ),
);

final notificationsRepositoryProvider = Provider(
  (ref) => NotificationsRepository(
    ref.watch(apiClientProvider),
    nick: () => ref.read(authStoreProvider).nick,
  ),
);

final searchRepositoryProvider = Provider(
  (ref) => SearchRepository(
    ref.watch(apiClientProvider),
    nick: () => ref.read(authStoreProvider).nick,
  ),
);
