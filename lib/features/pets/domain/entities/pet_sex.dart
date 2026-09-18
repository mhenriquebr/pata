/// Sexo biológico do pet.
///
/// Enum simples, no mesmo padrão de [PetSpecies]: garante que a UI só
/// permita valores válidos (nada de texto livre digitado errado).
enum PetSex {
  male,
  female;

  /// Rótulo amigável exibido ao usuário (pt-BR).
  String get label {
    switch (this) {
      case PetSex.male:
        return 'Macho';
      case PetSex.female:
        return 'Fêmea';
    }
  }
}
