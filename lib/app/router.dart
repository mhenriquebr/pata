import 'package:go_router/go_router.dart';
import 'package:pata/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:pata/features/pets/presentation/screens/pet_detail_screen.dart';
import 'package:pata/features/pets/presentation/screens/pet_form_screen.dart';
import 'package:pata/features/pets/presentation/screens/pet_list_screen.dart';

/// Define todas as rotas do aplicativo em um único lugar.
///
/// Mantido como classe utilitária com um único membro estático
/// ([router]) para que `app.dart` e testes possam importar a
/// configuração sem precisar instanciá-la.
abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
    routes: <RouteBase>[
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
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
