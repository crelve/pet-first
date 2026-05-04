import 'package:flutter/material.dart';
import 'package:flutter_foundation/flutter_foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../import/gen.dart';
import '../../l10n/app_localizations.dart';

/// サービス開始の案内ページ(ウォークスルーの構成ページ)
class ServiceBeginScreen extends HookConsumerWidget {
  /// サービス開始の案内ページ(ウォークスルーの構成ページ)
  const ServiceBeginScreen({super.key});

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
                ShadowImageCard(
                  shadowColor: AppleSemanticColors.label(
                    context,
                  ).withValues(alpha: 0.1),
                  child: Assets.image.walkThrough3.image(
                    width: 280,
                    height: 280,
                  ),
                ),
                hSpace(height: 32),
                ThemeText(
                  text: l10n.serviceBeginScreen,
                  color: AppleSemanticColors.label(context),
                  style: theme.textTheme.h60.bold(),
                  align: TextAlign.center,
                ),
                hSpace(height: 16),
                ThemeText(
                  text: l10n.serviceBeginContent,
                  color: AppleSemanticColors.label(context),
                  style: theme.textTheme.h30,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
