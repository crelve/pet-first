fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios get_api_key

```sh
[bundle exec] fastlane ios get_api_key
```

Get App Store Connect API key

### ios read_code_signing

```sh
[bundle exec] fastlane ios read_code_signing
```

Read code signing certificates and profiles from git repo

### ios create_new_code_signing

```sh
[bundle exec] fastlane ios create_new_code_signing
```

Create new code signing certificates and profiles

### ios regenerate_profiles

```sh
[bundle exec] fastlane ios regenerate_profiles
```

Regenerate provisioning profiles with updated capabilities

### ios sync_certificates

```sh
[bundle exec] fastlane ios sync_certificates
```

Sync certificates and profiles

### ios release_ios_dev

```sh
[bundle exec] fastlane ios release_ios_dev
```

Build and upload to TestFlight (dev environment)

### ios release_ios_prod

```sh
[bundle exec] fastlane ios release_ios_prod
```

Build and upload to TestFlight (prod environment)

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Build and upload to TestFlight (alias for release_ios_prod)

### ios release

```sh
[bundle exec] fastlane ios release
```

Build and upload to App Store (prod environment)

### ios take_screenshots

```sh
[bundle exec] fastlane ios take_screenshots
```

Take screenshots automatically using Flutter integration test (Dart only)

### ios take_screenshots_quick

```sh
[bundle exec] fastlane ios take_screenshots_quick
```

Quick test: Take screenshots for 2 languages (Japanese & English)

### ios generate_framefiles

```sh
[bundle exec] fastlane ios generate_framefiles
```

Generate Framefiles from ARB translations (auto-localization)

### ios customize_screenshots

```sh
[bundle exec] fastlane ios customize_screenshots
```

Customize screenshot files for your app (Phase 0)

### ios apply_frames

```sh
[bundle exec] fastlane ios apply_frames
```

Apply device frames and marketing design to existing screenshots

### ios apply_frames_quick

```sh
[bundle exec] fastlane ios apply_frames_quick
```

Quick test: Apply frames to 2 languages only (Japanese & English)

### ios screenshots_with_frames

```sh
[bundle exec] fastlane ios screenshots_with_frames
```

Take screenshots and apply frames (for App Store)

### ios upload_screenshots

```sh
[bundle exec] fastlane ios upload_screenshots
```

Upload screenshots to App Store Connect

Options:

  UPLOAD_LANGUAGES: Comma-separated list of languages to upload (e.g., 'ja,en-US,zh-Hans,ko')

  If not specified, uploads all languages in screenshots/ directory

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
