/// Contrato para qualquer entidade de domínio que possua identidade única.
///
/// Usado para permitir que repositórios e widgets genéricos (ex.: listas)
/// operem sobre qualquer entidade sem conhecer seus detalhes internos —
/// um exemplo simples de polimorfismo por interface, que será reaproveitado
/// quando novas entidades forem adicionadas nas próximas etapas do projeto.
abstract interface class Identifiable {
  String get id;
}
