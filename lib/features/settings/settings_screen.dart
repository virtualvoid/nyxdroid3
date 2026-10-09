// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_drawer.dart';
import '../../app/drawer_edge.dart';
import '../../app/widgets/common_widgets.dart';
import '../../core/image_cache.dart';
import '../../core/prefs/app_prefs.dart';
import '../../core/providers.dart';
import '../../core/telemetry/telemetry_gateway.dart';
import '../../l10n/app_localizations.dart';
import '../auth/authorized_notifier.dart';
import '../push/push_service.dart';
import 'choice_option.dart';
import 'choice_setting.dart';
import '../../app/widgets/section_card.dart';
import 'slider_setting.dart';
import 'switch_setting.dart';

enum _SettingsMenu { clearCredentials, clearCache }

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _clearCache(BuildContext context, WidgetRef ref) async {
    final done = AppLocalizations.of(context).done;
    await ref.read(imageCacheManagerProvider).emptyCache();
    if (context.mounted) showSnack(context, done);
  }

  Future<void> _clearCredentials(WidgetRef ref) async {
    await ref.read(authServiceProvider).logout();
    ref.read(authorizedProvider.notifier).set(false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prefs = ref.watch(appPrefsProvider);
    final notifier = ref.read(appPrefsProvider.notifier);

    String startView() => switch (prefs.defaultView) {
      '0' || '1' => '1',
      final v => v,
    };

    return Scaffold(
      drawer: const AppDrawer(),
      drawerEdgeDragWidth: drawerEdgeDragWidth(
        context,
        fraction: drawerNarrowFraction,
      ),
      appBar: AppBar(
        title: Text(l10n.menuSettings),
        actions: [
          PopupMenuButton<_SettingsMenu>(
            key: const Key('settings_menu'),
            onSelected: (v) => switch (v) {
              _SettingsMenu.clearCredentials => _clearCredentials(ref),
              _SettingsMenu.clearCache => _clearCache(context, ref),
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                key: const Key('menu_clear_credentials'),
                value: _SettingsMenu.clearCredentials,
                child: Text(l10n.clearCredentials),
              ),
              PopupMenuItem(
                key: const Key('menu_clear_cache'),
                value: _SettingsMenu.clearCache,
                child: Text(l10n.clearCache),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          SectionCard(
            title: l10n.settingsAppearance,
            children: [
              ChoiceSetting<String>(
                key: const Key('setting_language'),
                icon: Icons.language,
                title: l10n.settingsLanguage,
                summary: l10n.settingsLanguageSummary,
                value: prefs.language,
                options: [
                  ChoiceOption('system', l10n.languageSystem),
                  const ChoiceOption('en', 'English'),
                  const ChoiceOption('cs', 'Čeština'),
                ],
                onChanged: (v) => notifier.setString(AppPrefs.kLanguage, v),
              ),
              ChoiceSetting<String>(
                key: const Key('setting_theme'),
                icon: Icons.dark_mode_outlined,
                title: l10n.settingsTheme,
                summary: l10n.settingsThemeSummary,
                value: prefs.themeMode,
                options: [
                  ChoiceOption('system', l10n.themeSystem),
                  ChoiceOption('dark', l10n.themeDark),
                  ChoiceOption('light', l10n.themeLight),
                ],
                onChanged: (v) => notifier.setString(AppPrefs.kThemeMode, v),
              ),
              ChoiceSetting<String>(
                key: const Key('setting_unread_style'),
                icon: Icons.palette_outlined,
                title: l10n.settingsUnreadStyle,
                summary: l10n.settingsUnreadStyleSummary,
                value: prefs.unreadAppearance ?? 'null',
                options: [
                  ChoiceOption('null', l10n.unreadStyleStandard),
                  ChoiceOption('#dd0000', l10n.unreadStyleRed),
                  ChoiceOption('#ff7f00', l10n.unreadStyleOrange),
                  ChoiceOption('#ffff00', l10n.unreadStyleYellow),
                  ChoiceOption('#00ee00', l10n.unreadStyleGreen),
                ],
                onChanged: (v) =>
                    notifier.setString(AppPrefs.kUnreadAppearance, v),
              ),
              SliderSetting(
                key: const Key('setting_font_size'),
                icon: Icons.text_fields,
                title: l10n.settingsFontSize,
                value: prefs.fontSize,
                min: 12,
                max: 30,
                onChanged: (v) => notifier.setString(
                  AppPrefs.kFontSize,
                  v.round().toString(),
                ),
              ),
              ChoiceSetting<String>(
                key: const Key('setting_padding'),
                icon: Icons.format_line_spacing,
                title: l10n.settingsRowPadding,
                summary: l10n.settingsRowPaddingSummary,
                value: prefs.bookmarkPadding.round().toString(),
                options: [
                  ChoiceOption('0', l10n.paddingStandard),
                  ChoiceOption('2', l10n.paddingGreater),
                  ChoiceOption('4', l10n.paddingLarge),
                  ChoiceOption('6', l10n.paddingHuge),
                  ChoiceOption('8', l10n.paddingMega),
                  ChoiceOption('16', l10n.paddingShovel),
                ],
                onChanged: (v) =>
                    notifier.setString(AppPrefs.kBookmarkPadding, v),
              ),
              ChoiceSetting<String>(
                key: const Key('setting_density'),
                icon: Icons.density_small,
                title: l10n.settingsDensity,
                summary: l10n.settingsDensitySummary,
                value: prefs.density,
                options: [
                  ChoiceOption('compact', l10n.densityCompact),
                  ChoiceOption('comfortable', l10n.densityComfortable),
                ],
                onChanged: (v) => notifier.setString(AppPrefs.kDensity, v),
              ),
              SwitchSetting(
                key: const Key('setting_voting_thumbs'),
                icon: Icons.thumbs_up_down_outlined,
                title: l10n.settingsDisplayRating,
                summaryOn: l10n.settingsRatingOn,
                summaryOff: l10n.settingsRatingOff,
                value: prefs.displayVotingThumbs,
                onChanged: (v) =>
                    notifier.setBool(AppPrefs.kDisplayVotingThumbs, v),
              ),
            ],
          ),
          SectionCard(
            title: l10n.settingsMisc,
            children: [
              ChoiceSetting<String>(
                key: const Key('setting_default_view'),
                icon: Icons.rocket_launch_outlined,
                title: l10n.settingsStartup,
                summary: l10n.settingsStartupSummary,
                value: startView(),
                options: [
                  ChoiceOption('1', l10n.menuMail),
                  ChoiceOption('2', l10n.menuBookmarks),
                  ChoiceOption('3', l10n.menuHistory),
                  ChoiceOption('4', l10n.menuNotifications),
                ],
                onChanged: (v) => notifier.setString(AppPrefs.kDefaultView, v),
              ),
              SwitchSetting(
                key: const Key('setting_read_bookmarks'),
                icon: Icons.bookmark_border,
                title: l10n.settingsReadBookmarks,
                summaryOn: l10n.settingsAlwaysDisplay,
                summaryOff: l10n.settingsDontDisplay,
                value: prefs.showReadBookmarks,
                onChanged: (v) =>
                    notifier.setBool(AppPrefs.kUnreadBookmarks, v),
              ),
              SwitchSetting(
                key: const Key('setting_read_history'),
                icon: Icons.history,
                title: l10n.settingsReadHistory,
                summaryOn: l10n.settingsAlwaysDisplay,
                summaryOff: l10n.settingsDontDisplay,
                value: prefs.showReadHistory,
                onChanged: (v) => notifier.setBool(AppPrefs.kUnreadHistory, v),
              ),
              ChoiceSetting<String>(
                key: const Key('setting_history_booked'),
                icon: Icons.bookmarks_outlined,
                title: l10n.settingsHistoryBooked,
                summary: l10n.settingsHistoryBookedSummary,
                value: prefs.historyBooked,
                options: [
                  ChoiceOption('default', l10n.historyBookedDefault),
                  ChoiceOption('show', l10n.historyBookedShow),
                  ChoiceOption('hide', l10n.historyBookedHide),
                ],
                onChanged: (v) =>
                    notifier.setString(AppPrefs.kHistoryBooked, v),
              ),
              SwitchSetting(
                key: const Key('setting_backpress'),
                icon: Icons.arrow_back,
                title: l10n.settingsBackButton,
                summaryOn: l10n.settingsBackWriteups,
                summaryOff: l10n.settingsBackRegular,
                value: prefs.backpressReturnsWriteup,
                onChanged: (v) =>
                    notifier.setBool(AppPrefs.kBackpressReturnsWriteup, v),
              ),
              SwitchSetting(
                key: const Key('setting_refresh_after_send'),
                icon: Icons.refresh,
                title: l10n.settingsRefreshAfterSend,
                summaryOn: l10n.settingsAlways,
                summaryOff: l10n.settingsNever,
                value: prefs.refreshAfterWriteupSend,
                onChanged: (v) =>
                    notifier.setBool(AppPrefs.kRefreshAfterWriteupSend, v),
              ),
              SwitchSetting(
                key: const Key('setting_reminders'),
                icon: Icons.alarm,
                title: l10n.settingsReminders,
                summaryOn: l10n.settingsRemindersOn,
                summaryOff: l10n.settingsRemindersOff,
                value: prefs.displayReminders,
                onChanged: (v) =>
                    notifier.setBool(AppPrefs.kDisplayReminders, v),
              ),
            ],
          ),
          SectionCard(
            title: l10n.settingsPrivacy,
            children: [
              SwitchSetting(
                key: const Key('setting_crash_reporting'),
                icon: Icons.bug_report_outlined,
                title: l10n.settingsCrashReporting,
                summaryOn: l10n.settingsCrashReportingOn,
                summaryOff: l10n.settingsCrashReportingOff,
                value: prefs.crashReportingEnabled,
                onChanged: (v) async {
                  await notifier.setBool(AppPrefs.kCrashReporting, v);
                  await ref
                      .read(telemetryGatewayProvider)
                      .setCrashReporting(
                        v,
                        nick: ref.read(authStoreProvider).nick,
                      );
                },
              ),
              SwitchSetting(
                key: const Key('setting_analytics'),
                icon: Icons.insights_outlined,
                title: l10n.settingsAnalytics,
                summaryOn: l10n.settingsAnalyticsOn,
                summaryOff: l10n.settingsAnalyticsOff,
                value: prefs.analyticsEnabled,
                onChanged: (v) async {
                  await notifier.setBool(AppPrefs.kAnalytics, v);
                  await ref
                      .read(telemetryGatewayProvider)
                      .setAnalytics(v, nick: ref.read(authStoreProvider).nick);
                },
              ),
            ],
          ),
          SectionCard(
            title: l10n.settingsNotifications,
            children: [
              SwitchSetting(
                key: const Key('setting_notifications'),
                icon: Icons.notifications_outlined,
                title: l10n.settingsNotifications,
                summaryOn: l10n.settingsNotificationsOn,
                summaryOff: l10n.settingsNotificationsOff,
                value: prefs.notificationsEnabled,
                onChanged: (v) async {
                  await notifier.setBool(AppPrefs.kNotificationsEnabled, v);
                  await ref.read(pushServiceProvider).setEnabled(v);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
