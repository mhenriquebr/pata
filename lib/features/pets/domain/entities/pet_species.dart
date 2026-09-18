/// Espécies suportadas pela entidade principal [Pet].
///
/// Restrito a cães e gatos por decisão de escopo do projeto.
enum PetSpecies {
  dog,
  cat;

  /// Rótulo amigável exibido ao usuário (pt-BR).
  String get label {
    switch (this) {
      case PetSpecies.dog:
        return 'Cachorro';
      case PetSpecies.cat:
        return 'Gato';
    }
  }
}
