// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

class ComposeInputBar extends StatelessWidget {
  const ComposeInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.attachTooltip,
    required this.sendTooltip,
    required this.sending,
    required this.onAttach,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final String attachTooltip;
  final String sendTooltip;
  final bool sending;
  final VoidCallback onAttach;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainer,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                key: const Key('compose_attach'),
                tooltip: attachTooltip,
                icon: const Icon(Icons.attach_file),
                onPressed: onAttach,
              ),
              Expanded(
                child: TextField(
                  key: const Key('compose_message'),
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 1,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: hint,
                    isDense: true,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                key: const Key('compose_send'),
                tooltip: sendTooltip,
                icon: const Icon(Icons.send),
                onPressed: sending ? null : onSend,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
