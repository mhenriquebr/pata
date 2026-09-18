/// Situação vacinal do pet.
///
/// Nesta etapa (Trabalho 1) é apenas um dado informado manualmente pelo
/// tutor no cadastro (mockado). Nas próximas entregas isso pode evoluir
/// para um histórico de vacinas por data, vinculado ao Cloud Firestore.
enum VaccinationStatus {
  upToDate,
  notStarted,
  partiallyStarted;

  /// Rótulo amigável exibido ao usuário (pt-BR).
  String get label {
    switch (this) {
      case VaccinationStatus.upToDate:
        return 'Sim, em dia';
      case VaccinationStatus.notStarted:
        return 'Não vacinado';
      case VaccinationStatus.partiallyStarted:
        return 'Primeiras doses';
    }
  }
}
