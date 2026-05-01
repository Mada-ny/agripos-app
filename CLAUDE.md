# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Mobile POS operator app for an agricultural marketplace platform in Côte d'Ivoire.
POS operators use this app to manage farmer accounts, place product orders on their
behalf, and record commodity repayments against credit debts.

- Consumes the Farmers Market Laravel API
- Built for Flutter Web — deployed and hosted on GitHub Pages

## Tech Stack

- **Framework**: Flutter 3.x, Dart
- **State Management**: Riverpod (flutter_riverpod)
- **HTTP Client**: Dio
- **Navigation**: GoRouter
- **Storage**: flutter_secure_storage (token), shared_preferences (cache)
- **Target**: Flutter Web — deployed on GitHub Pages

## Common Commands

```bash
# Run app in web mode (development)
flutter run -d chrome

# Build for web (production)
flutter build web --release --base-href "/agripos-app/"

# Deploy to GitHub Pages
flutter build web --release --base-href "/agripos-app/" && \
  cd build/web && git init && git add . && \
  git commit -m "deploy" && git push -f origin main

# Install dependencies
flutter pub get

# Generate Riverpod providers (code generation)
dart run build_runner watch --delete-conflicting-outputs

# Run all tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Analyze code
flutter analyze

# Format code
dart format .
```

## Architecture

**Project Structure**:

```
lib/
├── main.dart
├── app.dart                  # GoRouter setup, app theme
├── core/
│   ├── api/                  # Dio client, interceptors
│   ├── constants/            # API base URL, app constants
│   ├── errors/               # Exception classes
│   └── storage/              # Token storage, shared preferences
├── features/
│   ├── auth/
│   │   ├── data/             # AuthRepository, AuthService
│   │   ├── providers/        # Riverpod providers
│   │   └── screens/          # LoginScreen
│   ├── farmers/
│   │   ├── data/
│   │   ├── providers/
│   │   └── screens/
│   ├── products/
│   │   ├── data/
│   │   ├── providers/
│   │   └── screens/
│   ├── orders/
│   │   ├── data/
│   │   ├── providers/
│   │   └── screens/
│   └── repayments/
│       ├── data/
│       ├── providers/
│       └── screens/
└── shared/
    ├── widgets/              # Reusable UI components
    └── models/               # Shared data models
```

**Layer Responsibilities**:

- `data/` — API calls, models, repository pattern
- `providers/` — Riverpod providers, state management
- `screens/` — UI only, reads providers, no business logic

**Bootstrapping**:

`main.dart` calls `runApp(ProviderScope(child: AgriPosApp()))`. `app.dart` owns the `GoRouter` instance (exposed as a Riverpod provider) and the `MaterialApp.router`. The `DioClient` in `core/api/` attaches an interceptor that reads the token from `flutter_secure_storage` and injects the `Authorization` header; a 401 response triggers a logout redirect.

**Riverpod code generation**:

Providers using `@riverpod` annotations generate a `.g.dart` file alongside them (e.g., `farmers_provider.dart` → `farmers_provider.g.dart`). Run `dart run build_runner watch` during development. Never edit `.g.dart` files manually.

## Reference Docs

For detailed standards, read the relevant file before starting work:

- `.claude/rules/api-contracts.md`  — all API endpoints, request/response shapes
- `.claude/rules/design-system.md`  — color palette, typography, component styles

## Hard Rules

- Never put API calls directly in screens — always go through a repository in `data/`
- Never access providers outside of widgets without using `ref` from Riverpod
- Never hardcode the API base URL — always use `AppConstants.baseUrl`
- Never use `print()` in committed code — use proper error handling
- Never install new packages without asking first
- Always handle loading and error states in every screen
- Always use `GoRouter` for navigation — never `Navigator.push` directly
- Token must always be stored in `flutter_secure_storage` — never in memory only
- All API models must have `fromJson` and `toJson` methods
- `flutter analyze` must pass with zero errors before any commit

## Git Workflow

- Always create a new branch for each feature or bug fix
- Branch naming: `feature/short-description`, `fix/short-description`
- Push the branch to remote immediately after creating it (`git push -u origin <branch>`) — this allows GitHub PRs to have a proper diff; never merge locally before pushing
- Always run `dart format .` before committing
- Commit messages follow conventional commits format:
  `feat:`, `fix:`, `chore:`, `refactor:`, `test:`
- One commit per logical unit of work — no "WIP" or "misc fixes" commits
- Write clear, descriptive commit messages
- Never commit code that breaks existing tests
- Don't mention "Co-Authored-By Claude" in commit messages
