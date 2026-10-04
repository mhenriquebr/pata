import 'package:go_router/go_router.dart';
import 'package:pata/features/auth/presentation/providers/auth_provider.dart';
import 'package:pata/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:pata/features/auth/presentation/screens/login_screen.dart';
import 'package:pata/features/auth/presentation/screens/register_screen.dart';
import 'package:pata/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:pata/features/pets/presentation/screens/pet_detail_screen.dart';
import 'package:pata/features/pets/presentation/screens/pet_form_screen.dart';
import 'package:pata/features/pets/presentation/screens/pet_list_screen.dart';

const List<String> _authRoutes = <String>[
  '/login',
  '/register',
  '/forgot-password'
];

/// Monta a configuração de rotas do app.
///
/// É uma função (não mais um `GoRouter` estático) porque a lógica de
/// redirect precisa consultar o [authProvider] em tempo real, e o
/// router também precisa ouvi-lo (`refreshListenable`) para reagir
/// automaticamente a login/logout, sem navegação manual nas telas.
GoRouter buildAppRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/onboarding',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final String location = state.matchedLocation;

      // Onboarding é livre — não depende de autenticação.
      if (location == '/onboarding') return null;

      final bool loggedIn = authProvider.isAuthenticated;
      final bool onAuthRoute = _authRoutes.contains(location);

      // Não autenticado tentando acessar área protegida -> manda pro login.
      if (!loggedIn && !onAuthRoute) return '/login';

      // Já autenticado, mas preso numa tela de login/cadastro -> manda
      // pra área interna (evita ficar "preso" na tela de login).
      if (loggedIn && onAuthRoute) return '/';

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'pet-list',
        builder: (context, state) => const PetListScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'pets/new',
            name: 'pet-new',
            builder: (context, state) => const PetFormScreen(),
          ),
          GoRoute(
            path: 'pets/:id',
            name: 'pet-detail',
            builder: (context, state) {
              final String id = state.pathParameters['id']!;
              return PetDetailScreen(petId: id);
            },
          ),
        ],
      ),
    ],
  );
}
