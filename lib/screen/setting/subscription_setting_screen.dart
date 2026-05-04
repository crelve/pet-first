import 'package:flutter/material.dart';
import 'package:flutter_foundation/flutter_foundation.dart';

import '../../import/gen.dart';
import '../../import/utility.dart';
import '../../l10n/app_localizations.dart';

/// サブスクリプション設定画面
class SubscriptionSettingScreen extends StatelessWidget {
  /// サブスクリプション設定画面
  const SubscriptionSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SubscriptionScreen(
      apiKey: Env.revenueCatAppleApiKey,
      flavor: Env.flavor,
      source: 'settings',
      config: SubscriptionScreenConfig(
        termsOfServiceUrl: ExternalPageList.legal,
        privacyPolicyUrl: ExternalPageList.privacyPolicy,
        headerImage: Assets.image.walkThrough1.image(fit: BoxFit.cover),
        primaryColor: ColorName.subscriptionPrimary,
        accentColor: ColorName.subscriptionAccent,
        badgeColor: ColorName.subscriptionBadge,
        trialDays: 7,
        benefits: [
          SubscriptionBenefit(
            icon: Icons.bar_chart_rounded,
            title: l10n.benefitFullAccess,
            description: l10n.benefitFullAccessDesc,
          ),
          SubscriptionBenefit(
            icon: Icons.favorite,
            title: l10n.benefitPremiumOnly,
            description: l10n.benefitPremiumOnlyDesc,
          ),
          SubscriptionBenefit(
            icon: Icons.people_alt_rounded,
            title: l10n.benefitUnlimited,
            description: l10n.benefitUnlimitedDesc,
          ),
          SubscriptionBenefit(
            icon: Icons.campaign_rounded,
            title: l10n.benefitNoAds,
            description: l10n.benefitNoAdsDesc,
          ),
        ],
      ),
    );
  }
}
