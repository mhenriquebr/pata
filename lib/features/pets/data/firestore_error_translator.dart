/// Traduz códigos de `FirebaseException.code` (Firestore) para mensagens
/// compreensíveis em pt-BR, sem expor texto técnico ao usuário.
String translateFirestoreError(String code) {
  switch (code) {
    case 'permission-denied':
      return 'Você não tem permissão para acessar esses dados. Saia e '
          'entre novamente.';
    case 'unauthenticated':
      return 'Sua sessão expirou. Entre novamente para continuar.';
    case 'unavailable':
    case 'deadline-exceeded':
      return 'Falha de conexão. Verifique sua internet e tente novamente.';
    case 'not-found':
      return 'Esse pet não foi encontrado. Ele pode ter sido removido.';
    default:
      return 'Não foi possível concluir a operação. Tente novamente.';
  }
}
