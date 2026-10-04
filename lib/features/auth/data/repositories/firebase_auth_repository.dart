import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:pata/features/auth/data/auth_error_translator.dart';
import 'package:pata/features/auth/domain/auth_failure.dart';
import 'package:pata/features/auth/domain/entities/app_user.dart';
import 'package:pata/features/auth/domain/repositories/auth_repository.dart';

/// Implementação de [AuthRepository] baseada no Firebase Authentication.
///
/// É a única classe do projeto que importa `package:firebase_auth` —
/// isso mantém o Firebase isolado na camada `data`, conforme pedido:
/// nenhuma tela/widget chama o Firebase diretamente.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({fb.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance;

  final fb.FirebaseAuth _firebaseAuth;

  AppUser? _toAppUser(fb.User? user) {
    if (user == null) return null;
    return AppUser(uid: user.uid, email: user.email);
  }

  @override
  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_toAppUser);
  }

  @override
  AppUser? get currentUser => _toAppUser(_firebaseAuth.currentUser);

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(translateFirebaseAuthError(e.code));
    } catch (_) {
      throw const AuthFailure(
        'Não foi possível entrar. Tente novamente em instantes.',
      );
    }
  }

  @override
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(translateFirebaseAuthError(e.code));
    } catch (_) {
      throw const AuthFailure(
        'Não foi possível criar a conta. Tente novamente em instantes.',
      );
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(translateFirebaseAuthError(e.code));
    } catch (_) {
      throw const AuthFailure(
        'Não foi possível enviar o e-mail de recuperação. Tente novamente.',
      );
    }
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();
}
