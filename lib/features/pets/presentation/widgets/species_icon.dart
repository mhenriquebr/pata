import 'package:flutter/material.dart';
import 'package:pata/features/pets/domain/entities/pet_species.dart';

/// Mapeia cada [PetSpecies] para um ícone do Material Design.
///
/// Função utilitária pura (sem estado, sem efeitos colaterais) para ser
/// reutilizada em qualquer widget que precise representar a espécie
/// visualmente (lista, card, detalhes).
IconData petSpeciesIcon(PetSpecies species) {
  switch (species) {
    case PetSpecies.dog:
      return Icons.pets;
    case PetSpecies.cat:
      return Icons.cruelty_free;
  }
}
