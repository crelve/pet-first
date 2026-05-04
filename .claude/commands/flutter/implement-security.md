# 認証・セキュリティ実装ガイド

**役割**: Flutter セキュリティ実装専門家
**目的**: セキュリティ要件に基づく認証・セキュリティ機能の実装

## 🎯 このコマンドの対象

Phase 2.5: 認証・セキュリティ実装（セキュリティ要件に基づく）
- 指定された認証方式の実装
- データ暗号化の実装
- GDPR対応の実装
- セキュリティベストプラクティス

## 📋 事前準備

### セキュリティ要件の確認
```bash
# セキュリティ要件を確認
echo "🔒 セキュリティ要件確認中..."
cat docs/project/requirements.json | jq '.security'

# 認証方式を確認
AUTH_METHODS=$(cat docs/project/requirements.json | jq -r '.security.authMethods[]' | tr '\n' ',' | sed 's/,$//')
echo "実装すべき認証方式: $AUTH_METHODS"

# データ暗号化要件を確認
DATA_ENCRYPTION=$(cat docs/project/requirements.json | jq -r '.security.dataEncryption // false')
echo "データ暗号化要件: $DATA_ENCRYPTION"

# GDPR対応要件を確認
GDPR_COMPLIANCE=$(cat docs/project/requirements.json | jq -r '.security.gdprCompliance // false')
echo "GDPR対応要件: $GDPR_COMPLIANCE"
```

### 現在のセキュリティ実装確認
```bash
# 既存の認証関連ファイルを確認
find lib -name "*auth*" -type f | head -10
find lib -name "*security*" -type f | head -10
```

## 🔐 認証実装ステップ

### Step 1: Firebase Authentication基盤セットアップ

#### 1.1 依存関係の追加
```bash
# Firebase Auth 関連パッケージ
fvm flutter pub add firebase_auth
fvm flutter pub add firebase_core

# 必要に応じて追加（認証方式によって）
fvm flutter pub add google_sign_in      # Google認証
fvm flutter pub add sign_in_with_apple  # Apple認証
fvm flutter pub add crypto              # パスワードハッシュ化
```

#### 1.2 Firebase設定の確認
```bash
# Firebase設定ファイルの存在確認
ls firebase_options.dart
ls ios/Runner/GoogleService-Info.plist
```

### Step 2: 認証方式別実装

#### 2.1 Email/Password認証

```dart
// lib/service/auth/email_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('ユーザーが見つかりません');
      case 'wrong-password':
        return Exception('パスワードが間違っています');
      case 'weak-password':
        return Exception('パスワードが弱すぎます');
      case 'email-already-in-use':
        return Exception('このメールアドレスは既に使用されています');
      default:
        return Exception('認証エラー: ${e.message}');
    }
  }
}
```

#### 2.2 Google Sign-In認証

```dart
// lib/service/auth/google_auth_service.dart
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Google認証に失敗しました: $e');
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}
```

#### 2.3 Apple Sign-In認証

```dart
// lib/service/auth/apple_auth_service.dart
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      return await _auth.signInWithCredential(oauthCredential);
    } catch (e) {
      throw Exception('Apple認証に失敗しました: $e');
    }
  }
}
```

#### 2.4 匿名認証

```dart
// lib/service/auth/anonymous_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AnonymousAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } catch (e) {
      throw Exception('匿名ログインに失敗しました: $e');
    }
  }

  Future<UserCredential> linkWithEmailAndPassword(
    String email, 
    String password,
  ) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('ユーザーがログインしていません');

    final credential = EmailAuthProvider.credential(
      email: email, 
      password: password,
    );
    
    return await user.linkWithCredential(credential);
  }
}
```

### Step 3: 統合認証サービス

#### 3.1 認証サービスの統合
```dart
// lib/service/auth/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'email_auth_service.dart';
import 'google_auth_service.dart';
import 'apple_auth_service.dart';
import 'anonymous_auth_service.dart';

class AuthService {
  final EmailAuthService _emailAuth = EmailAuthService();
  final GoogleAuthService _googleAuth = GoogleAuthService();
  final AppleAuthService _appleAuth = AppleAuthService();
  final AnonymousAuthService _anonymousAuth = AnonymousAuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 現在のユーザー
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Email/Password認証
  Future<UserCredential> signUpWithEmail(String email, String password) =>
      _emailAuth.signUp(email, password);

  Future<UserCredential> signInWithEmail(String email, String password) =>
      _emailAuth.signIn(email, password);

  // Google認証
  Future<UserCredential?> signInWithGoogle() => _googleAuth.signInWithGoogle();

  // Apple認証
  Future<UserCredential?> signInWithApple() => _appleAuth.signInWithApple();

  // 匿名認証
  Future<UserCredential> signInAnonymously() => 
      _anonymousAuth.signInAnonymously();

  // サインアウト
  Future<void> signOut() async {
    if (await _googleAuth._googleSignIn.isSignedIn()) {
      await _googleAuth.signOut();
    } else {
      await _auth.signOut();
    }
  }
}
```

