import 'package:flutter/material.dart';
import 'package:pata/features/pets/domain/entities/pet.dart';
import 'package:pata/features/pets/presentation/widgets/sex_icon.dart';
import 'package:pata/features/pets/presentation/widgets/species_icon.dart';

/// Card usado em [PetListScreen] para exibir um resumo de cada pet.
///
/// Widget puramente de apresentação: recebe o [pet] já pronto e um
/// callback [onTap] — nenhuma lógica de negócio ou acesso a dados aqui.
class PetCard extends StatelessWidget {
  const PetCard({
    required this.pet,
    required this.onTap,
    super.key,
  });

  final Pet pet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 28,
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(
                  petSpeciesIcon(pet.species),
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            pet.name,
                            style: textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          petSexIcon(pet.sex),
                          size: 16,
                          color: colorScheme.outline,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet.species.label} • ${pet.breed}',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.outline),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${pet.ageInYears} ano(s) • ${pet.weightKg.toStringAsFixed(1)} kg',
                      style: textTheme.bodySmall
                          ?.copyWith(color: colorScheme.outline),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}
