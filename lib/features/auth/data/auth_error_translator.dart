/// Traduz códigos de erro do `FirebaseAuthException.code` para mensagens
/// compreensíveis em pt-BR, nunca expondo texto técnico ao usuário final.
///
/// Mantido como função pura e isolada (nem no repositório, nem na UI)
/// para ficar fácil de testar e de estender conforme surgirem novos
/// códigos de erro.
String translateFirebaseAuthError(String code) {
  switch (code) {
    case 'invalid-email':
      return 'Esse e-mail não parece válido. Confira e tente novamente.';
    case 'user-disabled':
      return 'Esta conta foi desativada. Fale com o suporte.';
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return 'Não foi possível entrar. Confira seu e-mail e senha e tente '
          'novamente.';
    case 'email-already-in-use':
      return 'Já existe uma conta cadastrada com esse e-mail.';
    case 'weak-password':
      return 'Escolha uma senha mais forte (mínimo de 6 caracteres).';
    case 'operation-not-allowed':
      return 'Login por e-mail e senha não está habilitado no momento.';
    case 'too-many-requests':
      return 'Muitas tentativas seguidas. Aguarde um pouco e tente '
          'novamente.';
    case 'network-request-failed':
      return 'Falha de conexão. Verifique sua internet e tente novamente.';
    case 'requires-recent-login':
      return 'Por segurança, entre novamente para concluir essa ação.';
    default:
      return 'Não foi possível completar a operação. Tente novamente.';
  }
}
