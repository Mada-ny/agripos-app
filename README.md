# AgriPOS — Mobile Frontend

Flutter mobile POS operator app for an agricultural marketplace platform in Côte d'Ivoire.
POS operators use this app to manage farmer accounts, place product orders on their behalf, and record commodity repayments against credit debts.

Built with **Flutter 3.x** · **Dart** · **Riverpod** · **GoRouter** · **Dio**

---

## Requirements

- Flutter 3.11.5+
- Dart 3.11.5+
- Chrome (for web development)

---

## Setup

```bash
# 1. Clone the repository
git clone <repo-url>
cd agripos-app

# 2. Install dependencies
flutter pub get

# 3. Configure API endpoint (optional)
# If not specified, defaults to http://127.0.0.1:8000

# 4. Start development server
flutter run -d chrome

# Or with custom API URL:
flutter run -d chrome --dart-define=API_URL=http://localhost:8000
```

The app is now available at `http://localhost:3000`.

---

## Demo Accounts

| Role       | Email                        | Password    |
|------------|------------------------------|-------------|
| Operator   | <operateur@farmmarket.ci>    | Oper1234!   |

---

## Features

### Core Workflows

- **Authentication**: Secure login with token-based auth using Laravel Sanctum
- **Farmer Management**: Search, view, create, edit, and delete farmer profiles
- **Product Orders**: Browse products, add to cart, and place orders with cash/credit options
- **Credit Repayments**: Record commodity repayments with automatic FIFO debt settlement
- **Real-time Validation**: Client-side validation with server-side error handling

### UI/UX Highlights

- **Responsive Design**: Optimized for web deployment with mobile-first approach
- **Loading States**: Consistent loading indicators and error handling across all screens
- **Navigation**: Seamless routing with proper auth redirects and browser history support

---

## Common Commands

### Development

```bash
# Run app in web mode (development)
flutter run -d chrome

# Build for web (production)
flutter build web --release --base-href "/agripos-app/"

# Install dependencies
flutter pub get

# Generate Riverpod providers (code generation)
dart run build_runner watch --delete-conflicting-outputs

# Analyze code
flutter analyze

# Format code
dart format .
```

### Code Generation

This project uses Riverpod code generation. Providers with `@riverpod` annotations generate `.g.dart` files:

```bash
# Watch for changes during development
dart run build_runner watch --delete-conflicting-outputs

# One-time generation
dart run build_runner build --delete-conflicting-outputs
```

### Environment Configuration

The API endpoint can be configured using Flutter's `--dart-define` flag:

```bash
# Development
flutter run -d chrome --dart-define=API_URL=http://localhost:8000

# Production build (replace with your actual production API URL)
flutter build web --release --dart-define=API_URL=https://api.your-domain.ci --base-href "/agripos-app/"
```

If not specified, defaults to `http://127.0.0.1:8000`.

---

## Troubleshooting

### Common Issues

- **Build fails**: Run `flutter clean && flutter pub get`
- **Code generation errors**: Delete `.g.dart` files and run `dart run build_runner build`
- **Auth not working**: Verify API_URL environment variable is set correctly
- **Routing issues**: Check GoRouter configuration in `app.dart`

### Debug Commands

```bash
# Clean build cache
flutter clean

# Reset dependencies
flutter pub get

# Check Flutter version
flutter --version

# Doctor checkup
flutter doctor -v
```
