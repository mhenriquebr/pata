/// Representação, no domínio do app, de um usuário autenticado.
///
/// Existe para que o resto do app nunca dependa diretamente do tipo
/// `User` do pacote `firebase_auth` — só a camada `data` conhece o
/// Firebase; domínio e apresentação conhecem apenas [AppUser].
class AppUser {
  const AppUser({required this.uid, required this.email});

  final String uid;
  final String? email;
}
