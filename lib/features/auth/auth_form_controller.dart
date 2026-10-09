// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import 'auth_controller.dart';
import 'auth_form_state.dart';
import 'authorized_notifier.dart';

class AuthFormController extends Notifier<AuthFormState> {
  @override
  AuthFormState build() => const AuthFormState();

  Future<void> requestCode(String nick) async {
    if (nick.trim().isEmpty || state.busy) return;

    state = state.copyWith(busy: true, canGetCode: false);
    try {
      final result = await ref.read(authServiceProvider).requestCode(nick);
      final isNew = result?.isNew ?? false;
      state = state.copyWith(
        busy: false,
        message: isNew ? AuthMessage.success : AuthMessage.error,
        code: isNew ? result!.confirmationCode : state.code,
        canFinish: isNew,
        canGetCode: !isNew,
      );
    } catch (_) {
      state = state.copyWith(
        busy: false,
        message: AuthMessage.error,
        canGetCode: true,
        canFinish: false,
      );
    }
  }

  Future<void> finish() async {
    if (await ref.read(authServiceProvider).confirm()) {
      ref.read(authorizedProvider.notifier).set(true);
    }
  }
}
