// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_drawer.dart';
import '../../app/drawer_edge.dart';
import '../../app/widgets/section_card.dart';
import '../../app/widgets/tonal_icon.dart';
import '../../l10n/app_localizations.dart';
import '../discussion/link_actions.dart';
import 'about_credits.dart';
import 'app_version_provider.dart';

const aboutSourceUrl = 'https://github.com/virtualvoid/nyxdroid2027';
const aboutWebsiteUrl = 'https://nyx.cz';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final version = ref.watch(appVersionProvider).value ?? '';
    final title = '${l10n.appName} $version'.trim();

    return Scaffold(
      drawer: const AppDrawer(),
      drawerEdgeDragWidth: drawerEdgeDragWidth(context),
      appBar: AppBar(title: Text(l10n.menuAbout)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Material(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/splash/splash_logo.png',
                      key: const Key('about_logo'),
                      width: 96,
                      height: 96,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      key: const Key('about_title'),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SectionCard(
            title: l10n.aboutBroughtBy,
            children: const [
              ListTile(
                title: Text(
                  'VIRTUALVOID',
                  key: Key('about_vendor'),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          SectionCard(
            title: l10n.aboutThanks,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final nick in aboutCredits)
                      Chip(
                        label: Text(nick),
                        backgroundColor: scheme.secondaryContainer,
                        labelStyle: TextStyle(
                          color: scheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                        side: BorderSide.none,
                      ),
                  ],
                ),
              ),
            ],
          ),
          SectionCard(
            title: l10n.aboutInformation,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.aboutDisclaimer,
                  key: const Key('about_disclaimer'),
                  style: TextStyle(height: 1.4, color: scheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
          SectionCard(
            title: l10n.aboutLinks,
            children: [
              ListTile(
                key: const Key('about_link_source'),
                leading: const TonalIcon(Icons.code),
                title: Text(l10n.aboutSourceCode),
                subtitle: const Text('github.com/virtualvoid/nyxdroid2027'),
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () => openExternal(context, aboutSourceUrl),
              ),
              ListTile(
                key: const Key('about_link_nyx'),
                leading: const TonalIcon(Icons.public),
                title: const Text('nyx.cz'),
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () => openExternal(context, aboutWebsiteUrl),
              ),
              ListTile(
                key: const Key('about_link_licenses'),
                leading: const TonalIcon(Icons.description_outlined),
                title: Text(l10n.aboutLicenses),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: l10n.appName,
                  applicationVersion: version.isEmpty ? null : version,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
