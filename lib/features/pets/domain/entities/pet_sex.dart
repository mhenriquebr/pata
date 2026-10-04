/// Sexo biológico do pet.
enum PetSex {
  male,
  female;

  String get label {
    switch (this) {
      case PetSex.male:
        return 'Macho';
      case PetSex.female:
        return 'Fêmea';
    }
  }
}
