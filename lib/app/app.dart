import 'package:flutter/material.dart';
import 'package:pata/app/router.dart';
import 'package:pata/core/theme/app_theme.dart';
import 'package:pata/features/pets/data/repositories/in_memory_pet_repository.dart';
import 'package:pata/features/pets/domain/repositories/pet_repository.dart';
import 'package:pata/features/pets/presentation/providers/pet_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Widget raiz da aplicação.
///
/// Responsável por:
/// 1. Registrar as dependências (repositório e provider) via [MultiProvider] —
///    é o único ponto do app que conhece a implementação concreta
///    ([InMemoryPetRepository]) do contrato [PetRepository].
/// 2. Configurar o [MaterialApp.router] com tema e rotas centralizados.
class PataApp extends StatelessWidget {
  const PataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<PetRepository>(
          create: (_) => InMemoryPetRepository(),
        ),
        ChangeNotifierProvider<PetProvider>(
          create: (BuildContext context) =>
              PetProvider(context.read<PetRepository>())..loadPets(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Pata',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
