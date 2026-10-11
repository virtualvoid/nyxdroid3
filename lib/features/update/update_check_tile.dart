// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/widgets/section_card.dart';
import '../../app/widgets/tonal_icon.dart';
import '../../l10n/app_localizations.dart';
import 'update_service.dart';

class UpdateCheckSection extends ConsumerWidget {
  const UpdateCheckSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(updateServiceProvider).supported) {
      return const SizedBox.shrink();
    }
    return SectionCard(
      title: AppLocalizations.of(context).aboutUpdates,
      children: const [UpdateCheckTile()],
    );
  }
}

class UpdateCheckTile extends ConsumerStatefulWidget {
  const UpdateCheckTile({super.key});

  @override
  ConsumerState<UpdateCheckTile> createState() => _UpdateCheckTileState();
}

class _UpdateCheckTileState extends ConsumerState<UpdateCheckTile> {
  bool _checking = false;

  Future<void> _check() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final service = ref.read(updateServiceProvider);
    setState(() => _checking = true);
    try {
      final release = await service.checkNow();
      if (!mounted) return;
      if (release == null) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.updateUpToDate)));
      } else {
        await service.show(context, release);
      }
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.updateCheckFailed)));
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      key: const Key('about_check_update'),
      leading: const TonalIcon(Icons.system_update),
      title: Text(_checking ? l10n.updateChecking : l10n.updateCheckNow),
      trailing: _checking
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
      onTap: _checking ? null : _check,
    );
  }
}
