// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/router.dart';
import '../../l10n/app_localizations.dart';
import '../gallery/gallery_args.dart';
import '../gallery/gallery_image.dart';

void openDiscussion(BuildContext context, int discussionId, {int? postId}) {
  context.push(
    Uri(
      path: '/discussion/$discussionId',
      queryParameters: {if (postId != null) 'wuId': '$postId'},
    ).toString(),
  );
}

Future<int?> openGallery(
  BuildContext context,
  List<GalleryImage> images, {
  int startIndex = 0,
}) => context.push<int>(
  Routes.gallery,
  extra: GalleryArgs(images, startIndex: startIndex),
);

Future<int?> openImage(BuildContext context, String url) =>
    openGallery(context, [GalleryImage(url: url, thumbUrl: url)]);

void openMail(BuildContext context, {int? mailId}) => context.go(
  Uri(
    path: Routes.mail,
    queryParameters: {if (mailId != null) 'id': '$mailId'},
  ).toString(),
);

void openNotifications(BuildContext context) =>
    context.go(Routes.notifications);

Future<void> openExternal(BuildContext context, String url) async {
  final message = AppLocalizations.of(context).cantOpenIt;
  final messenger = ScaffoldMessenger.of(context);
  var ok = false;
  try {
    ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (_) {}
  if (!ok) messenger.showSnackBar(SnackBar(content: Text(message)));
}
