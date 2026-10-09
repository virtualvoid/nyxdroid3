// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/feed_controller.dart';
import '../../core/feed_state.dart';
import '../../features/discussion/link_actions.dart';
import '../../features/push/push_message.dart';
import '../../features/push/push_service.dart';
import '../app_drawer.dart';
import '../app_resume_notifier.dart';
import '../drawer_edge.dart';
import 'common_widgets.dart';
import 'empty_refresh_list.dart';
import 'mail_badge_action.dart';
import 'notifications_badge_action.dart';
import 'refresh_action.dart';

class FeedScaffold<T> extends ConsumerStatefulWidget {
  const FeedScaffold({
    super.key,
    required this.provider,
    required this.title,
    required this.itemBuilder,
    this.refreshOnPush,
    this.showNotificationsBadge = true,
  });

  final NotifierProvider<FeedController<T>, FeedState<T>> provider;
  final String title;
  final Widget Function(BuildContext context, T item) itemBuilder;

  final bool Function(PushMessage message)? refreshOnPush;

  final bool showNotificationsBadge;

  @override
  ConsumerState<FeedScaffold<T>> createState() => _FeedScaffoldState<T>();
}

class _FeedScaffoldState<T> extends ConsumerState<FeedScaffold<T>> {
  FeedController<T> get _controller => ref.read(widget.provider.notifier);

  @override
  void initState() {
    super.initState();
    Future.microtask(_controller.refresh);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    listenForErrors(ref, context, widget.provider.select((s) => s.error));

    ref.listen(appResumeProvider, (_, _) => _controller.refresh());

    ref.listen(pushEventsProvider, (_, event) {
      final message = event.value;
      if (message != null && (widget.refreshOnPush?.call(message) ?? false)) {
        _controller.refresh();
      }
    });

    return Scaffold(
      drawer: const AppDrawer(),
      drawerEdgeDragWidth: drawerEdgeDragWidth(context),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (widget.showNotificationsBadge)
            NotificationsBadgeAction(
              unread: state.context?.user.unreadNotifications ?? 0,
              onPressed: () => openNotifications(context),
            ),
          MailBadgeAction(
            unreadMail: state.context?.user.unreadMail ?? 0,
            onPressed: () => openMail(context),
          ),
          RefreshAction(onPressed: _controller.refresh),
        ],
        bottom: loadingBar(state.loading),
      ),
      body: RefreshIndicator(
        onRefresh: _controller.refresh,
        child: state.items.isEmpty
            ? EmptyRefreshList(
                loading: state.loading,
                error: state.error,
                onRetry: _controller.refresh,
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: state.items.length,
                itemBuilder: (context, i) =>
                    widget.itemBuilder(context, state.items[i]),
              ),
      ),
    );
  }
}
