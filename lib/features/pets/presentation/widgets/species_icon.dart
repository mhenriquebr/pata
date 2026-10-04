import 'package:flutter/material.dart';
import 'package:pata/features/pets/domain/entities/pet_species.dart';

IconData petSpeciesIcon(PetSpecies species) {
  switch (species) {
    case PetSpecies.dog:
      return Icons.pets;
    case PetSpecies.cat:
      return Icons.cruelty_free;
  }
}
