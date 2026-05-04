import 'package:flutter/material.dart';
import 'package:flutter_foundation/flutter_foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../import/utility.dart';
import '../../l10n/app_localizations.dart';

/// AIデータ同意画面（ウォークスルーの構成ページ）
class AiConsentScreen extends HookConsumerWidget {
  /// AIデータ同意画面（ウォークスルーの構成ページ）
  const AiConsentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ref.watch(appThemeProvider);

    return ColoredBox(
      color: AppleSemanticColors.background(context),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppleSemanticColors.secondaryGroupedBackground(
                      context,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.privacy_tip_rounded,
                    size: 60,
                    color: theme.appColors.primary,
                  ),
                ),
                hSpace(height: 32),
                ThemeText(
                  text: l10n.aiConsentScreen,
                  color: AppleSemanticColors.label(context),
                  style: theme.textTheme.h60.bold(),
                  align: TextAlign.center,
                ),
                hSpace(height: 16),
                ThemeText(
                  text: l10n.aiConsentContent,
                  color: AppleSemanticColors.secondaryLabel(context),
                  style: theme.textTheme.h30,
                  align: TextAlign.center,
                ),
                hSpace(height: 24),
                GestureDetector(
                  onTap: () {
                    openExternalBrowser(url: ExternalPageList.privacyPolicy);
                  },
                  child: ThemeText(
                    text: l10n.aiConsentPrivacyLink,
                    color: theme.appColors.primary,
                    style: theme.textTheme.h30,
                    align: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
