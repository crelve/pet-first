import 'package:flutter/material.dart';
import 'package:flutter_foundation/flutter_foundation.dart';
import 'package:flutter_foundation/l10n/app_localizations.dart' as core_l10n;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../import/hook.dart';
import '../import/provider.dart';
import 'l10n/app_localizations.dart' as app_l10n;

/// 最初に起動されるウィジェット(アプリ)
class App extends HookConsumerWidget {
  /// インスタンスを作成します
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final goRouter = ref.watch(goRouterProvider);
    final mediaQuery = ref.watch(mediaQueryStateNotifierProvider);
    final locale = ref.watch(localeProvider);

    useHandleTransit(context: context, ref: ref);
    useDeviceUserInitialization(ref: ref);

    return MaterialApp.router(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling, boldText: false),
          child: child!,
        );
      },
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      title:
          app_l10n.AppLocalizations.of(context)?.productName ?? 'Default Title',
      theme: theme.data,
      darkTheme: AppTheme.dark(mediaQuery).data,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        app_l10n.AppLocalizations.delegate,
        core_l10n.AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        // All 39 languages (fully translated)
        Locale('ja'), // Japanese
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('fr'), // French
        Locale('it'), // Italian
        Locale('ko'), // Korean
        Locale('zh'), // Chinese
        Locale('de'), // German
        Locale('pt'), // Portuguese
        Locale('hi'), // Hindi
        Locale('ar'), // Arabic
        Locale('ca'), // Catalan
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'), // zh-Hant
        Locale('hr'), // Croatian
        Locale('cs'), // Czech
        Locale('da'), // Danish
        Locale('nl'), // Dutch
        Locale('en', 'AU'), // English (Australia)
        Locale('en', 'CA'), // English (Canada)
        Locale('en', 'GB'), // English (UK)
        Locale('fi'), // Finnish
        Locale('fr', 'CA'), // French (Canada)
        Locale('el'), // Greek
        Locale('he'), // Hebrew
        Locale('hu'), // Hungarian
        Locale('id'), // Indonesian
        Locale('ms'), // Malay
        Locale('no'), // Norwegian
        Locale('pl'), // Polish
        Locale('pt', 'PT'), // Portuguese (Portugal)
        Locale('ro'), // Romanian
        Locale('ru'), // Russian
        Locale('sk'), // Slovak
        Locale('es', 'MX'), // Spanish (Mexico)
        Locale('sv'), // Swedish
        Locale('th'), // Thai
        Locale('tr'), // Turkish
        Locale('uk'), // Ukrainian
        Locale('vi'), // Vietnamese
      ],
    );
  }
}
