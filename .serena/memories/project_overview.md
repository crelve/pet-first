# Project Overview

## Project Purpose
**flutter_template** is a comprehensive Flutter template project designed for rapid mobile app development with enterprise-level features and Firebase integration.

## Tech Stack
- **Framework**: Flutter (SDK >=3.7.0 <4.0.0)
- **State Management**: Riverpod with Flutter Hooks
- **Backend**: Firebase (Auth, Firestore, Analytics, Functions, Storage, etc.)
- **Monetization**: Google AdMob and In-App Purchases
- **UI/UX**: Material Design with custom theming
- **Build Tool**: make commands
- **Testing**: flutter_test with coverage support
- **Code Generation**: build_runner, freezed, json_serializable

## Key Dependencies
- hooks_riverpod: ^2.5.1 (State management)
- firebase_core: ^3.0.0 (Firebase integration)
- freezed_annotation: ^2.4.1 (Immutable data classes)
- go_router: ^15.2.4 (Navigation)
- flutter_localizations (i18n support)

## Project Structure
```
lib/
├── component/          # Reusable UI components
├── screen/            # Application screens  
├── provider/          # Riverpod state providers
├── model/             # Data models and DTOs
├── hook/              # Custom Flutter hooks
├── utility/           # Helper functions
├── route/             # GoRouter configuration
├── theme/             # App theming
├── type/              # Type definitions
├── import/            # Centralized imports
├── gen/               # Generated files
├── l10n/              # Internationalization
```