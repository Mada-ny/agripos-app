import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'core/constants/app_constants.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/farmers/screens/farmer_account_screen.dart';
import 'features/farmers/screens/farmer_search_screen.dart';
import 'features/repayments/screens/record_repayment_screen.dart';

part 'app.g.dart';

@Riverpod(keepAlive: true)
class RouterNotifier extends _$RouterNotifier implements Listenable {
  VoidCallback? _routerListener;

  @override
  void build() {
    ref.listen(authNotifierProvider, (_, _) => _routerListener?.call());
  }

  @override
  void addListener(VoidCallback listener) => _routerListener = listener;

  @override
  void removeListener(VoidCallback listener) => _routerListener = null;

  String? redirect(BuildContext context, GoRouterState state) {
    final auth = ref.read(authNotifierProvider);
    return auth.when(
      data: (user) {
        final onLogin = state.matchedLocation == '/login';
        if (user == null && !onLogin) return '/login';
        if (user != null && onLogin) return '/farmers';
        return null;
      },
      loading: () => null,
      error: (_, _) => '/login',
    );
  }
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final notifier = ref.read(routerNotifierProvider.notifier);
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/farmers', builder: (_, _) => const FarmerSearchScreen()),
      GoRoute(
        path: '/farmers/new',
        builder: (_, _) => const _Placeholder('Create Farmer'),
      ),
      GoRoute(
        path: '/farmers/:id',
        builder: (context, state) => FarmerAccountScreen(
          farmerId: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/products',
        builder: (_, _) => const _Placeholder('Products'),
      ),
      GoRoute(
        path: '/orders/checkout',
        builder: (_, _) => const _Placeholder('Order Checkout'),
      ),
      GoRoute(
        path: '/repayments',
        builder: (context, state) {
          final farmerIdStr = state.uri.queryParameters['farmer_id'];
          if (farmerIdStr == null) {
            return const _Placeholder('Record Repayment');
          }
          return RecordRepaymentScreen(farmerId: int.parse(farmerIdStr));
        },
      ),
    ],
  );
}

class AgriPosApp extends ConsumerWidget {
  const AgriPosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(routerProvider);
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      routerConfig: goRouter,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2d5d3a),
        onPrimary: Color(0xFFffffff),
        secondary: Color(0xFFc97a2b),
        onSecondary: Color(0xFFffffff),
        error: Color(0xFFb3321b),
        surface: Color(0xFFffffff),
        onSurface: Color(0xFF231a10),
      ),
      scaffoldBackgroundColor: const Color(0xFFfaf6ef),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2d5d3a),
        foregroundColor: Color(0xFFffffff),
        elevation: 0,
        toolbarHeight: 56,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFf3ede2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFe3d8c2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFe3d8c2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2d5d3a), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2d5d3a),
          foregroundColor: const Color(0xFFffffff),
          minimumSize: const Size.fromHeight(48),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFFffffff),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFe3d8c2)),
        ),
      ),
    );
  }
}

// Temporary placeholder — replaced when the real screen is built.
class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
