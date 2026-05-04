import 'package:flutter_foundation/flutter_foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../import/route.dart';

/// GoRouterのインスタンスを管理するプロバイダ
final goRouterProvider = Provider<GoRouter>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final isInitialLaunch =
      prefs.getBool(SharedPreferencesKeys.initialLaunchKey) ?? true;
  if (isInitialLaunch) {
    prefs.setBool(SharedPreferencesKeys.initialLaunchKey, false);
  }
  final initialLocation = isInitialLaunch
      ? const WalkThroughRoute().location
      // : const WalkThroughRoute().location;
      : const BaseScreenRoute().location;

  return GoRouter(
    initialLocation: initialLocation,
    routes: $appRoutes,
    observers: [
      AdNavigatorObserver(ref: ref),
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ],
  );
});
