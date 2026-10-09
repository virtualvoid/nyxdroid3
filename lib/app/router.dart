// author: juraj.suchan@gmail.com

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers.dart';
import '../features/auth/authorization_screen.dart';
import '../features/auth/authorized_notifier.dart';
import '../features/bookmarks/bookmarks_controller.dart';
import '../features/bookmarks/bookmarks_screen.dart';
import '../features/discussion/compose_args.dart';
import '../features/discussion/compose_screen.dart';
import '../features/discussion/discussion_screen.dart';
import '../features/gallery/gallery_args.dart';
import '../features/gallery/gallery_grid_screen.dart';
import '../features/gallery/gallery_screen.dart';
import '../features/about/about_screen.dart';
import '../features/search/search_screen.dart';
import '../features/share/pending_share_notifier.dart';
import '../features/share/share_screen.dart';
import '../features/share/shared_content.dart';
import '../features/last/last_screen.dart';
import '../features/mail/mail_compose_args.dart';
import '../features/mail/mail_compose_screen.dart';
import '../features/mail/mail_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/settings/settings_screen.dart';

class Routes {
  Routes._();

  static const auth = '/auth';
  static const home = '/';
  static const mail = '/mail';
  static const bookmarks = '/bookmarks';
  static const history = '/history';
  static const notifications = '/notifications';
  static const last = '/last';
  static const settings = '/settings';
  static const about = '/about';
  static const share = '/share';
  static const search = '/search';
  static const gallery = '/gallery';
  static const galleryGrid = '/gallery-grid';
  static const compose = '/compose';
  static const mailCompose = '/mail/compose';
}

String routeForDefaultView(String value) => switch (value) {
  '0' || '1' => Routes.mail,
  '2' => Routes.bookmarks,
  '3' => Routes.history,
  '4' || '5' => Routes.notifications,
  _ => Routes.settings,
};

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen<bool>(authorizedProvider, (_, _) => refresh.value++);
  ref.listen<SharedContent?>(pendingShareProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: Routes.home,
    refreshListenable: refresh,
    redirect: (context, state) {
      final authorized = ref.read(authorizedProvider);
      final loc = state.matchedLocation;
      if (!authorized) return loc == Routes.auth ? null : Routes.auth;
      if (ref.read(pendingShareProvider) != null) {
        return loc == Routes.share ? null : Routes.share;
      }
      if (loc == Routes.auth || loc == Routes.home) {
        return routeForDefaultView(ref.read(appPrefsProvider).defaultView);
      }
      return null;
    },
    routes: [
      GoRoute(path: Routes.home, builder: (_, _) => const SizedBox.shrink()),
      GoRoute(
        path: Routes.auth,
        builder: (_, _) => const AuthorizationScreen(),
      ),
      GoRoute(
        path: Routes.bookmarks,
        builder: (_, _) => const BookmarksScreen(mode: BookmarksMode.bookmarks),
      ),
      GoRoute(
        path: Routes.history,
        builder: (_, _) => const BookmarksScreen(mode: BookmarksMode.history),
      ),
      GoRoute(
        path: Routes.mail,
        builder: (_, state) => MailScreen(
          mailId: int.tryParse(state.uri.queryParameters['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: Routes.notifications,
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(path: Routes.search, builder: (_, _) => const SearchScreen()),
      GoRoute(path: Routes.share, builder: (_, _) => const ShareScreen()),
      GoRoute(path: Routes.last, builder: (_, _) => const LastScreen()),
      GoRoute(path: Routes.settings, builder: (_, _) => const SettingsScreen()),
      GoRoute(path: Routes.about, builder: (_, _) => const AboutScreen()),
      GoRoute(
        path: '/discussion/:id',
        builder: (_, state) => DiscussionScreen(
          discussionId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
          title: state.uri.queryParameters['title'],
          wuId: int.tryParse(state.uri.queryParameters['wuId'] ?? ''),
        ),
      ),
      GoRoute(
        path: Routes.compose,
        builder: (_, state) => ComposeScreen(args: state.extra! as ComposeArgs),
      ),
      GoRoute(
        path: Routes.mailCompose,

        builder: (_, state) => MailComposeScreen(
          args:
              state.extra as MailComposeArgs? ??
              MailComposeArgs(
                recipient: state.uri.queryParameters['nick'] ?? '',
              ),
        ),
      ),
      GoRoute(
        path: Routes.gallery,
        builder: (_, state) => GalleryScreen(args: state.extra! as GalleryArgs),
      ),
      GoRoute(
        path: Routes.galleryGrid,
        builder: (_, state) => GalleryGridScreen(
          discussionId:
              int.tryParse(state.uri.queryParameters['id'] ?? '') ?? 0,
        ),
      ),
    ],
  );
});
