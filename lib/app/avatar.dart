// author: juraj.suchan@gmail.com

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/image_cache.dart';

typedef AvatarBuilder = Widget Function(String nick, double size);

String avatarUrl(String nick) {
  final up = nick.toUpperCase();
  return 'https://nyx.cz/${up[0]}/$up.gif';
}

Widget _placeholder(double size) => Image.asset(
  'assets/empty_avatar.png',
  width: size,
  height: size,
  errorBuilder: (_, _, _) => Icon(Icons.person, size: size),
);

Widget _defaultAvatar(String nick, double size) {
  if (nick.isEmpty) return _placeholder(size);
  return CachedNetworkImage(
    imageUrl: avatarUrl(nick),
    cacheManager: nyxCacheManager,
    width: size,
    height: size,
    fit: BoxFit.cover,
    placeholder: (_, _) => _placeholder(size),
    errorWidget: (_, _, _) => _placeholder(size),
  );
}

final avatarBuilderProvider = Provider<AvatarBuilder>((ref) => _defaultAvatar);

class NickAvatar extends ConsumerWidget {
  const NickAvatar({super.key, required this.nick, this.size = 50});

  final String nick;
  final double size;

  static const radiusFactor = 0.22;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClipRRect(
    key: const Key('nick_avatar_clip'),
    borderRadius: BorderRadius.circular(size * radiusFactor),
    child: ref.watch(avatarBuilderProvider)(nick, size),
  );
}
