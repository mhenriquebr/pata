import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pata/core/widgets/empty_state.dart';
import 'package:pata/features/pets/presentation/providers/pet_provider.dart';
import 'package:pata/features/pets/presentation/widgets/pet_card.dart';
import 'package:provider/provider.dart';

/// Tela inicial do app: lista todos os pets cadastrados.
///
/// StatelessWidget — todo o estado (lista, loading, erro) vem do
/// [PetProvider], observado via [Consumer]. Nenhuma lógica de negócio
/// é feita aqui, apenas montagem de UI a partir do estado já pronto.
class PetListScreen extends StatelessWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pata')),
      body: Consumer<PetProvider>(
        builder: (BuildContext context, PetProvider provider, _) {
          if (provider.isLoading && provider.pets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.pets.isEmpty) {
            return RefreshIndicator(
              onRefresh: provider.loadPets,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const <Widget>[
                  SizedBox(height: 96),
                  EmptyState(
                    icon: Icons.pets_outlined,
                    title: 'Nenhum pet cadastrado ainda',
                    message:
                        'Toque no botão "+" para cadastrar o primeiro pet.',
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadPets,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 88),
              itemCount: provider.pets.length,
              itemBuilder: (BuildContext context, int index) {
                final pet = provider.pets[index];
                return PetCard(
                  pet: pet,
                  onTap: () => context.push('/pets/${pet.id}'),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/pets/new'),
        icon: const Icon(Icons.add),
        label: const Text('Novo pet'),
      ),
    );
  }
}
