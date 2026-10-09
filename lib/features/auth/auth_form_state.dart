// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_controller.dart';
import 'auth_form_controller.dart';

class AuthFormState {
  const AuthFormState({
    this.message = AuthMessage.instructions,
    this.code = '',
    this.busy = false,
    this.canGetCode = true,
    this.canFinish = false,
  });

  final AuthMessage message;
  final String code;
  final bool busy;
  final bool canGetCode;
  final bool canFinish;

  AuthFormState copyWith({
    AuthMessage? message,
    String? code,
    bool? busy,
    bool? canGetCode,
    bool? canFinish,
  }) => AuthFormState(
    message: message ?? this.message,
    code: code ?? this.code,
    busy: busy ?? this.busy,
    canGetCode: canGetCode ?? this.canGetCode,
    canFinish: canFinish ?? this.canFinish,
  );
}

final authFormProvider = NotifierProvider<AuthFormController, AuthFormState>(
  AuthFormController.new,
);
