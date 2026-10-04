import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pata/core/widgets/empty_state.dart';
import 'package:pata/features/auth/presentation/providers/auth_provider.dart';
import 'package:pata/features/pets/presentation/providers/pet_provider.dart';
import 'package:pata/features/pets/presentation/widgets/pet_card.dart';
import 'package:provider/provider.dart';

/// Tela inicial da área autenticada: lista todos os pets cadastrados.
///
/// StatelessWidget — todo o estado (lista, loading, erro) vem do
/// [PetProvider]. O menu de conta/logout lê o [AuthProvider], mas a
/// ação de sair em si (`signOut`) é só delegada — quem decide para
/// onde navegar depois é o redirect do go_router, ao detectar que o
/// usuário deixou de estar autenticado.
class PetListScreen extends StatelessWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pata'),
        actions: <Widget>[
          PopupMenuButton<String>(
            tooltip: 'Conta',
            icon: const Icon(Icons.account_circle_outlined),
            onSelected: (String value) {
              if (value == 'logout') {
                authProvider.signOut();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                enabled: false,
                child: Text(
                  authProvider.currentUser?.email ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sair'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
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
