// author: juraj.suchan@gmail.com

import 'dart:ui';

import '../core/prefs/app_prefs.dart';
import '../core/prefs/theme_mode_pref.dart';
import 'nyx_palette.dart';

class Appearance {
  const Appearance({
    required this.isDark,
    required this.fontSize,
    required this.bookmarkPadding,
    this.displayVotingThumbs = true,
    this.entryUnreadColor,
    this.compact = false,
  });

  factory Appearance.fromPrefs(AppPrefs prefs, {bool systemDark = true}) =>
      Appearance(
        isDark: isDarkFor(prefs.themeMode, systemDark: systemDark),
        fontSize: prefs.fontSize,
        bookmarkPadding: prefs.bookmarkPadding,
        displayVotingThumbs: prefs.displayVotingThumbs,
        entryUnreadColor: _parseColor(prefs.unreadAppearance),
        compact: prefs.density == 'compact',
      );

  final bool isDark;
  final double fontSize;
  final double bookmarkPadding;
  final bool displayVotingThumbs;
  final bool compact;

  final Color? entryUnreadColor;

  static Color? _parseColor(String? hex) {
    if (hex == null) return null;
    final v = int.tryParse(hex.replaceFirst('#', ''), radix: 16);
    return v == null ? null : Color(0xFF000000 | v);
  }

  NyxPalette get palette => isDark ? NyxPalette.dark : NyxPalette.light;

  Color get linkColor => palette.link;

  Color get votePositiveColor => palette.votePositive;
  Color get voteNegativeColor => palette.voteNegative;

  Color get textColor => palette.text;

  Color get bookmarkUnreadColor => palette.bookmarkUnread;

  Color get bookmarkReadColor => palette.bookmarkRead;
}
