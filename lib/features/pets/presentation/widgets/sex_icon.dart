import 'package:flutter/material.dart';
import 'package:pata/features/pets/domain/entities/pet_sex.dart';

/// Mapeia cada [PetSex] para um ícone do Material Design.
IconData petSexIcon(PetSex sex) {
  switch (sex) {
    case PetSex.male:
      return Icons.male;
    case PetSex.female:
      return Icons.female;
  }
}
