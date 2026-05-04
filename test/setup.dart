import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_foundation/import/utility.dart';

import 'package:flutter_test/flutter_test.dart';

/// Test setup for Firebase initialization
Future<void> setupFirebaseForTesting() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase for testing
    await Firebase.initializeApp();
  } on Exception catch (e) {
    // Ignore Firebase initialization errors in test environment
    logger.d('Firebase initialization skipped in test environment: $e');
  }
}

/// Test teardown for Firebase cleanup
Future<void> teardownFirebaseForTesting() async {
  try {
    // Clean up Firebase resources
    await Firebase.app().delete();
  } on Exception catch (e) {
    // Ignore Firebase cleanup errors in test environment
    logger.d('Firebase cleanup skipped in test environment: $e');
  }
}
