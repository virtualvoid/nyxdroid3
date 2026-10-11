// author: juraj.suchan@gmail.com

import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  AppPrefs(this._prefs);

  final SharedPreferences _prefs;

  static const kUseDarkTheme = 'use_dark_theme';
  static const kThemeMode = 'theme_mode';
  static const kCrashReporting = 'crash_reporting_enabled';
  static const kAnalytics = 'analytics_enabled';
  static const kFontSize = 'font_size';
  static const kBookmarkPadding = 'bookmark_padding';
  static const kUnreadBookmarks = 'unread_bookmarks';
  static const kUnreadHistory = 'unread_bookmarks_history';
  static const kDisplayReminders = 'display_reminders';
  static const kDisplayVotingThumbs = 'display_voting_thumbs';
  static const kRefreshAfterWriteupSend = 'refresh_after_writeup_send';
  static const kUnreadAppearance = 'unread_appearance';
  static const kDefaultView = 'default_view';
  static const kNotificationsEnabled = 'notifications_enabled';
  static const kBackpressReturnsWriteup = 'backpress_returns_writeup';
  static const kLanguage = 'language';
  static const kHistoryBooked = 'history_show_booked';
  static const kDensity = 'layout_density';
  static const kHistoryTimes = 'history_times';
  static const kUpdateCheck = 'update_check';
  static const kUpdateLastCheck = 'update_last_check';
  static const kUpdateSkipped = 'update_skipped_version';

  bool get updateCheck => _prefs.getBool(kUpdateCheck) ?? true;

  DateTime? get updateLastCheck {
    final ms = int.tryParse(_prefs.getString(kUpdateLastCheck) ?? '');
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  String? get updateSkippedVersion => _prefs.getString(kUpdateSkipped);

  bool get historyTimes => _prefs.getBool(kHistoryTimes) ?? true;

  String get density =>
      _prefs.getString(kDensity) == 'compact' ? 'compact' : 'comfortable';

  String get historyBooked {
    final v = _prefs.getString(kHistoryBooked);
    return v == 'show' || v == 'hide' ? v! : 'default';
  }

  bool? get historyShowBooked => switch (historyBooked) {
    'show' => true,
    'hide' => false,
    _ => null,
  };

  String get language => _prefs.getString(kLanguage) ?? 'system';

  String get themeMode {
    final v = _prefs.getString(kThemeMode);
    if (v == 'system' || v == 'dark' || v == 'light') return v!;
    return (_prefs.getBool(kUseDarkTheme) ?? true) ? 'dark' : 'light';
  }

  bool get crashReportingEnabled => _prefs.getBool(kCrashReporting) ?? true;

  bool get analyticsEnabled => _prefs.getBool(kAnalytics) ?? true;

  double get fontSize =>
      double.tryParse(_prefs.getString(kFontSize) ?? '') ?? 14;

  double get bookmarkPadding =>
      double.tryParse(_prefs.getString(kBookmarkPadding) ?? '') ?? 0;

  bool get showReadBookmarks => _prefs.getBool(kUnreadBookmarks) ?? true;

  bool get showReadHistory => _prefs.getBool(kUnreadHistory) ?? true;

  bool get displayReminders => _prefs.getBool(kDisplayReminders) ?? true;

  bool get displayVotingThumbs => _prefs.getBool(kDisplayVotingThumbs) ?? true;

  String? get unreadAppearance {
    final v = _prefs.getString(kUnreadAppearance);
    return v == null || v == 'null' ? null : v;
  }

  bool get refreshAfterWriteupSend =>
      _prefs.getBool(kRefreshAfterWriteupSend) ?? true;

  String get defaultView => _prefs.getString(kDefaultView) ?? '0';

  bool get notificationsEnabled =>
      _prefs.getBool(kNotificationsEnabled) ?? true;

  bool get backpressReturnsWriteup =>
      _prefs.getBool(kBackpressReturnsWriteup) ?? false;

  Future<bool> putBool(String key, bool value) => _prefs.setBool(key, value);

  Future<bool> putString(String key, String value) =>
      _prefs.setString(key, value);
}
