// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

class NyxPalette extends ThemeExtension<NyxPalette> {
  const NyxPalette({
    required this.link,
    required this.votePositive,
    required this.voteNegative,
    required this.text,
    required this.bookmarkUnread,
    required this.bookmarkRead,
  });

  final Color link;
  final Color votePositive;
  final Color voteNegative;
  final Color text;
  final Color bookmarkUnread;
  final Color bookmarkRead;

  static const dark = NyxPalette(
    link: Color(0xFFFFFFFF),
    votePositive: Color(0xFFCACACA),
    voteNegative: Color(0xFFFF0000),
    text: Color(0xFFFFFFFF),
    bookmarkUnread: Color(0xFFEEEEEE),
    bookmarkRead: Color(0xFF999999),
  );

  static const light = NyxPalette(
    link: Color(0xFF33B5E5),
    votePositive: Color(0xFF00DD00),
    voteNegative: Color(0xFFDD0000),
    text: Color(0xFF000000),
    bookmarkUnread: Color(0xFF000000),
    bookmarkRead: Color(0xFF777777),
  );

  static NyxPalette of(BuildContext context) =>
      Theme.of(context).extension<NyxPalette>() ??
      (Theme.of(context).brightness == Brightness.dark ? dark : light);

  @override
  bool operator ==(Object other) =>
      other is NyxPalette &&
      other.link == link &&
      other.votePositive == votePositive &&
      other.voteNegative == voteNegative &&
      other.text == text &&
      other.bookmarkUnread == bookmarkUnread &&
      other.bookmarkRead == bookmarkRead;

  @override
  int get hashCode => Object.hash(
    link,
    votePositive,
    voteNegative,
    text,
    bookmarkUnread,
    bookmarkRead,
  );

  @override
  NyxPalette copyWith({
    Color? link,
    Color? votePositive,
    Color? voteNegative,
    Color? text,
    Color? bookmarkUnread,
    Color? bookmarkRead,
  }) => NyxPalette(
    link: link ?? this.link,
    votePositive: votePositive ?? this.votePositive,
    voteNegative: voteNegative ?? this.voteNegative,
    text: text ?? this.text,
    bookmarkUnread: bookmarkUnread ?? this.bookmarkUnread,
    bookmarkRead: bookmarkRead ?? this.bookmarkRead,
  );

  @override
  NyxPalette lerp(ThemeExtension<NyxPalette>? other, double t) {
    if (other is! NyxPalette) return this;
    return NyxPalette(
      link: Color.lerp(link, other.link, t)!,
      votePositive: Color.lerp(votePositive, other.votePositive, t)!,
      voteNegative: Color.lerp(voteNegative, other.voteNegative, t)!,
      text: Color.lerp(text, other.text, t)!,
      bookmarkUnread: Color.lerp(bookmarkUnread, other.bookmarkUnread, t)!,
      bookmarkRead: Color.lerp(bookmarkRead, other.bookmarkRead, t)!,
    );
  }
}
