/// Erro de acesso a dados dos pets, já com mensagem pronta (pt-BR) para
/// exibir ao usuário. A camada `data` converte exceções do Firestore em
/// [PetFailure]; a apresentação nunca vê detalhes técnicos do Firebase.
class PetFailure implements Exception {
  const PetFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
