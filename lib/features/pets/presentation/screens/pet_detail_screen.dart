import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pata/core/widgets/app_snackbar.dart';
import 'package:pata/core/widgets/empty_state.dart';
import 'package:pata/features/pets/domain/entities/pet.dart';
import 'package:pata/features/pets/presentation/providers/pet_provider.dart';
import 'package:pata/features/pets/presentation/widgets/sex_icon.dart';
import 'package:pata/features/pets/presentation/widgets/species_icon.dart';
import 'package:provider/provider.dart';

/// Tela de detalhes de um pet específico, identificado por [petId].
class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({required this.petId, super.key});

  final String petId;

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do pet')),
      body: Consumer<PetProvider>(
        builder: (BuildContext context, PetProvider provider, _) {
          final Pet? pet = provider.pets
              .cast<Pet?>()
              .firstWhere((Pet? p) => p?.id == petId, orElse: () => null);

          if (pet == null) {
            return const EmptyState(
              icon: Icons.search_off,
              title: 'Pet não encontrado',
              message: 'Ele pode ter sido removido.',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    petSpeciesIcon(pet.species),
                    size: 48,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  pet.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 24),
              _DetailTile(
                icon: Icons.pets_outlined,
                label: 'Espécie',
                value: pet.species.label,
              ),
              _DetailTile(
                icon: petSexIcon(pet.sex),
                label: 'Sexo',
                value: pet.sex.label,
              ),
              _DetailTile(
                icon: Icons.tag,
                label: 'Raça',
                value: pet.breed,
              ),
              _DetailTile(
                icon: Icons.cake_outlined,
                label: 'Data de nascimento',
                value:
                    '${dateFormat.format(pet.birthDate)} (${pet.ageInYears} ano(s))',
              ),
              _DetailTile(
                icon: Icons.monitor_weight_outlined,
                label: 'Peso',
                value: '${pet.weightKg.toStringAsFixed(1)} kg',
              ),
              _DetailTile(
                icon: Icons.vaccines_outlined,
                label: 'Vacinação',
                value: pet.vaccinationStatus.label,
              ),
              if (pet.notes.trim().isNotEmpty)
                _DetailTile(
                  icon: Icons.note_alt_outlined,
                  label: 'Observações',
                  value: pet.notes,
                ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(color: Theme.of(context).colorScheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => _confirmDelete(context, pet),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Excluir pet'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Pet pet) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Excluir pet'),
          content: Text('Deseja realmente excluir "${pet.name}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final PetProvider provider = context.read<PetProvider>();
    final bool success = await provider.deletePet(pet.id);

    if (!context.mounted) return;

    if (success) {
      AppSnackbar.showSuccess(context, '"${pet.name}" foi removido.');
      context.pop();
    } else {
      AppSnackbar.showError(
        context,
        provider.errorMessage ?? 'Não foi possível excluir o pet.',
      );
    }
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: colorScheme.outline),
                ),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
