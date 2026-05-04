# Suggested Commands

## Development Commands
- `make setup` - Clean and setup project
- `make run-dev` - Run development environment
- `make run-prod` - Run production environment  
- `make test` - Run tests with coverage
- `make update-gen` - Generate code (models, routes, etc.)

## Testing Commands
- `make test` - Run flutter test with coverage report
- `fvm flutter test --coverage --dart-define-from-file=dart_env/test.env` - Direct test command

## Build Commands
- `make build-ipa FLAVOR=dev EXPORT_OPTIONS_SUFFIX=Dev` - Build iOS development
- `make build-ipa FLAVOR=prod EXPORT_OPTIONS_SUFFIX=prod BUILD_NUMBER=1` - Build iOS production

## Code Generation
- `fvm dart run build_runner build --delete-conflicting-outputs` - Generate code
- `make create-launcher-icon FLAVOR=prod` - Create launcher icons
- `make create-native-splash` - Create native splash screen

## Firebase Commands  
- `make create-firebase-project PROJECT_NAME=your-project-name` - Create Firebase projects
- `make gen-firebase-config FIREBASE_PROJECT_ID_SUFFIX=-prod` - Generate Firebase config

## Deployment
- `make release-prod-ios BUILD_NUMBER=1` - Release iOS to TestFlight/App Store

## Flutter Version Management
- `fvm flutter pub get` - Install dependencies with FVM
- `fvm flutter --version` - Check Flutter version

## Useful System Commands (Darwin)
- `find . -name "*.dart" -not -path "./ios/Pods/*"` - Find Dart files
- `grep -r "pattern" lib/` - Search in lib directory
- `ls -la` - List files with details
- `cd path/to/directory` - Change directory