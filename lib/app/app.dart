import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pata/app/router.dart';
import 'package:pata/core/theme/app_theme.dart';
import 'package:pata/core/widgets/splash_screen.dart';
import 'package:pata/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:pata/features/auth/domain/repositories/auth_repository.dart';
import 'package:pata/features/auth/presentation/providers/auth_provider.dart';
import 'package:pata/features/pets/data/repositories/firestore_pet_repository.dart';
import 'package:pata/features/pets/domain/repositories/pet_repository.dart';
import 'package:pata/features/pets/presentation/providers/pet_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Widget raiz da aplicação.
///
/// Único ponto que conhece as implementações concretas
/// ([FirebaseAuthRepository], [FirestorePetRepository]) dos contratos
/// de domínio. O [PetProvider] depende do [AuthProvider]: sempre que o
/// usuário muda (login/logout), ele passa a escutar os dados da conta
/// certa — é isso que isola os dados de cada usuário na interface.
class PataApp extends StatelessWidget {
  const PataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<AuthRepository>(create: (_) => FirebaseAuthRepository()),
        ChangeNotifierProvider<AuthProvider>(
          create: (BuildContext context) =>
              AuthProvider(context.read<AuthRepository>()),
        ),
        Provider<PetRepository>(create: (_) => FirestorePetRepository()),
        ChangeNotifierProxyProvider<AuthProvider, PetProvider>(
          create: (BuildContext context) =>
              PetProvider(context.read<PetRepository>()),
          update: (
            BuildContext context,
            AuthProvider auth,
            PetProvider? previous,
          ) {
            final PetProvider provider =
                previous ?? PetProvider(context.read<PetRepository>());
            provider.bindUser(auth.currentUser?.uid);
            return provider;
          },
        ),
      ],
      child: const _AppRouterHost(),
    );
  }
}

/// Monta o [GoRouter] uma única vez e mostra uma splash enquanto o
/// Firebase ainda não respondeu sobre uma eventual sessão existente.
class _AppRouterHost extends StatefulWidget {
  const _AppRouterHost();

  @override
  State<_AppRouterHost> createState() => _AppRouterHostState();
}

class _AppRouterHostState extends State<_AppRouterHost> {
  late final GoRouter _router =
      buildAppRouter(context.read<AuthProvider>());

  @override
  Widget build(BuildContext context) {
    final bool isInitializing = context.watch<AuthProvider>().isInitializing;

    if (isInitializing) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
      );
    }

    return MaterialApp.router(
      title: 'Pata',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
