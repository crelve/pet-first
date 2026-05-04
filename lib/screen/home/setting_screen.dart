import 'package:flutter/material.dart';
import 'package:flutter_foundation/flutter_foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../../import/gen.dart';
import '../../import/route.dart';
import '../../import/utility.dart';
import '../../l10n/app_localizations.dart';

/// 設定画面
/// アプリの設定・管理機能
class SettingScreen extends HookConsumerWidget {
  /// 設定画面
  const SettingScreen({super.key, required this.scrollController});

  /// スクロールコントローラー
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ref.watch(appThemeProvider);
    final currentThemeMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      backgroundColor: AppleSemanticColors.groupedBackground(context),
      body: ListView(
        controller: scrollController,
        children: [
          hSpace(height: 24),
          // アプリ情報セクション
          IOSSettingsSection(
            children: [
              IOSSettingsTile(
                title: l10n.review(l10n.productName),
                icon: Icons.star_rounded,
                iconColor: ColorName.starGold,
                onTap: () {
                  ReviewService.requestReviewWithFallback(
                    ExternalPageList.iosAppReviewLink,
                  );
                },
              ),
              IOSSettingsTile(
                title: l10n.share(l10n.productName),
                icon: Icons.ios_share,
                iconColor: ColorName.appleGreen,
                onTap: () async {
                  const appLink = ExternalPageList.iosAppLink;
                  final shareMessage = l10n.shareMessage(
                    appLink,
                    l10n.productName,
                  );
                  await SharePlus.instance.share(
                    ShareParams(text: shareMessage),
                  );
                },
              ),
            ],
          ),
          hSpace(height: 32),
          // プレミアムセクション
          IOSSettingsSection(
            children: [
              SubscriptionSettingsTile(
                title: l10n.subscriptionSettingTitle,
                onTap: () {
                  const SubscriptionSettingScreenRoute().push<void>(context);
                },
              ),
            ],
          ),
          hSpace(height: 32),
          // 通知・推奨アプリセクション
          IOSSettingsSection(
            children: [
              IOSSettingsTile(
                title: l10n.pushNotification,
                icon: Icons.notifications_rounded,
                iconColor: ColorName.appleRed,
                onTap: () {
                  const PushScreenRoute().push<void>(context);
                },
              ),
              IOSSettingsTile(
                title: l10n.recommendApp,
                icon: Icons.apps_rounded,
                iconColor: ColorName.applePurple,
                onTap: () {
                  const RecommendAppScreenRoute().push<void>(context);
                },
              ),
            ],
          ),
          hSpace(height: 32),
          // 一般設定セクション
          IOSSettingsSection(
            children: [
              IOSSettingsTile(
                title: l10n.languageSetting,
                icon: Icons.language_rounded,
                iconColor: ColorName.appleBlue,
                onTap: () {
                  const LanguageSettingScreenRoute().push<void>(context);
                },
              ),
              IOSSettingsTile(
                title: l10n.themeSetting,
                icon: Icons.palette_rounded,
                iconColor: ColorName.appleLilac,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppleSemanticColors.tertiaryFill(context),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ThemeText(
                    text: currentThemeMode == ThemeMode.light
                        ? l10n.themeLight
                        : currentThemeMode == ThemeMode.dark
                        ? l10n.themeDark
                        : l10n.themeSystem,
                    color: AppleSemanticColors.secondaryLabel(context),
                    style: theme.textTheme.h30.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                onTap: () {
                  _showThemePicker(context, ref);
                },
              ),
              IOSSettingsTile(
                title: l10n.contact,
                icon: Icons.mail_rounded,
                iconColor: ColorName.appleBlue,
                onTap: () {
                  const ContactScreenRoute().push<void>(context);
                },
              ),
            ],
          ),
          hSpace(height: 32),
          // 法的情報セクション
          IOSSettingsSection(
            children: [
              IOSSettingsTile(
                title: l10n.legal,
                icon: Icons.gavel_rounded,
                iconColor: ColorName.appleGray,
                onTap: () {
                  openExternalBrowser(url: ExternalPageList.legal);
                },
              ),
              IOSSettingsTile(
                title: l10n.privacyPolicy,
                icon: Icons.privacy_tip_rounded,
                iconColor: ColorName.appleGray,
                onTap: () {
                  openExternalBrowser(url: ExternalPageList.privacyPolicy);
                },
              ),
              IOSSettingsTile(
                title: l10n.license,
                icon: Icons.article_rounded,
                iconColor: ColorName.appleGray,
                onTap: () async {
                  final packageInfo = await PackageInfo.fromPlatform();
                  if (!context.mounted) return;
                  showLicensePage(
                    context: context,
                    applicationName: l10n.productName,
                    applicationVersion: packageInfo.version,
                  );
                },
              ),
            ],
          ),
          // hSpace(height: 32),
          // // アカウント操作セクション
          // IOSSettingsSection(
          //   children: [
          //     IOSSettingsTile(
          //       title: l10n.logout,
          //                 //       icon: Icons.logout_rounded,
          //       iconColor: const Color(0xFFFF3B30),
          //       onTap: () {
          //         showDialog<void>(
          //           context: context,
          //           builder: (BuildContext context) {
          //             return TwoButtonDialog(
          //               title: l10n.logoutConfirmTitle,
          //                         //               content: l10n.logoutConfirmMessage,
          //               primaryText: l10n.confirm,
          //               secondaryText: l10n.cancel,
          //               primaryCallBack: () {
          //                 Navigator.of(context).pop();
          //                 ref
          //                     .read(authStateNotifierProvider.notifier)
          //                     .signOut();
          //                 const LoginScreenRoute().go(context);
          //               },
          //               secondaryCallBack: () {
          //                 Navigator.of(context).pop();
          //               },
          //             );
          //           },
          //         );
          //       },
          //     ),
          //   ],
          // ),
          hSpace(height: 32),
          // バージョン情報
          const Center(child: VersionText()),
          hSpace(height: 32),
        ],
      ),
    );
  }

  /// テーマ選択ボトムシートを表示
  void _showThemePicker(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppleSemanticColors.secondaryGroupedBackground(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              hSpace(height: 12),
              Container(
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: AppleSemanticColors.separator(context),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              hSpace(height: 16),
              _buildThemeOption(
                context,
                ref,
                l10n.themeLight,
                Icons.light_mode_rounded,
                ThemeMode.light,
              ),
              _buildThemeOption(
                context,
                ref,
                l10n.themeDark,
                Icons.dark_mode_rounded,
                ThemeMode.dark,
              ),
              _buildThemeOption(
                context,
                ref,
                l10n.themeSystem,
                Icons.brightness_auto_rounded,
                ThemeMode.system,
              ),
              hSpace(height: 8),
            ],
          ),
        );
      },
    );
  }

  /// テーマ選択オプション
  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    String title,
    IconData icon,
    ThemeMode mode,
  ) {
    final theme = ref.watch(appThemeProvider);
    final currentThemeMode = ref.watch(appThemeModeProvider);
    final isSelected = currentThemeMode == mode;

    return Material(
      color: ColorName.transparent,
      child: InkWell(
        onTap: () {
          ref.read(appThemeModeProvider.notifier).setThemeMode(mode);
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? theme.appColors.primary
                    : AppleSemanticColors.secondaryLabel(context),
                size: 24,
              ),
              wSpace(width: 16),
              Expanded(
                child: ThemeText(
                  text: title,
                  color: AppleSemanticColors.label(context),
                  style: theme.textTheme.h40.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check, color: theme.appColors.primary, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