#### 3.2 認証状態管理
```dart
// lib/provider/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth/auth_service.dart';
import '../model/auth_state.dart';

final authServiceProvider = Provider((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.read(authServiceProvider);
  return authService.authStateChanges;
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState.initial());

  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.signInWithEmail(email, password);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.signInWithGoogle();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = AuthState.initial();
  }
}
```

## 🔒 データ暗号化実装

### Step 4: データ暗号化（要件に応じて）

#### 4.1 ローカルデータ暗号化
```dart
// lib/service/encryption/encryption_service.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const _storage = FlutterSecureStorage();
  static const _keyName = 'encryption_key';

  Future<String> encryptData(String data) async {
    final key = await _getOrCreateKey();
    // 実際の暗号化実装（AES等）
    return base64Encode(utf8.encode(data + key));
  }

  Future<String> decryptData(String encryptedData) async {
    final key = await _getOrCreateKey();
    // 実際の復号化実装
    final decoded = base64Decode(encryptedData);
    return utf8.decode(decoded).replaceAll(key, '');
  }

  Future<String> _getOrCreateKey() async {
    String? key = await _storage.read(key: _keyName);
    if (key == null) {
      key = _generateKey();
      await _storage.write(key: _keyName, value: key);
    }
    return key;
  }

  String _generateKey() {
    final bytes = utf8.encode(DateTime.now().millisecondsSinceEpoch.toString());
    return sha256.convert(bytes).toString();
  }
}
```

#### 4.2 Secure Storage実装
```dart
// lib/service/storage/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );

  Future<void> storeSecurely(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getSecurely(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteSecurely(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

## 🇪🇺 GDPR対応実装

### Step 5: GDPR対応（要件に応じて）

#### 5.1 プライバシーポリシー表示
```dart
// lib/screen/privacy/privacy_policy_screen.dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseHeader(title: Text('プライバシーポリシー')),
      body: WebView(
        initialUrl: 'https://your-domain.com/privacy-policy',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
```

#### 5.2 データ削除機能
```dart
// lib/service/gdpr/data_deletion_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../storage/secure_storage_service.dart';

class DataDeletionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SecureStorageService _secureStorage = SecureStorageService();

  Future<void> deleteAllUserData() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('ユーザーがログインしていません');

    // Firestoreからユーザーデータを削除
    await _deleteFirestoreUserData(user.uid);
    
    // ローカルストレージを削除
    await _secureStorage.clearAll();
    
    // Firebase Authからユーザーアカウントを削除
    await user.delete();
  }

  Future<void> _deleteFirestoreUserData(String uid) async {
    // ユーザー関連のコレクションを削除
    final collections = ['users', 'user_data', 'user_preferences'];
    
    for (final collection in collections) {
      final docs = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: uid)
          .get();
      
      for (final doc in docs.docs) {
        await doc.reference.delete();
      }
    }
  }
}
```

#### 5.3 Cookie同意管理
```dart
// lib/service/gdpr/cookie_consent_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class CookieConsentService {
  static const String _consentKey = 'cookie_consent';

  Future<bool> hasConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_consentKey) ?? false;
  }

  Future<void> giveConsent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, true);
  }

  Future<void> revokeConsent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, false);
  }
}
```

## 🧪 セキュリティテスト・検証

### Step 6: セキュリティテスト

#### 6.1 認証テスト
```dart
// test/service/auth_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../lib/service/auth/auth_service.dart';

void main() {
  group('AuthService', () {
    test('should sign in with email and password', () async {
      // 認証テストの実装
    });

    test('should handle authentication errors', () async {
      // エラーハンドリングテスト
    });
  });
}
```

#### 6.2 セキュリティ設定の確認
```bash
# iOS セキュリティ設定確認
cat ios/Runner/Info.plist | grep -A 5 -B 5 Security
```

#### 6.3 データ暗号化テスト
```bash
# 暗号化されたデータの確認
echo "ローカルストレージのデータが暗号化されていることを確認してください"
```

## 📋 完了チェックリスト

- [ ] 要件で指定された認証方式がすべて実装されている
- [ ] 認証エラーハンドリングが適切に実装されている
- [ ] データ暗号化が要件通りに実装されている（必要な場合のみ）
- [ ] GDPR対応機能が実装されている（必要な場合のみ）
- [ ] セキュアストレージが適切に使用されている
- [ ] プライバシーポリシーが表示される
- [ ] データ削除機能が動作する（GDPR対応時のみ）
- [ ] 認証関連のテストが通過している
- [ ] セキュリティ設定が適切に構成されている
- [ ] 静的解析でセキュリティ警告がない

## 🔄 次のステップ

認証・セキュリティ実装完了後は、以下に進んでください：
- **Phase 2.6**: 収益化実装
- または `/monetization-complete` コマンドを実行

## 🆘 トラブルシューティング

### よくある問題

#### 1. Firebase Auth設定エラー
```bash
# Firebase設定の再確認
flutterfire configure
```

#### 2.  Apple Sign-In設定エラー
```bash
# Apple Developer Console でSign in with Apple設定を確認
echo "https://developer.apple.com/"
```

このガイドに従ってセキュリティ要件に基づく認証・セキュリティ実装を完了してください。