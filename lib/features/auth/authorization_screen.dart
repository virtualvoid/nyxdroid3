// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/widgets/common_widgets.dart';
import '../../l10n/app_localizations.dart';
import 'auth_controller.dart';
import 'auth_form_state.dart';
import 'auth_header.dart';
import 'auth_status_banner.dart';
import 'auth_step_card.dart';

class AuthorizationScreen extends ConsumerStatefulWidget {
  const AuthorizationScreen({super.key});

  @override
  ConsumerState<AuthorizationScreen> createState() =>
      _AuthorizationScreenState();
}

class _AuthorizationScreenState extends ConsumerState<AuthorizationScreen> {
  final _nick = TextEditingController();
  final _code = TextEditingController();

  @override
  void dispose() {
    _nick.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _confirmFinished() async {
    final l10n = AppLocalizations.of(context);
    final yes = await showConfirmDialog(
      context,
      title: l10n.warning,
      message: l10n.areYouSureAuthorizationIsComplete,
      yesLabel: l10n.yes,
      noLabel: l10n.no,
    );
    if (yes) {
      await ref.read(authFormProvider.notifier).finish();
    }
  }

  Future<void> _copyCode() async {
    final l10n = AppLocalizations.of(context);
    await Clipboard.setData(ClipboardData(text: _code.text));
    if (mounted) showSnack(context, l10n.authorizationCodeCopied);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final form = ref.watch(authFormProvider);

    ref.listen(authFormProvider.select((s) => s.code), (_, code) {
      if (_code.text != code) _code.text = code;
    });

    final message = switch (form.message) {
      AuthMessage.instructions => l10n.authorizationResultInstructions,
      AuthMessage.success => l10n.authorizationResultNew,
      AuthMessage.error => l10n.authorizationResultError,
    };

    final hasCode = form.code.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AuthHeader(),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 4,
                    child: form.busy
                        ? const LinearProgressIndicator(
                            key: Key('auth_busy'),
                            minHeight: 4,
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  AuthStepCard(
                    step: 1,
                    title: l10n.authorizationStepRequest,
                    done: hasCode,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          key: const Key('authorization_nick'),
                          controller: _nick,
                          enabled: form.canGetCode,
                          autocorrect: false,
                          enableSuggestions: false,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: l10n.authorizationNickLabel,
                            prefixIcon: const Icon(Icons.person_outline),
                            filled: true,
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (v) => ref
                              .read(authFormProvider.notifier)
                              .requestCode(v),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          icon: const Icon(Icons.vpn_key_outlined),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                          onPressed: form.canGetCode
                              ? () => ref
                                    .read(authFormProvider.notifier)
                                    .requestCode(_nick.text)
                              : null,
                          label: Text(l10n.authorizationGetCode),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AuthStatusBanner(message: form.message, text: message),
                  const SizedBox(height: 16),
                  AuthStepCard(
                    step: 2,
                    title: l10n.authorizationStepConfirm,
                    active: form.canFinish,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          key: const Key('authorization_code'),
                          controller: _code,
                          readOnly: true,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontFamily: 'monospace',
                            letterSpacing: 4,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            labelText: l10n.authorizationCodeLabel,
                            filled: true,
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              key: const Key('authorization_copy'),
                              tooltip: l10n.authorizationCopyCode,
                              icon: const Icon(Icons.copy),
                              onPressed: hasCode ? _copyCode : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          icon: const Icon(Icons.check),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                          onPressed: form.canFinish ? _confirmFinished : null,
                          label: Text(l10n.authorizationFinished),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
