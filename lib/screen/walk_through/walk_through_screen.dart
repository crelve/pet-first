import 'package:flutter/material.dart';
import 'package:flutter_foundation/flutter_foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../import/provider.dart';
import '../../l10n/app_localizations.dart';

/// ウォークスルー画面
class WalkThroughScreen extends WalkThroughScreenBase {
  /// ウォークスルー画面
  const WalkThroughScreen({super.key});

  @override
  NotifierProvider<WalkThroughStateNotifier, WalkThroughState>
  get notifierProvider => walkThroughStateNotifierProvider;

  @override
  String getNextButtonText(BuildContext context, bool isLastStep) {
    final l10n = AppLocalizations.of(context)!;
    return isLastStep ? l10n.signUp : l10n.next;
  }

  @override
  String getSkipText(BuildContext context) {
    return AppLocalizations.of(context)!.skip;
  }
}
