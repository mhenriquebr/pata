import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pata/core/widgets/empty_state.dart';
import 'package:pata/features/auth/presentation/providers/auth_provider.dart';
import 'package:pata/features/pets/domain/entities/pet.dart';
import 'package:pata/features/pets/presentation/providers/pet_provider.dart';
import 'package:pata/features/pets/presentation/widgets/pet_card.dart';
import 'package:provider/provider.dart';

/// Tela inicial da área autenticada: lista os pets DA CONTA logada,
/// em tempo real (Stream do Firestore), com loading, estado vazio e
/// tratamento de erro.
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
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.loadError != null && provider.pets.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  EmptyState(
                    icon: Icons.cloud_off_outlined,
                    title: 'Não foi possível carregar',
                    message: provider.loadError!,
                  ),
                  FilledButton.icon(
                    onPressed: provider.retry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          if (provider.pets.isEmpty) {
            return ListView(
              children: <Widget>[
                const SizedBox(height: 96),
                const EmptyState(
                  icon: Icons.pets_outlined,
                  title: 'Nenhum pet cadastrado ainda',
                  message: 'Os pets que você cadastrar aparecerão aqui.',
                ),
                Center(
                  child: FilledButton.icon(
                    onPressed: () => context.push('/pets/new'),
                    icon: const Icon(Icons.add),
                    label: const Text('Cadastrar primeiro pet'),
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 88),
            itemCount: provider.pets.length,
            itemBuilder: (BuildContext context, int index) {
              final Pet pet = provider.pets[index];
              return PetCard(
                pet: pet,
                onTap: () => context.push('/pets/${pet.id}'),
              );
            },
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
