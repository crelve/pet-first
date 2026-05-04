.PHONY: test

FIREBASE_PROJECT_ID=kikiki-flutter-template
APP_ID=kikiki.flutter.template
PREVIOUS_FLAVOR := $(shell cat previous_flavor.txt)
TEMPLATE_REPO = crelve/flutter-template

# リポジトリ複製ターゲット
clone-repo:
ifndef REPO_NAME
	@echo "エラー：REPO_NAMEを指定してください"
	@echo "使用方法: make clone-repo REPO_NAME=your-project-name"
	@exit 1
else
	@echo "リポジトリ複製を開始: $(REPO_NAME)"
	@which gh > /dev/null || brew install gh
	@gh auth status > /dev/null 2>&1 || gh auth login
	@if [ -d "$(REPO_NAME)" ]; then \
		echo "エラー: ディレクトリ '$(REPO_NAME)' が既に存在します"; \
		exit 1; \
	fi
	@echo "テンプレートリポジトリから複製を試行中..."
	@cd .. && gh repo create crelve/$(REPO_NAME) --template $(TEMPLATE_REPO) --private || \
		(echo "⚠️  テンプレート複製に失敗しました。通常のリポジトリを作成します..." && \
		 gh repo create crelve/$(REPO_NAME) --private --description "Flutter アプリプロジェクト" && \
		 echo "✓ 通常のリポジトリを作成しました")
	@echo "リポジトリをクローン中..."
	@cd .. && git clone git@github.com:crelve/$(REPO_NAME).git
	@echo "要件定義ドキュメントをコピー中..."
	@if [ -d "docs/project" ]; then \
		cp -r docs/project ../$(REPO_NAME)/docs/ 2>/dev/null || \
		(mkdir -p ../$(REPO_NAME)/docs && cp -r docs/project ../$(REPO_NAME)/docs/); \
		echo "✓ docs/project/ をコピーしました"; \
	fi
	@echo "プロジェクト履歴に登録中..."
	@if [ -f "docs/project/app_concept.json" ]; then \
		node scripts/check-app-similarity.js add "$$(cat docs/project/app_concept.json | jq -c '. + {"repo_path": "../$(REPO_NAME)"}')"; \
		echo "✓ プロジェクト履歴に登録しました"; \
	else \
		echo "⚠️  app_concept.json が見つからないため、手動登録が必要です"; \
	fi
	@if [ -f "lib/firebase_options.dart" ] || [ -f "lib/firebase_options_prod.dart" ]; then \
		cp -f lib/firebase_options*.dart ../$(REPO_NAME)/lib/ 2>/dev/null || echo "Firebase設定ファイルなし"; \
		echo "✓ Firebase設定ファイルをコピーしました"; \
	fi
	@if [ -f ".firebaserc" ]; then \
		cp -f .firebaserc ../$(REPO_NAME)/ 2>/dev/null || echo "Firebase設定ファイルなし"; \
		echo "✓ .firebaserc をコピーしました"; \
	fi
	@if [ -d "dart_env" ]; then \
		cp -r dart_env ../$(REPO_NAME)/ 2>/dev/null || \
		(mkdir -p ../$(REPO_NAME)/dart_env && cp -r dart_env/* ../$(REPO_NAME)/dart_env/); \
		echo "✓ dart_env/ をコピーしました"; \
	fi
	@echo "初期コミット作成中..."
	@cd ../$(REPO_NAME) && git add . && git commit -m "feat: プロジェクト初期設定 - テンプレート複製・要件定義・Firebase設定適用 🤖 Generated with Claude Code" || echo "⚠️  コミットに失敗しました"
	cd ../$(REPO_NAME) && make setup || echo "⚠️  make setup に失敗しました。手動で設定を続行してください。"
	@echo "✓ プロジェクトの準備が完了しました"
	@echo ""
	@echo "📝 次のステップ:"
	@echo "  1. cd ../$(REPO_NAME)"
	@echo "  2. make create-firebase-project PROJECT_NAME=$(REPO_NAME)"
	@echo "  3. make replace-content PROJECT_NAME=$(REPO_NAME)"
endif

# リポジトリ内の固有部分置換
replace-content:
ifndef PROJECT_NAME
	@echo "エラー：PROJECT_NAMEを指定してください"
	@echo "使用方法: make replace-content PROJECT_NAME=your-new-project-name"
	@exit 1
else
	@echo "プロジェクト内容置換を開始: $(PROJECT_NAME)"
	@echo "1. プロジェクト名の置換..."
	sed -i '' 's/name: flutter_template/name: $(subst -,_,$(PROJECT_NAME))/g' pubspec.yaml || (echo "pubspec.yamlの置換に失敗しました" && exit 1)
	@echo "  マーケティングバージョンを1.0.0にリセット（ビルド番号は維持）..."
	sed -i '' 's/^version: [0-9]*\.[0-9]*\.[0-9]*/version: 1.0.0/' pubspec.yaml || (echo "pubspec.yamlのバージョンリセットに失敗しました" && exit 1)
	sed -i '' 's/"name": "flutter-template"/"name": "$(PROJECT_NAME)"/g' package-lock.json || (echo "package-lock.jsonの置換に失敗しました" && exit 1)
	@echo "2. Firebase設定の置換..."
	find . -type f \( -name "*.dart" -o -name "*.json" -o -name "*.yml" \) -not -path "./ios/Pods/*" -not -path "./.git/*" | xargs sed -i '' 's/kikiki-flutter-template/$(PROJECT_NAME)/g' || (echo "Firebaseプロジェクト名の置換に失敗しました" && exit 1)
	sed -i '' 's/"default": "kikiki-flutter-template-prod"/"default": "$(PROJECT_NAME)-prod"/g' .firebaserc || (echo ".firebasercの置換に失敗しました" && exit 1)
	sed -i '' 's/"prod": "kikiki-flutter-template-prod"/"prod": "$(PROJECT_NAME)-prod"/g' .firebaserc || (echo ".firebasercのprodエイリアスの置換に失敗しました" && exit 1)
	sed -i '' 's/"dev": "kikiki-flutter-template-dev"/"dev": "$(PROJECT_NAME)-dev"/g' .firebaserc || (echo ".firebasercのdevエイリアスの置換に失敗しました" && exit 1)
	sed -i '' 's/FIREBASE_PROJECT_ID=kikiki-flutter-template/FIREBASE_PROJECT_ID=$(PROJECT_NAME)/g' Makefile || (echo "MakefileのFirebase設定の置換に失敗しました" && exit 1)
	@echo "3. パッケージ名の置換..."
	find . -type f \( -name "*.pbxproj" -o -name "*.plist" -o -name "*.rb" \) -not -path "./ios/Pods/*" -not -path "./.git/*" | xargs sed -i '' 's/kikiki\.flutter\.template/$(subst -,.,$(PROJECT_NAME))/g' || (echo "iOSバンドルIDの置換に失敗しました" && exit 1)
	@echo "  Info.plistの表示名を修正..."
	sed -i '' '/<key>CFBundleDisplayName<\/key>/{n;s/<string>[^<]*<\/string>/<string>$(PROJECT_NAME)<\/string>/;}' ios/Runner/Info.plist || (echo "Info.plistのCFBundleDisplayName置換に失敗しました" && exit 1)
	sed -i '' '/<key>CFBundleName<\/key>/{n;s/<string>[^<]*<\/string>/<string>$(PROJECT_NAME)<\/string>/;}' ios/Runner/Info.plist || (echo "Info.plistのCFBundleName置換に失敗しました" && exit 1)
	@echo "  InfoPlist.stringsのアプリ名を更新..."
	find ios/Runner -name "InfoPlist.strings" -exec sed -i '' 's/"CFBundleDisplayName" = "[^"]*"/"CFBundleDisplayName" = "$(PROJECT_NAME)"/g' {} \; 2>/dev/null || echo "InfoPlist.stringsのCFBundleDisplayName置換で一部失敗（継続）"
	sed -i '' 's/APP_ID=kikiki\.flutter\.template/APP_ID=$(subst -,.,$(PROJECT_NAME))/g' Makefile || (echo "MakefileのAPP_IDの置換に失敗しました" && exit 1)
	@echo "4. パッケージインポートの置換..."
	find . -type f -name "*.dart" -not -path "./ios/Pods/*" -not -path "./.git/*" | xargs sed -i '' 's/package:flutter_template/package:$(subst -,_,$(PROJECT_NAME))/g' || (echo "Dartパッケージ名の置換に失敗しました" && exit 1)
	@echo "5. ドキュメントの置換..."
	sed -i '' 's/cd flutter-template/cd $(PROJECT_NAME)/g' CLAUDE.md || (echo "CLAUDE.mdのディレクトリ名置換に失敗しました" && exit 1)
	sed -i '' 's/\*\*flutter_template\*\*/\*\*$(subst -,_,$(PROJECT_NAME))\*\*/g' CLAUDE.md || (echo "CLAUDE.mdのプロジェクト名置換に失敗しました" && exit 1)
	sed -i '' 's/flutter_template/$(subst -,_,$(PROJECT_NAME))/g' CLAUDE.md || (echo "CLAUDE.mdのプロジェクト名置換（通常テキスト）に失敗しました" && exit 1)
	sed -i '' 's/Flutter Template/$(PROJECT_NAME)/g' README.md || (echo "README.mdのタイトル置換に失敗しました" && exit 1)
	sed -i '' 's/Flutter Template Claude Code Cookbook/$(PROJECT_NAME) Claude Code Cookbook/g' .claude/README.md || (echo ".claude/README.mdのタイトル置換に失敗しました" && exit 1)
	find . \( -path "./.cursor/*" -o -path "./.serena/*" \) -type f \( -name "*.md" -o -name "*.yml" \) -exec sed -i '' 's/flutter-template/$(PROJECT_NAME)/g' {} + 2>/dev/null || echo "ドキュメント内のflutter-template置換で一部失敗（継続）"
	find . \( -path "./.cursor/*" -o -path "./.serena/*" \) -type f \( -name "*.md" -o -name "*.yml" \) -exec sed -i '' 's/flutter_template/$(subst -,_,$(PROJECT_NAME))/g' {} + 2>/dev/null || echo "ドキュメント内のflutter_template置換で一部失敗（継続）"
	find . -path "./lib/*" -name "*.dart" -exec sed -i '' 's/kikiki\.flutter\.template\.prod/$(subst -,.,$(PROJECT_NAME)).prod/g' {} + 2>/dev/null || echo "アプリストアURL置換で一部失敗（継続）"
	@echo "6. product_config.dartの追加置換..."
	sed -i '' 's/kikiki-flutter-template-prod\.web\.app/$(PROJECT_NAME)-prod.web.app/g' lib/utility/product/product_config.dart 2>/dev/null || echo "Firebase Hosting URL置換で一部失敗（継続）"
	find . -path "./fastlane/*" \( -name "*.env" -o -name "Fastfile" -o -name "*.xml" \) -exec sed -i '' 's/jp\.flutter\.template/$(subst -,.,$(PROJECT_NAME))/g' {} + 2>/dev/null || echo "fastlane内のjp.flutter.template置換で一部失敗（継続）"
	find . -path "./fastlane/*" \( -name "*.env" -o -name "Fastfile" \) -exec sed -i '' 's/flutter-template/$(PROJECT_NAME)/g' {} + 2>/dev/null || echo "fastlane設定置換で一部失敗（継続）"
	find . -path "./.github/*" -name "*.yml" -exec sed -i '' 's/flutter-template/$(PROJECT_NAME)/g' {} + 2>/dev/null || echo "GitHub Actions設定置換で一部失敗（継続）"
	sed -i '' 's/name: flutter_template/name: $(subst -,_,$(PROJECT_NAME))/g' lib/cli/services/progress_tracker_service.dart 2>/dev/null || echo "ProgressTracker置換で一部失敗（継続）"
	sed -i '' 's/flutter-template-fastlane/$(PROJECT_NAME)-fastlane/g' fastlane/.env.prod fastlane/.env.dev 2>/dev/null || echo "fastlane Git URL置換で一部失敗（継続）"
	@echo "8. dart_env設定ファイルの置換..."
	@if [ -d "dart_env" ]; then \
		find dart_env -name "*.env" -exec sed -i '' 's/kikiki\.flutter\.template/$(subst -,.,$(PROJECT_NAME))/g' {} + 2>/dev/null || echo "dart_env内のappId置換で一部失敗（継続）"; \
		find dart_env -name "*.env" -exec sed -i '' 's/kikiki-flutter-template/$(PROJECT_NAME)/g' {} + 2>/dev/null || echo "dart_env内のリンク置換で一部失敗（継続）"; \
		find dart_env -name "*.env" -exec sed -i '' 's/customUrlScheme=fluttertemplate/customUrlScheme=$(subst _,,$(subst -,,$(PROJECT_NAME)))/g' {} + 2>/dev/null || echo "dart_env内のcustomUrlScheme置換で一部失敗（継続）"; \
		echo "✓ dart_env設定ファイルの置換完了"; \
	else \
		echo "⚠️  dart_envディレクトリが見つかりません"; \
	fi
	@echo "  Fastlane設定ファイルのバンドルIDを置換（Appfile, Matchfile, Fastfile）..."
	sed -i '' 's/kikiki\.flutter\.template/$(subst -,.,$(PROJECT_NAME))/g' ios/fastlane/Appfile 2>/dev/null || echo "Appfileの置換で一部失敗（継続）"
	sed -i '' 's/kikiki\.flutter\.template/$(subst -,.,$(PROJECT_NAME))/g' ios/fastlane/Matchfile 2>/dev/null || echo "Matchfileの置換で一部失敗（継続）"
	sed -i '' 's/kikiki\.flutter\.template/$(subst -,.,$(PROJECT_NAME))/g' ios/fastlane/Fastfile 2>/dev/null || echo "Fastfileの置換で一部失敗（継続）"
	@echo "  Firebase Cloud Functions URLの置換..."
	find public -name "*.html" -exec sed -i '' 's/kikiki-flutter-template-prod/$(PROJECT_NAME)-prod/g' {} + 2>/dev/null || echo "public HTMLのURL置換で一部失敗（継続）"
	find functions/scripts -name "*.sh" -exec sed -i '' 's/kikiki-flutter-template-prod/$(PROJECT_NAME)-prod/g' {} + 2>/dev/null || echo "functionsスクリプトのURL置換で一部失敗（継続）"
	@echo "  integration_testのフォールバックパスの置換..."
	find integration_test -name "*.dart" -exec sed -i '' "s|'[^']*flutter-template'|'$$(pwd)'|g" {} + 2>/dev/null || echo "integration_testのパス置換で一部失敗（継続）"
	@echo "  Fastfileのテンプレートパスの置換..."
	sed -i '' "s|/[^ ]*flutter-template/ios/fastlane|$$(pwd)/ios/fastlane|g" ios/fastlane/Fastfile 2>/dev/null || echo "Fastfileのfastlaneパス置換で一部失敗（継続）"
	sed -i '' "s|/[^ ]*flutter-template\"|$$(pwd)\"|g" ios/fastlane/Fastfile 2>/dev/null || echo "Fastfileのプロジェクトパス置換で一部失敗（継続）"
	@if [ -f "fastlane/.env.dev" ]; then \
		sed -i '' 's/APP_IDENTIFIER="jp\.flutter\.template\.mobile\.dev"/APP_IDENTIFIER="$(subst -,.,$(PROJECT_NAME)).mobile.dev"/g' fastlane/.env.dev || (echo "fastlane/.env.devのAPP_IDENTIFIERの置換に失敗しました" && exit 1); \
		sed -i '' 's/PROFILE_UUID_KEY="sigh_jp\.flutter\.template\.mobile\.dev_adhoc"/PROFILE_UUID_KEY="sigh_$(subst -,.,$(PROJECT_NAME)).mobile.dev_adhoc"/g' fastlane/.env.dev || (echo "fastlane/.env.devのPROFILE_UUID_KEYの置換に失敗しました" && exit 1); \
	else \
		echo "⚠️  fastlane/.env.devファイルが見つかりません。手動で作成してください。"; \
	fi
	@if [ -f "fastlane/.env.prod" ]; then \
		sed -i '' 's/APP_IDENTIFIER="jp\.flutter\.template\.mobile"/APP_IDENTIFIER="$(subst -,.,$(PROJECT_NAME)).mobile"/g' fastlane/.env.prod || (echo "fastlane/.env.prodのAPP_IDENTIFIERの置換に失敗しました" && exit 1); \
		sed -i '' 's/PROFILE_UUID_KEY="sigh_jp\.flutter\.template\.mobile_appstore"/PROFILE_UUID_KEY="sigh_$(subst -,.,$(PROJECT_NAME)).mobile_appstore"/g' fastlane/.env.prod || (echo "fastlane/.env.prodのPROFILE_UUID_KEYの置換に失敗しました" && exit 1); \
	else \
		echo "⚠️  fastlane/.env.prodファイルが見つかりません。手動で作成してください。"; \
	fi
	@echo "10. fastlane/.envファイルの置換..."
	@if [ -f "fastlane/.env" ]; then \
		sed -i '' 's/APP_IDENTIFIER="jp\.flutter\.template\.mobile"/APP_IDENTIFIER="$(subst -,.,$(PROJECT_NAME)).mobile"/g' fastlane/.env || (echo "fastlane/.envのAPP_IDENTIFIERの置換に失敗しました" && exit 1); \
		sed -i '' 's/GIT_URL="https:\/\/github.com\/template\/ios-certificates\.git"/GIT_URL="https:\/\/github.com\/your-username\/ios-certificates.git"/g' fastlane/.env || (echo "fastlane/.envのGIT_URLの置換に失敗しました" && exit 1); \
		sed -i '' 's/GIT_URL_FOR_CI="https:\/\/github.com\/template\/ios-certificates\.git"/GIT_URL_FOR_CI="https:\/\/github.com\/your-username\/ios-certificates.git"/g' fastlane/.env || (echo "fastlane/.envのGIT_URL_FOR_CIの置換に失敗しました" && exit 1); \
		echo "✅ fastlane/.envファイルの置換が完了しました"; \
	else \
		echo "⚠️  fastlane/.envファイルが見つかりません。手動で作成してください。"; \
	fi
	@echo "11. ExportOptions.plistの置換..."
	@if [ -f "ios/ExportOptionsDev.plist" ]; then \
		sed -i '' 's/kikiki\.flutter\.template\.mobile\.dev/$(subst -,.,$(PROJECT_NAME)).mobile.dev/g' ios/ExportOptionsDev.plist || (echo "ExportOptionsDev.plistのBundle ID置換に失敗しました" && exit 1); \
		sed -i '' 's/kikiki-flutter-template_Dev_Development/$(PROJECT_NAME)_Dev_Development/g' ios/ExportOptionsDev.plist || (echo "ExportOptionsDev.plistのProfile名置換に失敗しました" && exit 1); \
		echo "✅ ExportOptionsDev.plistの置換が完了しました"; \
	else \
		echo "⚠️  ios/ExportOptionsDev.plistが見つかりません"; \
	fi
	@if [ -f "ios/ExportOptionsprod.plist" ]; then \
		sed -i '' 's/kikiki\.flutter\.template\.mobile/$(subst -,.,$(PROJECT_NAME)).mobile/g' ios/ExportOptionsprod.plist || (echo "ExportOptionsprod.plistのBundle ID置換に失敗しました" && exit 1); \
		sed -i '' 's/kikiki-flutter-template_Prod_AppStoreConnect/$(PROJECT_NAME)_Prod_AppStoreConnect/g' ios/ExportOptionsprod.plist || (echo "ExportOptionsprod.plistのProfile名置換に失敗しました" && exit 1); \
		echo "✅ ExportOptionsprod.plistの置換が完了しました"; \
	else \
		echo "⚠️  ios/ExportOptionsprod.plistが見つかりません"; \
	fi
	@echo "✓ プロジェクト内容の置換が完了しました"
	@echo ""
	@echo "📝 手動設定が必要な項目："
	@echo "  - Firebase サービスアカウントキーのダウンロード"
	@echo "  - fastlane/service_account_json_key/*.json の配置"
	@echo "  - iOS 証明書の設定 (make create-new-code-signing)"
	@echo "  - ExportOptions.plistのteamID設定"
endif

# 本番環境の広告ID必須チェック
check-prod-env:
	@echo "🔍 prod.env の広告ID設定をチェック中..."
	@if [ ! -f "dart_env/prod.env" ]; then \
		echo "❌ エラー: dart_env/prod.env が見つかりません"; \
		exit 1; \
	fi
	@missing=""; \
	for key in iOSBannerAdUnitId iOSInterstitialAdUnitId iOSRewardedAdUnitId; do \
		value=$$(grep "^$$key=" dart_env/prod.env | cut -d'=' -f2 | tr -d '"' | tr -d "'"); \
		if [ -z "$$value" ]; then \
			missing="$$missing $$key"; \
		fi; \
	done; \
	if [ -n "$$missing" ]; then \
		echo "❌ エラー: 以下の広告IDが未設定または空です:$$missing"; \
		echo ""; \
		echo "dart_env/prod.env に以下の形式で設定してください:"; \
		echo '  iOSBannerAdUnitId="ca-app-pub-xxx/xxx"'; \
		echo '  iOSInterstitialAdUnitId="ca-app-pub-xxx/xxx"'; \
		echo '  iOSRewardedAdUnitId="ca-app-pub-xxx/xxx"'; \
		exit 1; \
	fi
	@echo "✅ 広告ID設定OK"

test:
	sh script/gen_coverage_test.sh
# 	テスト時の環境変数を変更したい場合は、test.envを編集してください。
	fvm flutter test --coverage --dart-define-from-file=dart_env/test.env
# genhtml coverage/lcov.info -o coverage/html
# open coverage/html/index.html

# 静的解析とコード品質チェック
analyze:
	@echo "🔍 Running static analysis..."
	fvm flutter analyze

lint: analyze

format:
	@echo "🎨 Formatting code..."
	fvm dart format lib/ test/

# コンポーネント使用ルール違反チェック
check-component-rules:
	@echo "🔍 Checking component usage rules..."
	@bash scripts/check_component_rules.sh

# パフォーマンスチェック（Flutter/Dart専用）
check-performance:
	@echo "⚡ パフォーマンスをチェック中..."
	@echo ""
	@echo "📊 1. パフォーマンス関連の警告検出:"
	@fvm flutter analyze 2>&1 | grep -i "performance\|slow\|inefficient\|memory" || echo "  ✅ パフォーマンス警告なし"
	@echo ""
	@echo "🐌 2. 非効率なコードパターン検出:"
	@echo "  - build()内での重い処理:"
	@grep -rn "build(BuildContext context)" lib/ --include="*.dart" -A 20 | grep -E "http\.|File\(|Directory\(" | head -5 || echo "    ✅ 検出なし"
	@echo "  - StatelessWidget で使うべき箇所:"
	@grep -rn "class.*extends StatefulWidget" lib/ --include="*.dart" | wc -l | xargs -I {} echo "    StatefulWidget: {} 個（State管理が必要か確認）"
	@echo ""
	@echo "🎨 3. 過剰な Widget rebuild 検出:"
	@grep -rn "setState" lib/ --include="*.dart" | wc -l | xargs -I {} echo "  setState 呼び出し: {} 箇所"
	@echo "  （多すぎる場合は Riverpod/Provider への移行を検討）"
	@echo ""
	@echo "💾 4. メモリリーク可能性:"
	@grep -rn "StreamController\|Timer\|AnimationController" lib/ --include="*.dart" | grep -v "dispose" | wc -l | xargs -I {} echo "  dispose未実装の可能性: {} 箇所"
	@echo ""
	@echo "✅ パフォーマンスチェック完了"
	@echo ""
	@echo "💡 詳細なプロファイリングが必要な場合:"
	@echo "  1. flutter run --profile"
	@echo "  2. Flutter DevTools でメモリ・CPU・レンダリングを分析"

# ビルドチェック（Flutter/Dart専用）
check-build:
	@echo "🏗️  ビルド状態をチェック中..."
	@echo ""
	@echo "📋 1. Flutter 環境確認:"
	@fvm flutter doctor | head -10
	@echo ""
	@echo "📦 2. 依存関係の健全性:"
	@fvm flutter pub get > /dev/null 2>&1 && echo "  ✅ 依存関係解決成功" || echo "  ❌ 依存関係エラー"
	@echo ""
	@echo "🔧 3. コード生成確認:"
	@fvm dart run build_runner build --delete-conflicting-outputs > /dev/null 2>&1 && echo "  ✅ コード生成成功" || echo "  ⚠️  コード生成スキップ（build_runner未使用の可能性）"
	@echo ""
	@echo "📱 4. ビルド可能性チェック:"
	@echo "  - iOS: make build-ipa FLAVOR=dev で確認してください"
	@echo ""
	@echo "🔍 5. Firebase設定確認:"
	@find . -name "GoogleService-Info.plist" | wc -l | xargs -I {} echo "  Firebase設定ファイル: {} 個"
	@echo ""
	@echo "✅ ビルドチェック完了"
	@echo ""
	@echo "💡 詳細なビルド分析が必要な場合:"
	@echo "  make build-ipa FLAVOR=dev  # iOS ビルド"

check-production-ready:
	@echo "🔍 本番環境準備度チェックを実行中..."
	@echo ""
	@ERROR=0; \
	echo "📋 1. TODOコメント検出中..."; \
	TODO=$$(grep -r "TODO\|FIXME\|XXX\|HACK" lib/ --include="*.dart" 2>/dev/null | wc -l | tr -cd '0-9'); \
	if [ "$$TODO" -eq 0 ]; then echo "  ✅ TODOコメント: 0件"; else echo "  ❌ TODOコメント: $$TODO 件"; ERROR=1; fi; \
	echo ""; \
	echo "🎭 2. 仮データ・モックデータ検出中..."; \
	MOCK=$$(grep -r "\(var\|final\|const\)\s\+\w*\(dummy\|mock\|fake\)\w*\s*=" lib/ --include="*.dart" -i 2>/dev/null | grep -v "\.g\.dart" | grep -v "\.freezed\.dart" | wc -l | tr -cd '0-9'); \
	if [ "$$MOCK" -eq 0 ]; then echo "  ✅ 仮データ: 0件"; else echo "  ❌ 仮データ: $$MOCK 件"; ERROR=1; fi; \
	echo ""; \
	echo "⚠️  3. 未実装エラーハンドリング検出中..."; \
	UNIMPL=$$(grep -r "UnimplementedError\|throw Exception('Not implemented\|throw Exception(\"Not implemented" lib/ --include="*.dart" 2>/dev/null | wc -l | tr -cd '0-9'); \
	if [ "$$UNIMPL" -eq 0 ]; then echo "  ✅ 未実装エラー: 0件"; else echo "  ❌ 未実装エラー: $$UNIMPL 件"; ERROR=1; fi; \
	echo ""; \
	echo "📝 4. プレースホルダーテキスト検出中..."; \
	PLACE=$$(grep -r "Lorem ipsum\|TBD\|under construction" lib/ --include="*.dart" -i 2>/dev/null | grep -v "\.g\.dart" | grep -v "\.freezed\.dart" | grep -v "app_localizations" | grep -v "///" | grep -v "テスト用" | grep -v "required String placeholder" | wc -l | tr -cd '0-9'); \
	if [ "$$PLACE" -eq 0 ]; then echo "  ✅ プレースホルダー: 0件"; else echo "  ❌ プレースホルダー: $$PLACE 件"; ERROR=1; fi; \
	echo ""; \
	echo "🐛 5. デバッグコード検出中..."; \
	DEBUG=$$(grep -r "print(\|debugPrint(\|console.log" lib/ --include="*.dart" 2>/dev/null | grep -v "//" | wc -l | tr -cd '0-9'); \
	if [ "$$DEBUG" -eq 0 ]; then echo "  ✅ デバッグコード: 0件"; else echo "  ⚠️  デバッグコード: $$DEBUG 件（警告）"; fi; \
	echo ""; \
	if [ "$$ERROR" -eq 0 ]; then \
		echo "🎉 本番環境準備完了！"; \
	else \
		echo "❌ 本番環境準備度チェック失敗"; \
		exit 1; \
	fi

# 色管理ルールチェック
check-color-usage:
	@echo "🎨 色管理ルールをチェック中..."
	@echo ""
	@echo "❌ 禁止パターン検出中..."
	@echo "1. 直接色指定（Color(0xFF...)）の検出:"
	@grep -rn "Color(0x" lib/ --include="*.dart" | grep -v "gen/colors.gen.dart" | grep -v "color_utility.dart" | grep -v "// ignore:" || echo "  ✅ 違反なし"
	@echo ""
	@echo "2. Colors.xxx 使用の検出:"
	@grep -rn "Colors\." lib/ --include="*.dart" | grep -v "gen/colors.gen.dart" | grep -v "appColors" | grep -v "AppColors" | grep -v "AppleSemanticColors" | grep -v "import" | grep -v "// ignore:" || echo "  ✅ 違反なし"
	@echo ""
	@echo "3. Theme.of(context).colorScheme 使用の検出:"
	@grep -rn "Theme\.of(context)\.colorScheme" lib/ --include="*.dart" | grep -v "// ignore:" || echo "  ✅ 違反なし"
	@echo ""
	@echo "4. Scaffold背景色の直接指定検出（theme.appColors.background / ColorName.backGround推奨）:"
	@grep -rn "Scaffold(" lib/ --include="*.dart" -A 5 | grep -E "backgroundColor:\s*(Colors\.|Color\(0x)" | grep -v "// ignore:" || echo "  ✅ 違反なし"
	@echo ""
	@echo "5. Container背景色の直接指定検出（theme.appColors / ColorName推奨）:"
	@grep -rn "Container(" lib/ --include="*.dart" -A 10 | grep -E "color:\s*(Colors\.|Color\(0x)" | grep -v "// ignore:" | grep -v "gen/colors.gen.dart" || echo "  ✅ 違反なし"
	@echo ""
	@echo "✅ 推奨パターン確認中..."
	@echo "6. AppleSemanticColors.* 使用状況（第一優先）:"
	@grep -rn "AppleSemanticColors\." lib/ --include="*.dart" | wc -l | xargs -I {} echo "  使用箇所: {} 件"
	@echo ""
	@echo "7. theme.appColors.* 使用状況（第二優先）:"
	@grep -rn "theme\.appColors\." lib/ --include="*.dart" | wc -l | xargs -I {} echo "  使用箇所: {} 件"
	@echo ""
	@echo "8. ColorName.* 使用状況（第三優先）:"
	@grep -rn "ColorName\." lib/ --include="*.dart" | wc -l | xargs -I {} echo "  使用箇所: {} 件"
	@echo ""
	@echo "9. 背景色の推奨パターン使用状況:"
	@grep -rn "AppleSemanticColors\.background\|ColorName\.backGround\|appColors\.background" lib/ --include="*.dart" | wc -l | xargs -I {} echo "  使用箇所: {} 件"
	@echo ""
	@echo "✅ 色管理ルールチェック完了"

# 多言語化チェック
check-i18n:
	@echo "🌍 多言語化対応をチェック中..."
	@echo ""
	@echo "❌ ハードコード文字列検出中..."
	@echo "1. 日本語ハードコード検出:"
	@grep -rn "['\"][^'\"]*[ぁ-んァ-ヶー一-龠][^'\"]*['\"]" lib/ --include="*.dart" | grep -v "l10n" | grep -v "// ignore:" | head -10 || echo "  ✅ 違反なし"
	@echo ""
	@echo "2. 英語文章ハードコード検出（3単語以上）:"
	@grep -rn "Text(['\"][A-Z][a-z]\\+ [A-Za-z]\\+ [A-Za-z][^'\"]*['\"]" lib/ --include="*.dart" | grep -v "l10n" | grep -v "// ignore:" | head -10 || echo "  ✅ 違反なし"
	@echo ""
	@echo "3. l10n未使用のText widget検出:"
	@grep -rn "Text(" lib/ --include="*.dart" | grep -v "l10n" | grep -v "TextStyle" | grep -v "TextButton" | grep -v "TextField" | grep -v "TextFormField" | grep "Text(['\"]" | head -10 || echo "  ✅ 違反なし"
	@echo ""
	@echo "✅ 多言語化チェック完了"

# コンポーネント使用規則チェック
check-components:
	@echo "🧩 コンポーネント使用規則をチェック中..."
	@echo ""
	@echo "❌ 直接指定の検出中..."
	@echo "1. SizedBox直接使用（hSpace/wSpace推奨）:"
	@grep -rn "SizedBox(width:" lib/ --include="*.dart" | grep -v "// ignore:" | wc -l | xargs -I {} echo "  検出: {} 件"
	@grep -rn "SizedBox(height:" lib/ --include="*.dart" | grep -v "// ignore:" | wc -l | xargs -I {} echo "  検出: {} 件"
	@echo ""
	@echo "2. CircularProgressIndicator直接使用（Loading()推奨）:"
	@grep -rn "CircularProgressIndicator(" lib/ --include="*.dart" | grep -v "Loading" | grep -v "// ignore:" | wc -l | xargs -I {} echo "  検出: {} 件"
	@echo ""
	@echo "✅ 推奨パターン確認中..."
	@echo "3. hSpace/wSpace使用状況:"
	@grep -rn "hSpace\\|wSpace" lib/ --include="*.dart" | wc -l | xargs -I {} echo "  使用箇所: {} 件"
	@echo ""
	@echo "4. Loading()使用状況:"
	@grep -rn "Loading()" lib/ --include="*.dart" | wc -l | xargs -I {} echo "  使用箇所: {} 件"
	@echo ""
	@echo "✅ コンポーネントチェック完了"

# 依存関係チェック（Flutter/Dart専用）
check-deps:
	@echo "📦 依存関係をチェック中..."
	@echo ""
	@echo "📊 1. 依存パッケージ一覧（ツリー形式）:"
	@fvm dart pub deps --style=tree | head -50
	@echo ""
	@echo "⚠️  2. 古いパッケージの検出:"
	@fvm flutter pub outdated | grep -E "^\s+[a-z_]+" | head -10 || echo "  ✅ 全パッケージが最新"
	@echo ""
	@echo "🔍 3. 未使用パッケージの検出:"
	@echo "  （pubspec.yamlに記載されているが、コード内で使用されていないパッケージ）"
	@for pkg in $$(grep "^\s\+[a-z_]" pubspec.yaml | grep -v "^#" | awk '{print $$1}' | sed 's/://g' | head -20); do \
		if ! grep -rq "import 'package:$$pkg" lib/ 2>/dev/null; then \
			echo "  ⚠️  $$pkg (未使用の可能性)"; \
		fi; \
	done
	@echo ""
	@echo "✅ 依存関係チェック完了"

# Barrel Import規則チェック
check-barrel-import:
	@echo "🔍 Barrel Import規則違反をチェック中..."
	@VIOLATIONS=$$(grep -r "import '\.\./\.\./component/\|import '\.\./\.\./model/\|import '\.\./\.\./provider/\|import '\.\./\.\./utility/\|import '\.\./\.\./hook/\|import '\.\./\.\./type/" lib/ --include="*.dart" | grep -v "lib/import/" | wc -l | tr -cd '0-9'); \
	if [ $$VIOLATIONS -gt 0 ]; then \
		echo "❌ Barrel Import規則違反: $${VIOLATIONS}件"; \
		grep -r "import '\.\./\.\./component/\|import '\.\./\.\./model/\|import '\.\./\.\./provider/\|import '\.\./\.\./utility/\|import '\.\./\.\./hook/\|import '\.\./\.\./type/" lib/ --include="*.dart" | grep -v "lib/import/"; \
		exit 1; \
	else \
		echo "✅ Barrel Import規則: 違反なし"; \
	fi

# Text()直接使用チェック
check-text-usage:
	@echo "🔍 Text()直接使用をチェック中..."
	@if ! command -v rg >/dev/null 2>&1; then \
		echo "❌ ripgrep (rg) がインストールされていません"; \
		echo "  インストール: brew install ripgrep"; \
		exit 1; \
	fi
	@VIOLATIONS=$$(rg "\bText\(" lib/screen/ lib/component/ -t dart --glob '!*.g.dart' --glob '!*.freezed.dart' --glob '!theme_text.dart' 2>/dev/null | rg -v "ThemeText" | wc -l | tr -cd '0-9'); \
	if [ $$VIOLATIONS -gt 0 ]; then \
		echo "❌ Text()直接使用違反: $${VIOLATIONS}件"; \
		rg "\bText\(" lib/screen/ lib/component/ -t dart --glob '!*.g.dart' --glob '!*.freezed.dart' --glob '!theme_text.dart' -n | rg -v "ThemeText"; \
		exit 1; \
	else \
		echo "✅ ThemeText使用規則: 違反なし"; \
	fi

# 多言語化対応チェック（日本語・英語ハードコード検出）
check-i18n-strict:
	@echo "🔍 ハードコード文字列（プロダクトコードのみ）をチェック中..."
	@if ! command -v rg >/dev/null 2>&1; then \
		echo "❌ ripgrep (rg) がインストールされていません"; \
		echo "  インストール: brew install ripgrep"; \
		exit 1; \
	fi
	@echo "  1. 日本語ハードコードをチェック中..."
	@JA_VIOLATIONS=$$(rg "[ぁ-んァ-ヶー一-龠]" lib/screen/ lib/component/ -t dart --glob '!*.g.dart' --glob '!*.freezed.dart' -n 2>/dev/null | rg -v ":\s*///" | rg -v ":\s*//" | rg -v "//.*[ぁ-んァ-ヶー一-龠]" | rg -v "l10n" | wc -l | tr -cd '0-9'); \
	if [ $$JA_VIOLATIONS -gt 0 ]; then \
		echo "❌ 日本語ハードコード違反: $${JA_VIOLATIONS}件"; \
		rg "[ぁ-んァ-ヶー一-龠]" lib/screen/ lib/component/ -t dart --glob '!*.g.dart' --glob '!*.freezed.dart' -n | rg -v ":\s*///" | rg -v ":\s*//" | rg -v "//.*[ぁ-んァ-ヶー一-龠]" | rg -v "l10n"; \
		exit 1; \
	else \
		echo "✅ 日本語ハードコード: 違反なし"; \
	fi
	@echo "  2. 英語ハードコード（label/title属性）をチェック中..."
	@EN_VIOLATIONS=$$(rg "label:\s*['\"][A-Za-z]" lib/screen/ lib/component/ -t dart --glob '!*.g.dart' --glob '!*.freezed.dart' -n 2>/dev/null | rg -v "l10n\." | rg -v ":\s*//" | wc -l | tr -cd '0-9'); \
	if [ $$EN_VIOLATIONS -gt 0 ]; then \
		echo "❌ 英語ハードコード違反（label属性）: $${EN_VIOLATIONS}件"; \
		rg "label:\s*['\"][A-Za-z]" lib/screen/ lib/component/ -t dart --glob '!*.g.dart' --glob '!*.freezed.dart' -n | rg -v "l10n\." | rg -v ":\s*//"; \
		exit 1; \
	else \
		echo "✅ 英語ハードコード（label属性）: 違反なし"; \
	fi
	@echo "✅ 多言語化対応チェック完了"

# コンポーネント使用規則チェック
check-component-usage:
	@echo "🔍 コンポーネント使用規則をチェック中..."
	@if ! command -v rg >/dev/null 2>&1; then \
		echo "❌ ripgrep (rg) がインストールされていません"; \
		echo "  インストール: brew install ripgrep"; \
		exit 1; \
	fi
	@echo "  - CircularProgressIndicatorチェック..."
	@CIRCULAR_VIOLATIONS=$$(rg "CircularProgressIndicator" lib/screen/ lib/component/ -t dart --glob '!*.g.dart' --glob '!loading.dart' 2>/dev/null | wc -l | tr -cd '0-9'); \
	if [ $$CIRCULAR_VIOLATIONS -gt 0 ]; then \
		echo "❌ CircularProgressIndicator直接使用: $${CIRCULAR_VIOLATIONS}件（Loading()を使用）"; \
		rg "CircularProgressIndicator" lib/screen/ lib/component/ -t dart --glob '!*.g.dart' --glob '!loading.dart' -n; \
		exit 1; \
	else \
		echo "✅ Loading()使用規則: 違反なし"; \
	fi
	@echo "  - SizedBoxチェック..."
	@SIZEDBOX_VIOLATIONS=$$(rg "SizedBox\(" lib/screen/ lib/component/ -t dart --glob '!*.g.dart' --glob '!space.dart' --glob '!loading.dart' --glob '!*_button.dart' --glob '!*_dialog.dart' --glob '!*_widget.dart' --glob '!version_text.dart' 2>/dev/null | rg -v "hSpace\|wSpace\|SizedBox\.shrink\|SizedBox\(height:\|SizedBox\(width:\|const SizedBox\(\)" | wc -l | tr -cd '0-9'); \
	if [ $$SIZEDBOX_VIOLATIONS -gt 0 ]; then \
		echo "⚠️  SizedBox直接使用: $${SIZEDBOX_VIOLATIONS}件（hSpace/wSpace推奨）"; \
		rg "SizedBox\(" lib/screen/ lib/component/ -t dart --glob '!*.g.dart' --glob '!space.dart' --glob '!loading.dart' --glob '!*_button.dart' --glob '!*_dialog.dart' --glob '!*_widget.dart' --glob '!version_text.dart' -n 2>/dev/null | rg -v "hSpace\|wSpace\|SizedBox\.shrink\|SizedBox\(height:\|SizedBox\(width:\|const SizedBox\(\)"; \
	else \
		echo "✅ hSpace/wSpace使用: 適切"; \
	fi
	@echo "  - AlertDialog直接使用チェック（ActionDialog/TwoButtonDialog推奨）..."
	@ALERT_DIALOG_VIOLATIONS=$$(rg "AlertDialog\(" lib/screen/ lib/component/ -t dart --glob '!*.g.dart' --glob '!*_dialog.dart' 2>/dev/null | wc -l | tr -cd '0-9'); \
	if [ $$ALERT_DIALOG_VIOLATIONS -gt 0 ]; then \
		echo "❌ AlertDialog直接使用: $${ALERT_DIALOG_VIOLATIONS}件（ActionDialog/TwoButtonDialogを使用）"; \
		rg "AlertDialog\(" lib/screen/ lib/component/ -t dart --glob '!*.g.dart' --glob '!*_dialog.dart' -n; \
		exit 1; \
	else \
		echo "✅ Dialog使用規則: 違反なし"; \
	fi
	@echo "  - showDialog直接使用チェック..."
	@SHOW_DIALOG_VIOLATIONS=$$(rg "showDialog\(" lib/screen/ lib/component/ -t dart --glob '!*.g.dart' --glob '!*_dialog.dart' 2>/dev/null | rg -v "ActionDialog\|TwoButtonDialog" | wc -l | tr -cd '0-9'); \
	if [ $$SHOW_DIALOG_VIOLATIONS -gt 0 ]; then \
		echo "⚠️  showDialog直接使用: $${SHOW_DIALOG_VIOLATIONS}件（ActionDialog/TwoButtonDialog推奨）"; \
		rg "showDialog\(" lib/screen/ lib/component/ -t dart --glob '!*.g.dart' --glob '!*_dialog.dart' -n 2>/dev/null | rg -v "ActionDialog\|TwoButtonDialog"; \
	else \
		echo "✅ showDialog使用: 適切"; \
	fi

# logger使用規則チェック
check-logger-usage:
	@echo "🔍 logger使用規則をチェック中..."
	@if ! command -v rg >/dev/null 2>&1; then \
		echo "❌ ripgrep (rg) がインストールされていません"; \
		echo "  インストール: brew install ripgrep"; \
		exit 1; \
	fi
	@VIOLATIONS=$$(rg "print\(" lib/ -t dart --glob '!*.g.dart' --glob '!*.freezed.dart' 2>/dev/null | wc -l | tr -cd '0-9'); \
	if [ $$VIOLATIONS -gt 0 ]; then \
		echo "❌ print()使用違反: $${VIOLATIONS}件（loggerを使用）"; \
		rg "print\(" lib/ -t dart --glob '!*.g.dart' --glob '!*.freezed.dart' -n; \
		exit 1; \
	else \
		echo "✅ logger使用規則: 違反なし"; \
	fi

# 例外処理規則チェック
check-exception-handling:
	@echo "🔍 例外処理規則をチェック中..."
	@if ! command -v rg >/dev/null 2>&1; then \
		echo "❌ ripgrep (rg) がインストールされていません"; \
		echo "  インストール: brew install ripgrep"; \
		exit 1; \
	fi
	@VIOLATIONS=$$(rg "} catch \(" lib/ -t dart --glob '!*.g.dart' --glob '!*.freezed.dart' 2>/dev/null | rg -v "} on " | wc -l | tr -cd '0-9'); \
	if [ $$VIOLATIONS -gt 0 ]; then \
		echo "❌ catch without on句: $${VIOLATIONS}件（on句必須）"; \
		rg "} catch \(" lib/ -t dart --glob '!*.g.dart' --glob '!*.freezed.dart' -n | rg -v "} on "; \
		exit 1; \
	else \
		echo "✅ 例外処理規則: 違反なし"; \
	fi

# Switch文規則チェック
check-switch-statements:
	@echo "🔍 Switch文規則をチェック中..."
	@if ! command -v rg >/dev/null 2>&1; then \
		echo "❌ ripgrep (rg) がインストールされていません"; \
		echo "  インストール: brew install ripgrep"; \
		exit 1; \
	fi
	@VIOLATIONS=$$(rg "default:" lib/ -t dart --glob '!*.g.dart' --glob '!*.freezed.dart' 2>/dev/null | wc -l | tr -cd '0-9'); \
	if [ $$VIOLATIONS -gt 0 ]; then \
		echo "⚠️  Switch文にdefault句: $${VIOLATIONS}件（全ケース列挙推奨）"; \
		rg "default:" lib/ -t dart --glob '!*.g.dart' --glob '!*.freezed.dart' -A 1 -B 5; \
	else \
		echo "✅ Switch文規則: 違反なし"; \
	fi

# 翻訳整合性チェック（詳細版）
check-translations:
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "🌍 翻訳整合性チェック（詳細版）"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@chmod +x scripts/check_translations.sh
	@bash scripts/check_translations.sh

check-appstore-metadata:
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "🏪 App Store メタデータ文字数チェック"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@python3 scripts/check_appstore_metadata.py

# 全品質ルールチェック（11項目自動チェック）
check-quality-rules-full: check-color-usage check-barrel-import check-text-usage check-i18n-strict check-component-usage check-logger-usage check-exception-handling check-switch-statements check-translations check-ready check-appstore-metadata check-ready
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "🎉 品質ルールチェック完了（11項目自動）"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "残り2項目は手動確認:"
	@echo "  1. ルート定義一元化（lib/route/route.dart）"
	@echo "  2. 既存パターン理解（通常はスキップ可）"
	@echo ""

# 全品質ルールチェック（簡易版）
check-quality: check-color-usage check-i18n check-components
	@echo ""
	@echo "✅ 簡易品質チェック完了"
	@echo ""
	@echo "💡 より詳細なチェックが必要な場合:"
	@echo "  make check-quality-rules-full  # 10項目自動チェック"
	@echo "  /10-quality-rules-check        # コマンド経由（進捗管理機能付き）"

check-ready: check-production-ready
	@echo "🚀 Checking if ready to push..."
	@echo "Running format..."
	fvm dart format lib/ test/
	@echo "Running analyze..."
	fvm flutter analyze
	@echo "Running component rules check..."
	@bash scripts/check_component_rules.sh
	@echo "Running tests..."
	fvm flutter test --dart-define-from-file=dart_env/test.env
	@echo "✅ All checks passed! Ready to push."

push: check-ready
	@echo "🚀 Pushing to remote..."
	git push

run:
	@echo $(FLAVOR) > previous_flavor.txt 2>/dev/null || true
	fvm flutter run -d all --dart-define-from-file=dart_env/$(FLAVOR).env

release-dev-ios:
ifndef BUILD_NUMBER
	@echo エラー：release-dev-iosを実行する際は、BUILD_NUMBERを引数に指定してください！
else
	make clean && make setup
	make create-launcher-icon
	make sync-code-signing CODE_SIGNING_ENV=dev
	make build-ipa EXPORT_OPTIONS_SUFFIX=Dev FLAVOR=dev BUILD_NUMBER=$(BUILD_NUMBER)
	make release-ios FLAVOR=dev
endif

release-prod-ios:
ifndef BUILD_NUMBER
	@echo エラー：release-prod-iosを実行する際は、BUILD_NUMBERを引数に指定してください！
else
	make clean && make setup
	make create-launcher-icon
	make sync-code-signing CODE_SIGNING_ENV=prod
	make build-ipa EXPORT_OPTIONS_SUFFIX=prod FLAVOR=prod BUILD_NUMBER=$(BUILD_NUMBER)
	make release-ios FLAVOR=prod
endif

build-ipa:
ifeq ($(FLAVOR),prod)
	@make check-prod-env
endif
ifndef BUILD_NUMBER
	fvm flutter build ipa --export-options-plist=ios/ExportOptions$(EXPORT_OPTIONS_SUFFIX).plist --dart-define-from-file=dart_env/$(FLAVOR).env --split-debug-info=build/symbols --obfuscate
else
	fvm flutter build ipa --export-options-plist=ios/ExportOptions$(EXPORT_OPTIONS_SUFFIX).plist --dart-define-from-file=dart_env/$(FLAVOR).env --build-number=$(BUILD_NUMBER) --split-debug-info=build/symbols --obfuscate
endif

release:
	fastlane release_$(FLAVOR) --env

release-ios:
	fastlane release_ios_$(FLAVOR) --env

create-launcher-icon:
	fvm flutter pub run flutter_launcher_icons -f launcher_icon/setting.yaml
	@if [ -f assets/image/logoIcon.png ]; then \
		cp assets/image/logoIcon.png public/icon.png; \
		echo "✓ public/icon.png を更新しました"; \
	fi

create-native-splash:
	fvm dart run flutter_native_splash:create

gen-firebase-config:
	rm -f ios/Runner/GoogleService-Info.plist
	rm -f lib/firebase_options.dart
	fvm flutter pub get
	fvm dart pub global run flutterfire_cli:flutterfire configure \
		--yes \
		--project=$(FIREBASE_PROJECT_ID)$(FIREBASE_PROJECT_ID_SUFFIX) \
		--platforms=ios \
		--ios-bundle-id=$(APP_ID)
	@echo "Generating ios/firebase_app_id_file.json from GoogleService-Info.plist..."
	@if [ -f "ios/Runner/GoogleService-Info.plist" ]; then \
		GOOGLE_APP_ID=$$(grep -A1 "GOOGLE_APP_ID" ios/Runner/GoogleService-Info.plist | grep "<string>" | sed 's/<[^>]*>//g' | xargs); \
		PROJECT_ID=$$(grep -A1 "PROJECT_ID" ios/Runner/GoogleService-Info.plist | grep "<string>" | sed 's/<[^>]*>//g' | xargs); \
		GCM_SENDER_ID=$$(grep -A1 "GCM_SENDER_ID" ios/Runner/GoogleService-Info.plist | grep "<string>" | sed 's/<[^>]*>//g' | xargs); \
		echo "{" > ios/firebase_app_id_file.json; \
		echo "  \"file_generated_by\": \"FlutterFire CLI\"," >> ios/firebase_app_id_file.json; \
		echo "  \"purpose\": \"FirebaseAppId & ProjectId for this Firebase project. This file should be committed to source control.\"," >> ios/firebase_app_id_file.json; \
		echo "  \"GOOGLE_APP_ID\": \"$$GOOGLE_APP_ID\"," >> ios/firebase_app_id_file.json; \
		echo "  \"FIREBASE_PROJECT_ID\": \"$$PROJECT_ID\"," >> ios/firebase_app_id_file.json; \
		echo "  \"GCM_SENDER_ID\": \"$$GCM_SENDER_ID\"" >> ios/firebase_app_id_file.json; \
		echo "}" >> ios/firebase_app_id_file.json; \
		echo "✓ ios/firebase_app_id_file.json を生成しました"; \
	else \
		echo "❌ ios/Runner/GoogleService-Info.plist が見つかりません"; \
		exit 1; \
	fi

sync-code-signing:
	fastlane ios read_code_signing --env $(CODE_SIGNING_ENV) RUN_MODE=$(RUN_MODE)

create-new-code-signing:
	fastlane ios create_new_code_signing --env $(CODE_SIGNING_ENV) RUN_MODE=$(RUN_MODE)
	
upload-file:
	keytool -genkey -v -keystore ./key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key

clean:
	fvm flutter clean
	
# ライブラリのキャッシュをクリアして再取得
refresh-deps:
	@echo "🧹 プロジェクトキャッシュをクリア中..."
	rm -f pubspec.lock
	rm -rf .dart_tool
	fvm flutter clean
	@echo "📦 依存関係を再取得中..."
	fvm flutter pub get
	@echo "✅ 完了"

setup:
	fvm flutter clean
	fvm flutter pub upgrade flutter_foundation
	fvm dart pub get && fvm dart run build_runner build --delete-conflicting-outputs
	fvm flutter pub get
	fvm flutter precache --ios && cd ios && export LANG=en_US.UTF-8 && export LC_ALL=en_US.UTF-8 && pod install --repo-update
	fvm flutter gen-l10n
	fvm dart pub get
	make setup-lefthook

update-gen:
	fvm flutter clean
	fvm dart pub get
	fvm flutter gen-l10n

generate-colors:
	fvm dart run build_runner build --delete-conflicting-outputs


run-dev:
ifneq ($(PREVIOUS_FLAVOR), dev)
	make create-launcher-icon
endif
	make run FLAVOR=dev

run-prod:
	@make check-prod-env
ifneq ($(PREVIOUS_FLAVOR), prod)
	make create-launcher-icon
	make gen-firebase-config FIREBASE_PROJECT_ID_SUFFIX=-prod
endif
	make run FLAVOR=prod

set-deploy:
# https://qiita.com/masaibar/items/c378b4f01b707ac2506a
		firebase init
		echo google.com, pub-2443502666087876, DIRECT, f08c47fec0942fa0 > public/app-ads.txt

# Firebase プロジェクト作成
create-firebase-project:
ifndef PROJECT_NAME
	@echo "エラー：PROJECT_NAMEを指定してください"
	@echo "使用方法: make create-firebase-project PROJECT_NAME=your-new-project-name"
	@exit 1
else
	@echo "🔥 Firebaseプロジェクト作成を開始: $(PROJECT_NAME)"
	@echo ""
	@echo "1. Firebase CLIの確認..."
	@which firebase > /dev/null || (echo "Firebase CLIがインストールされていません。自動的にインストールします..." && npm install -g firebase-tools)
	@echo "✅ Firebase CLI確認完了"
	@echo ""
	@echo "2. Firebase CLIの認証確認..."
	@firebase projects:list > /dev/null 2>&1 || (echo "Firebase CLIにログインしていません。自動的にログインを開始します..." && firebase login)
	@echo "✅ Firebase CLI認証確認完了"
	@echo ""
	@echo "3. プロジェクト名の検証..."
	$(eval FIREBASE_PROJECT_ID := $(PROJECT_NAME))
	@echo "プロジェクト名: $(PROJECT_NAME)"
	@echo "FirebaseプロジェクトID: $(FIREBASE_PROJECT_ID)"
	@echo "✅ プロジェクト名検証完了"
	@echo ""
	@echo "4. 開発環境プロジェクトを作成..."
	@echo "プロジェクトID: $(FIREBASE_PROJECT_ID)-dev"
	firebase projects:create $(FIREBASE_PROJECT_ID)-dev --display-name="$(FIREBASE_PROJECT_ID)-dev" || (echo "❌ 開発環境プロジェクトの作成に失敗しました。プロジェクト名が既に使用されている可能性があります。" && exit 1)
	@echo "✅ 開発環境プロジェクト作成完了"
	@echo ""
	@echo "5. 本番環境プロジェクトを作成..."
	@echo "レート制限を避けるため、30秒待機します..."
	@sleep 30
	@echo "プロジェクトID: $(FIREBASE_PROJECT_ID)-prod"
	firebase projects:create $(FIREBASE_PROJECT_ID)-prod --display-name="$(FIREBASE_PROJECT_ID)-prod" || (echo "❌ 本番環境プロジェクトの作成に失敗しました。プロジェクト名が既に使用されている可能性があります。" && exit 1)
	@echo "✅ 本番環境プロジェクト作成完了"
	@echo ""
	@echo "6. gcloud CLIの確認..."
	@which gcloud > /dev/null || (echo "❌ gcloud CLIがインストールされていません。Google Cloud SDKをインストールしてください: https://cloud.google.com/sdk/docs/install" && exit 1)
	@gcloud auth print-access-token > /dev/null 2>&1 || (echo "gcloud CLIにログインしていません。ログインを開始します..." && gcloud auth login)
	@echo "✅ gcloud CLI確認完了"
	@echo ""
	@echo "7. Blazeプランへのアップグレード..."
	@if [ -n "$(BILLING_ACCOUNT_ID)" ]; then \
		echo "課金アカウント: $(BILLING_ACCOUNT_ID)"; \
		gcloud beta billing projects link $(FIREBASE_PROJECT_ID)-dev --billing-account=$(BILLING_ACCOUNT_ID) && echo "✅ 開発環境 Blazeプランアップグレード完了" || echo "⚠️  開発環境のBlazeアップグレードに失敗"; \
		gcloud beta billing projects link $(FIREBASE_PROJECT_ID)-prod --billing-account=$(BILLING_ACCOUNT_ID) && echo "✅ 本番環境 Blazeプランアップグレード完了" || echo "⚠️  本番環境のBlazeアップグレードに失敗"; \
	else \
		echo "⚠️  BILLING_ACCOUNT_IDが未指定のためスキップします"; \
		echo "   後から実行する場合: make upgrade-blaze PROJECT_NAME=$(PROJECT_NAME) BILLING_ACCOUNT_ID=YOUR_ID"; \
		echo "   アカウントID確認: gcloud alpha billing accounts list"; \
	fi
	@echo ""
	@echo "8. Firebase API一括有効化（開発環境）..."
	@for api in \
		identitytoolkit.googleapis.com \
		firestore.googleapis.com \
		cloudfunctions.googleapis.com \
		firebaseappcheck.googleapis.com \
		firebasecrashlytics.googleapis.com \
		firebasestorage.googleapis.com \
		firebasehosting.googleapis.com \
		firebaseperformance.googleapis.com \
		firebasevertexai.googleapis.com \
		generativelanguage.googleapis.com; do \
		gcloud services enable $$api --project=$(FIREBASE_PROJECT_ID)-dev --quiet && echo "  ✅ $$api" || echo "  ⚠️  $$api の有効化に失敗（Blazeプランが必要な場合あり）"; \
	done
	@echo "✅ 開発環境 API有効化完了"
	@echo ""
	@echo "9. Firebase API一括有効化（本番環境）..."
	@for api in \
		identitytoolkit.googleapis.com \
		firestore.googleapis.com \
		cloudfunctions.googleapis.com \
		firebaseappcheck.googleapis.com \
		firebasecrashlytics.googleapis.com \
		firebasestorage.googleapis.com \
		firebasehosting.googleapis.com \
		firebaseperformance.googleapis.com \
		firebasevertexai.googleapis.com \
		generativelanguage.googleapis.com; do \
		gcloud services enable $$api --project=$(FIREBASE_PROJECT_ID)-prod --quiet && echo "  ✅ $$api" || echo "  ⚠️  $$api の有効化に失敗（Blazeプランが必要な場合あり）"; \
	done
	@echo "✅ 本番環境 API有効化完了"
	@echo ""
	@echo "10. BigQuery API有効化 + Analytics Export設定..."
	@gcloud services enable bigquery.googleapis.com --project=$(FIREBASE_PROJECT_ID)-prod --quiet \
		&& echo "  ✅ BigQuery API有効化完了（本番）" || echo "  ⚠️  BigQuery API有効化失敗"
	@gcloud services enable bigquerydatatransfer.googleapis.com --project=$(FIREBASE_PROJECT_ID)-prod --quiet \
		&& echo "  ✅ BigQuery Data Transfer API有効化完了（本番）" || echo "  ⚠️  BigQuery Data Transfer API有効化失敗"
	@echo "  💡 BigQuery Export（Analytics）はFirebaseコンソール > 統合 > BigQuery で手動有効化が必要です"
	@echo ""
	@echo "11. Firebase Auth 匿名認証を有効化..."
	$(eval TOKEN := $(shell gcloud auth print-access-token))
	@curl -s -X PATCH \
		"https://identitytoolkit.googleapis.com/admin/v2/projects/$(FIREBASE_PROJECT_ID)-dev/config?updateMask=signIn.anonymous.enabled" \
		-H "Authorization: Bearer $(TOKEN)" \
		-H "Content-Type: application/json" \
		-d '{"signIn":{"anonymous":{"enabled":true}}}' > /dev/null \
		&& echo "✅ 開発環境 匿名認証有効化完了" || echo "⚠️  開発環境の匿名認証有効化に失敗"
	@curl -s -X PATCH \
		"https://identitytoolkit.googleapis.com/admin/v2/projects/$(FIREBASE_PROJECT_ID)-prod/config?updateMask=signIn.anonymous.enabled" \
		-H "Authorization: Bearer $(TOKEN)" \
		-H "Content-Type: application/json" \
		-d '{"signIn":{"anonymous":{"enabled":true}}}' > /dev/null \
		&& echo "✅ 本番環境 匿名認証有効化完了" || echo "⚠️  本番環境の匿名認証有効化に失敗"
	@echo ""
	@echo "🎉 Firebaseプロジェクトのセットアップが完了しました！"
	@echo ""
	@echo "📋 作成されたプロジェクト:"
	@echo "  🔧 開発環境: $(FIREBASE_PROJECT_ID)-dev"
	@echo "  🚀 本番環境: $(FIREBASE_PROJECT_ID)-prod"
	@echo ""
	@echo "📝 次のステップ:"
	@echo "  make gen-firebase-config FIREBASE_PROJECT_ID_SUFFIX=-prod"
endif

# Blazeプランへの後からアップグレード
# 使用方法: make upgrade-blaze PROJECT_NAME=your-project BILLING_ACCOUNT_ID=0X0X0X-0X0X0X-0X0X0X
# アカウントID確認: gcloud alpha billing accounts list
upgrade-blaze:
ifndef PROJECT_NAME
	@echo "エラー：PROJECT_NAMEを指定してください"
	@exit 1
endif
ifndef BILLING_ACCOUNT_ID
	@echo "エラー：BILLING_ACCOUNT_IDを指定してください"
	@echo "確認方法: gcloud alpha billing accounts list"
	@exit 1
else
	$(eval FIREBASE_PROJECT_ID := $(PROJECT_NAME))
	@echo "⬆️  Blazeプランへアップグレード中..."
	gcloud beta billing projects link $(FIREBASE_PROJECT_ID)-dev --billing-account=$(BILLING_ACCOUNT_ID) \
		&& echo "✅ 開発環境 Blazeプランアップグレード完了" || echo "❌ 開発環境のアップグレードに失敗"
	gcloud beta billing projects link $(FIREBASE_PROJECT_ID)-prod --billing-account=$(BILLING_ACCOUNT_ID) \
		&& echo "✅ 本番環境 Blazeプランアップグレード完了" || echo "❌ 本番環境のアップグレードに失敗"
	@echo ""
	@echo "🎉 Blazeプランへのアップグレードが完了しました！"
	@echo "   Cloud Functions・Firebase AI Logic・Storageが利用可能になりました。"
endif

# AdMob設定の自動更新（iOS専用）
# 使用方法: make update-admob-config IOS_APP_ID=xxx IOS_BANNER_ID=xxx IOS_INTERSTITIAL_ID=xxx IOS_REWARDED_INTERSTITIAL_ID=xxx
update-admob-config:
ifndef IOS_APP_ID
	@echo "エラー：IOS_APP_IDを指定してください"
	@echo "使用方法: make update-admob-config IOS_APP_ID=your-ios-app-id IOS_BANNER_ID=your-ios-banner-id IOS_INTERSTITIAL_ID=your-ios-interstitial-id IOS_REWARDED_INTERSTITIAL_ID=your-ios-rewarded-interstitial-id"
	@exit 1
else ifndef IOS_BANNER_ID
	@echo "エラー：IOS_BANNER_IDを指定してください"
	@echo "使用方法: make update-admob-config IOS_APP_ID=your-ios-app-id IOS_BANNER_ID=your-ios-banner-id IOS_INTERSTITIAL_ID=your-ios-interstitial-id IOS_REWARDED_INTERSTITIAL_ID=your-ios-rewarded-interstitial-id"
	@exit 1
else ifndef IOS_INTERSTITIAL_ID
	@echo "エラー：IOS_INTERSTITIAL_IDを指定してください"
	@echo "使用方法: make update-admob-config IOS_APP_ID=your-ios-app-id IOS_BANNER_ID=your-ios-banner-id IOS_INTERSTITIAL_ID=your-ios-interstitial-id IOS_REWARDED_INTERSTITIAL_ID=your-ios-rewarded-interstitial-id"
	@exit 1
else ifndef IOS_REWARDED_INTERSTITIAL_ID
	@echo "エラー：IOS_REWARDED_INTERSTITIAL_IDを指定してください"
	@echo "使用方法: make update-admob-config IOS_APP_ID=your-ios-app-id IOS_BANNER_ID=your-ios-banner-id IOS_INTERSTITIAL_ID=your-ios-interstitial-id IOS_REWARDED_INTERSTITIAL_ID=your-ios-rewarded-interstitial-id"
	@exit 1
else
	@echo "🔧 AdMob設定を更新中（iOS専用）"
	@echo ""
	@echo "1. 本番環境の設定ファイルを更新..."
	@if [ -f "dart_env/prod.env" ]; then \
		sed -i '' 's|^iOSBannerAdUnitId=.*|iOSBannerAdUnitId=$(IOS_BANNER_ID)|' dart_env/prod.env || (echo "❌ iOSバナー広告IDの更新に失敗しました" && exit 1); \
		sed -i '' 's|^iOSInterstitialAdUnitId=.*|iOSInterstitialAdUnitId=$(IOS_INTERSTITIAL_ID)|' dart_env/prod.env || (echo "❌ iOSインタースティシャル広告IDの更新に失敗しました" && exit 1); \
		sed -i '' 's|^iOSRewardedInterstitialAdUnitId=.*|iOSRewardedInterstitialAdUnitId=$(IOS_REWARDED_INTERSTITIAL_ID)|' dart_env/prod.env || (echo "❌ iOSリワードインタースティシャル広告IDの更新に失敗しました" && exit 1); \
		echo "✅ 本番環境の設定ファイル更新完了"; \
	else \
		echo "❌ dart_env/prod.envファイルが見つかりません"; \
		exit 1; \
	fi
	@echo ""
	@echo "2. iOS設定ファイルを更新..."
	@if [ -f "ios/Runner/Info.plist" ]; then \
		sed -i '' 's/<string>ca-app-pub-2443502666087876~1338814004<\/string>/<string>$(IOS_APP_ID)<\/string>/g' ios/Runner/Info.plist || (echo "❌ Info.plistの更新に失敗しました" && exit 1); \
		echo "✅ iOS設定ファイル更新完了"; \
	else \
		echo "❌ ios/Runner/Info.plistファイルが見つかりません"; \
		exit 1; \
	fi
	@echo ""
	@echo "3. 設定の検証..."
	@echo "更新された設定内容:"
	@echo "  🍎 iOS アプリID: $(IOS_APP_ID)"
	@echo "  🍎 iOS バナー広告: $(IOS_BANNER_ID)"
	@echo "  🍎 iOS インタースティシャル広告: $(IOS_INTERSTITIAL_ID)"
	@echo "  🍎 iOS リワードインタースティシャル広告: $(IOS_REWARDED_INTERSTITIAL_ID)"
	@echo ""
	@echo "✅ AdMob設定の更新が完了しました！"
	@echo ""
	@echo "📝 次のステップ:"
	@echo "  1. アプリをビルドして広告が正常に表示されることを確認"
	@echo "  2. テスト広告で動作確認"
	@echo "  3. 本番広告の申請（必要に応じて）"
endif


# app-ads.txt用のpublicディレクトリとファイルを作成
create-public-files:
ifndef LEGAL_URL
	@echo "エラー：LEGAL_URLを指定してください"
	@echo "使用方法: make create-public-files LEGAL_URL=your-legal-url"
	@echo "例: make create-public-files LEGAL_URL=https://zircon-knight-7b1.notion.site/Paw-Harmony-23e0932daea280d0b00aceb39b86978f"
	@exit 1
else
	@echo "📁 publicディレクトリとファイルを作成中..."
	@mkdir -p public
	@echo "✓ publicディレクトリを作成しました"
	
	@# app-ads.txtファイルの作成
	@echo 'google.com, pub-2443502666087876, DIRECT, f08c47fec0942fa0' > public/app-ads.txt
	
	@# index.htmlファイルの作成
	@echo '<!DOCTYPE html>' > public/index.html
	@echo '<html>' >> public/index.html
	@echo '  <head>' >> public/index.html
	@echo '    <meta' >> public/index.html
	@echo '      http-equiv="refresh"' >> public/index.html
	@echo '      content="1;URL=$(LEGAL_URL)"' >> public/index.html
	@echo '    />' >> public/index.html
	@echo '  </head>' >> public/index.html
	@echo '</html>' >> public/index.html
	@echo "✓ public/index.html を作成しました"
	
	@# 404.htmlファイルの作成
	@echo '<!DOCTYPE html>' > public/404.html
	@echo '<html>' >> public/404.html
	@echo '  <head>' >> public/404.html
	@echo '    <meta charset="utf-8">' >> public/404.html
	@echo '    <meta name="viewport" content="width=device-width, initial-scale=1">' >> public/404.html
	@echo '    <title>Page Not Found</title>' >> public/404.html
	@echo '' >> public/404.html
	@echo '    <style media="screen">' >> public/404.html
	@echo '      body { background: #ECEFF1; color: rgba(0,0,0,0.87); font-family: Roboto, Helvetica, Arial, sans-serif; margin: 0; padding: 0; }' >> public/404.html
	@echo '      #message { background: white; max-width: 360px; margin: 100px auto 16px; padding: 32px 24px 16px; border-radius: 3px; }' >> public/404.html
	@echo '      #message h3 { color: #888; font-weight: normal; font-size: 16px; margin: 16px 0 12px; }' >> public/404.html
	@echo '      #message h2 { color: #ffa100; font-weight: bold; font-size: 16px; margin: 0 0 8px; }' >> public/404.html
	@echo '      #message h1 { font-size: 22px; font-weight: 300; color: rgba(0,0,0,0.6); margin: 0 0 16px;}' >> public/404.html
	@echo '      #message p { line-height: 140%; margin: 16px 0 24px; font-size: 14px; }' >> public/404.html
	@echo '      #message a { display: block; text-align: center; background: #039be5; text-transform: uppercase; text-decoration: none; color: white; padding: 16px; border-radius: 4px; }' >> public/404.html
	@echo '      #message, #message a { box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24); }' >> public/404.html
	@echo '      #load { color: rgba(0,0,0,0.4); text-align: center; font-size: 13px; }' >> public/404.html
	@echo '      @media (max-width: 600px) {' >> public/404.html
	@echo '        body, #message { margin-top: 0; background: white; box-shadow: none; }' >> public/404.html
	@echo '        body { border-top: 16px solid #ffa100; }' >> public/404.html
	@echo '      }' >> public/404.html
	@echo '    </style>' >> public/404.html
	@echo '  </head>' >> public/404.html
	@echo '  <body>' >> public/404.html
	@echo '    <div id="message">' >> public/404.html
	@echo '      <h2>404</h2>' >> public/404.html
	@echo '      <h1>Page Not Found</h1>' >> public/404.html
	@echo '      <p>The specified file was not found on this website. Please check the URL for mistakes and try again.</p>' >> public/404.html
	@echo '      <h3>Why am I seeing this?</h3>' >> public/404.html
	@echo '      <p>This page was generated by the Firebase Command-Line Interface. To modify it, edit the <code>404.html</code> file in your project'\''s configured <code>public</code> directory.</p>' >> public/404.html
	@echo '    </div>' >> public/404.html
	@echo '  </body>' >> public/404.html
	@echo '</html>' >> public/404.html
	@echo "✓ public/404.html を作成しました"
	
	@echo ""
	@echo "🎉 publicディレクトリとファイルの作成が完了しました！"
	@echo ""
	@echo "📁 作成されたファイル:"
	@echo "  - public/app-ads.txt (パブリッシャーID: pub-2443502666087876)"
	@echo "  - public/index.html (リダイレクト先: $(LEGAL_URL))"
	@echo "  - public/404.html (Firebase標準エラーページ)"
	@echo ""
	@echo "🚀 Firebase Hostingにデプロイしています..."
	
	@# Firebase CLIの確認
	@if ! command -v firebase > /dev/null 2>&1; then \
		echo "❌ Firebase CLIがインストールされていません"; \
		echo "📥 Firebase CLIをインストールしています..."; \
		npm install -g firebase-tools; \
	fi
	
	@# firebase.jsonの存在確認
	@if [ ! -f firebase.json ]; then \
		echo "📝 firebase.jsonが見つかりません。Firebase Hostingを初期化しています..."; \
		echo '{"hosting":{"public":"public","ignore":["firebase.json","**/.*","**/node_modules/**"]}}' > firebase.json; \
		echo "✓ firebase.json を作成しました"; \
	fi
	
	@# Firebase認証の確認
	@if ! firebase projects:list > /dev/null 2>&1; then \
		echo "🔐 Firebase認証が必要です。ブラウザで認証を行ってください..."; \
		firebase login; \
	fi
	
	@# デプロイ実行
	@echo "📤 Firebase Hostingにデプロイ中..."
	@firebase deploy --only hosting
	
	@echo ""
	@echo "🎉 デプロイが完了しました！"
	@echo ""
	@echo "📝 次のステップ:"
	@echo "  1. デプロイされたURLでapp-ads.txtファイルが正しく配信されているか確認してください"
	@echo "  2. app-ads.txtファイルがクロールされるまで24時間待機してください"
	@echo "  3. AdMobコンソールでapp-ads.txtの状態を確認してください"
endif

# Lefthook setup for git hooks
setup-lefthook:
	@echo "🔧 Lefthookのセットアップを開始"
	@echo ""
	@echo "1. Lefthookのインストール確認..."
	@if ! command -v lefthook > /dev/null 2>&1; then \
		echo "❌ Lefthookがインストールされていません"; \
		echo "📥 以下のコマンドでインストールしてください:"; \
		echo "  brew install lefthook"; \
		echo ""; \
		echo "または、他の方法:"; \
		echo "  # Go (if you have Go installed)"; \
		echo "  go install github.com/evilmartians/lefthook@latest"; \
		echo ""; \
		echo "  # npm"; \
		echo "  npm install -g @arkweid/lefthook"; \
		echo ""; \
		echo "  # gem"; \
		echo "  gem install lefthook"; \
		echo ""; \
		exit 1; \
	fi
	@echo "✅ Lefthookインストール確認完了"
	@echo ""
	@echo "2. Lefthook初期化..."
	@lefthook install
	@echo "✅ Lefthook初期化完了"
	@echo ""
	@echo "🎉 Lefthookのセットアップが完了しました！"
	@echo ""
	@echo "📋 有効化されたGit hooks:"
	@echo "  📝 pre-commit: コードフォーマット、静的解析、単体テスト"
	@echo "  💬 commit-msg: コミットメッセージ形式の検証"
	@echo "  🚀 pre-push: 全テストスイート、静的解析、ビルド確認"
	@echo ""
	@echo "📝 使用方法:"
	@echo "  - 通常通りgit commit/pushを実行"



# ヘルプ
help:
	@echo "📋 Flutter Template - 利用可能なコマンド"
	@echo ""
	@echo "🎨 開発："
	@echo "  make setup              # 初期セットアップ"
	@echo "  make run-dev            # 開発環境で実行"
	@echo "  make run-prod           # 本番環境で実行"
	@echo "  make clean              # クリーンアップ"
	@echo "  make update-gen         # コード生成（l10n等）"
	@echo ""
	@echo "✅ 品質チェック："
	@echo "  make check-quality      # 簡易品質チェック（色・i18n・コンポーネント）"
	@echo "  make check-ready        # コミット前チェック（format/analyze/test）"
	@echo "  make check-production-ready # 本番環境準備度チェック"
	@echo "  make check-deps         # 依存関係チェック"
	@echo "  make check-performance  # パフォーマンスチェック"
	@echo "  make check-build        # ビルド状態チェック"
	@echo ""
	@echo "  個別チェック："
	@echo "    make check-color-usage   # 色管理ルール"
	@echo "    make check-i18n          # 多言語化対応"
	@echo "    make check-components    # コンポーネント使用規則"
	@echo "    make check-l10n          # L10n同期状態チェック"
	@echo "    make sync-l10n           # L10n不足キー追加"
	@echo ""
	@echo "  完全チェック（Claude Code）："
	@echo "    /10-quality-rules-check  # 12項目の完全チェック"
	@echo ""
	@echo "📦 ビルド："
	@echo "  make build-ipa FLAVOR=dev/prod BUILD_NUMBER=1  # iOS IPA ビルド"
	@echo ""
	@echo "🚀 リリース："
	@echo "  make release-prod-ios BUILD_NUMBER=1         # iOS リリース"
	@echo ""
	@echo "🔧 プロジェクト管理："
	@echo "  make clone-repo REPO_NAME=your-project       # リポジトリ複製"
	@echo "  make replace-content PROJECT_NAME=your-name  # プロジェクト名置換"
	@echo "  make create-firebase-project PROJECT_NAME=your-name # Firebase作成"
	@echo "  make gen-firebase-config FIREBASE_PROJECT_ID_SUFFIX=-prod"
	@echo ""
	@echo "🔄 PDCA（Claude Code）："
	@echo "  /pdca-sync      # ローカルログをグローバルに同期"
	@echo "  /pdca-analyze   # 失敗パターン分析"
	@echo "  /pdca-improve   # コマンド自動改善"
	@echo ""
	@echo "💡 詳細は CLAUDE.md を参照してください"

# L10n Synchronization
L10N_DIR = lib/l10n
BASE_ARB = $(L10N_DIR)/app_en.arb
ARB_FILES = $(filter-out $(BASE_ARB), $(wildcard $(L10N_DIR)/*.arb))

check-l10n:
	@echo "🌍 Checking L10n synchronization..."
	@echo "==================================\n"
	@python3 -c 'import json; data=json.load(open("$(BASE_ARB)","r")); keys=[k for k in data.keys() if not k.startswith("@") and k!="@@locale"]; print(f"📖 Base file (app_en.arb): {len(keys)} keys\n")'
	@all_ok=true; \
	base_count=$$(python3 -c 'import json; data=json.load(open("$(BASE_ARB)","r")); keys=[k for k in data.keys() if not k.startswith("@") and k!="@@locale"]; print(len(keys))'); \
	for file in $(ARB_FILES); do \
		filename=$$(basename $$file); \
		count=$$(python3 -c "import json; data=json.load(open('$$file','r')); keys=[k for k in data.keys() if not k.startswith('@') and k!='@@locale']; print(len(keys))"); \
		if [ $$count -eq $$base_count ]; then \
			echo "✅ $$filename: $$count keys"; \
		else \
			echo "❌ $$filename: $$count keys (expected: $$base_count)"; \
			all_ok=false; \
		fi; \
	done; \
	echo ""; \
	if [ "$$all_ok" = true ]; then \
		echo "✅ All localization files are synchronized!"; \
	else \
		echo "❌ Some files are missing keys. Run 'make sync-l10n' to fix."; \
		exit 1; \
	fi

sync-l10n:
	@echo "🌍 Synchronizing L10n files..."
	@python3 .claude/scripts/sync_l10n.py
	@echo ""
	@echo "⚠️  Please translate the added keys manually in each language file"
