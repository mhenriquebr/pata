/// Situação vacinal do pet.
///
/// Nesta etapa é apenas um dado informado manualmente pelo tutor no
/// cadastro (mockado). No Trabalho 3, com Cloud Firestore, isso pode
/// evoluir para um histórico de vacinas por data.
enum VaccinationStatus {
  upToDate,
  notStarted,
  partiallyStarted;

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
