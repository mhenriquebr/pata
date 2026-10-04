/// Erro de autenticação já traduzido para uma mensagem compreensível
/// (pt-BR), pronta para ser exibida ao usuário.
///
/// A camada `data` é responsável por capturar exceções específicas do
/// Firebase e relançá-las como [AuthFailure], para que a apresentação
/// nunca precise conhecer detalhes técnicos do provedor de autenticação.
class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
