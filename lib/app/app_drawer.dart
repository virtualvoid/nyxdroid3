// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers.dart';
import '../features/mail/mail_controller.dart';
import '../features/notifications/status_counts_provider.dart';
import '../l10n/app_localizations.dart';
import 'avatar.dart';
import 'drawer_entry.dart';
import 'router.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final nick = ref.watch(authStoreProvider).nick ?? '';
    final current = GoRouterState.of(context).matchedLocation;

    final mail = ref.watch(mailNotificationProvider).value;
    final unreadMail = mail != null && mail.valid && current != Routes.mail
        ? mail.count
        : 0;

    final status = ref.watch(statusCountsProvider).value;
    final unreadNotifications =
        status != null && current != Routes.notifications
        ? status.notifications
        : 0;

    final entries = <DrawerEntry>[
      DrawerEntry(
        Routes.mail,
        Icons.mail_outline,
        l10n.menuMail,
        badge: unreadMail,
      ),
      DrawerEntry(Routes.bookmarks, Icons.bookmark_border, l10n.menuBookmarks),
      DrawerEntry(Routes.history, Icons.history, l10n.menuHistory),
      DrawerEntry(
        Routes.notifications,
        Icons.lightbulb_outline,
        l10n.menuNotifications,
        badge: unreadNotifications,
      ),
      DrawerEntry(Routes.last, Icons.rss_feed, l10n.menuLast),
      DrawerEntry(Routes.search, Icons.search, l10n.menuSearch),
      DrawerEntry(Routes.settings, Icons.settings_outlined, l10n.menuSettings),
      DrawerEntry(Routes.about, Icons.info_outline, l10n.menuAbout),
    ];

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  NickAvatar(nick: nick, size: 64),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      nick.toUpperCase(),
                      key: const Key('drawer_nick'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(indent: 20, endIndent: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                children: [
                  for (final e in entries)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        key: Key('drawer_${e.route}'),
                        shape: const StadiumBorder(),
                        selectedTileColor: scheme.secondaryContainer,
                        selectedColor: scheme.onSecondaryContainer,
                        leading: Icon(e.icon),
                        title: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: e.title),
                              if (e.badge > 0)
                                TextSpan(
                                  text: ' (${e.badge})',
                                  style: TextStyle(
                                    color: scheme.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        selected: current == e.route,
                        onTap: () {
                          Navigator.of(context).pop();
                          if (current != e.route) context.go(e.route);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
