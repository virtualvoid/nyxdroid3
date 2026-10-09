// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;

PreferredSizeWidget? loadingBar(bool loading) => loading
    ? const PreferredSize(
        preferredSize: Size.fromHeight(2),
        child: LinearProgressIndicator(minHeight: 2),
      )
    : null;

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String yesLabel,
  required String noLabel,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(noLabel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(yesLabel),
        ),
      ],
    ),
  );
  return result == true;
}

void showSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

void listenForErrors(
  WidgetRef ref,
  BuildContext context,
  ProviderListenable<Object?> error,
) {
  ref.listen(error, (_, e) {
    if (e != null) showSnack(context, '$e');
  });
}
