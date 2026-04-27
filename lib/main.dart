import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sante_famille/core/theme/app_theme.dart';
import 'package:sante_famille/core/widgets/main_scaffold.dart';
import 'package:sante_famille/features/auth/presentation/providers/auth_provider.dart';
import 'package:sante_famille/features/auth/presentation/screens/login_screen.dart';
import 'package:sante_famille/features/auth/presentation/screens/register_screen.dart';
import 'package:sante_famille/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:sante_famille/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:sante_famille/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:sante_famille/features/pleurs/presentation/screens/pleurs_screen.dart';
import 'package:sante_famille/features/toise/presentation/screens/toise_screen.dart';
import 'package:sante_famille/features/carnet/presentation/screens/carnet_screen.dart';
import 'package:sante_famille/features/carnet/presentation/screens/add_vaccin_screen.dart';
import 'package:sante_famille/features/hopitaux/presentation/screens/hopitaux_screen.dart';
import 'package:sante_famille/features/encyclopedie/presentation/screens/encyclopedie_screen.dart';
import 'package:sante_famille/features/nutrition/presentation/screens/nutrition_screen.dart';
import 'package:sante_famille/features/forum/presentation/screens/forum_screen.dart';
import 'package:sante_famille/features/profil/presentation/screens/profil_screen.dart';
import 'package:sante_famille/features/profil/presentation/screens/parametres_screen.dart';
import 'package:sante_famille/features/profil/presentation/screens/courbe_croissance_screen.dart';
import 'package:sante_famille/features/profil/presentation/screens/rdv_screen.dart';
import 'package:sante_famille/features/core/presentation/screens/ussd_screen.dart';
import 'package:sante_famille/core/constants/app_routes.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final path = state.uri.path;

      // Allow splash and onboarding without login
      if (path == '/splash' || path == '/onboarding') return null;

      final isLoggingIn = path == AppRoutes.login || path == AppRoutes.register;

      if (!isLoggedIn && !isLoggingIn) return AppRoutes.login;
      if (isLoggedIn && isLoggingIn) return AppRoutes.dashboard;
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.forum,
            builder: (context, state) => const ForumScreen(),
          ),
          GoRoute(
            path: AppRoutes.profil,
            builder: (context, state) => const ProfilScreen(),
          ),
        ],
      ),
      // Other routes outside of Shell (full screen)
      GoRoute(
        path: AppRoutes.carnet,
        builder: (context, state) => const CarnetScreen(),
      ),
      GoRoute(
        path: AppRoutes.addVaccin,
        builder: (context, state) => const AddVaccinScreen(),
      ),
      GoRoute(
        path: AppRoutes.pleurs,
        builder: (context, state) => const PleursScreen(),
      ),
      GoRoute(
        path: AppRoutes.toise,
        builder: (context, state) => const ToiseScreen(),
      ),
      GoRoute(
        path: AppRoutes.hopitaux,
        builder: (context, state) => const HopitauxScreen(),
      ),
      GoRoute(
        path: AppRoutes.encyclopedie,
        builder: (context, state) => const EncyclopedieScreen(),
      ),
      GoRoute(
        path: AppRoutes.nutrition,
        builder: (context, state) => const NutritionScreen(),
      ),
      GoRoute(
        path: AppRoutes.parametres,
        builder: (context, state) => const ParametresScreen(),
      ),
      GoRoute(
        path: AppRoutes.courbe,
        builder: (context, state) => const CourbeCroissanceScreen(),
      ),
      GoRoute(
        path: AppRoutes.rdv,
        builder: (context, state) => const RdvScreen(),
      ),
      GoRoute(
        path: AppRoutes.ussd,
        builder: (context, state) => const UssdScreen(),
      ),
    ],
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Santé Famille',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Écran $title en cours de développement')),
    );
  }
}
