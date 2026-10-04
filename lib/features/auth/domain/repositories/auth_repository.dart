import 'package:pata/features/auth/domain/entities/app_user.dart';

/// Contrato de autenticação. A apresentação depende apenas desta
/// interface — [FirebaseAuthRepository] é a única implementação que
/// conhece o pacote `firebase_auth`.
abstract interface class AuthRepository {
  /// Emite o usuário atual sempre que o estado de autenticação muda
  /// (login, logout, ou sessão já existente ao abrir o app). Emite
  /// `null` quando não há usuário autenticado.
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut();
}
