import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pata/features/auth/domain/auth_failure.dart';
import 'package:pata/features/auth/domain/entities/app_user.dart';
import 'package:pata/features/auth/domain/repositories/auth_repository.dart';

/// Estado de autenticação da apresentação.
///
/// Escuta [AuthRepository.authStateChanges] e expõe, de forma reativa,
/// se há um usuário logado — usado tanto pelas telas de login/cadastro
/// quanto pelo redirect do go_router (ver `app/router.dart`), que ouve
/// este provider via `refreshListenable`.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository) {
    _subscription = _repository.authStateChanges().listen(_onUserChanged);
  }

  final AuthRepository _repository;
  late final StreamSubscription<AppUser?> _subscription;

  AppUser? _currentUser;
  bool _isInitializing = true;
  bool _isLoading = false;
  String? _errorMessage;

  AppUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  /// `true` até a primeira resposta do Firebase sobre o estado de
  /// autenticação (login persistido de uma sessão anterior, por
  /// exemplo). Usado para mostrar uma splash em vez de "piscar" a tela
  /// de login antes de redirecionar quem já estava logado.
  bool get isInitializing => _isInitializing;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _onUserChanged(AppUser? user) {
    _currentUser = user;
    _isInitializing = false;
    notifyListeners();
  }

  Future<bool> signIn({required String email, required String password}) {
    return _run(() => _repository.signInWithEmail(
          email: email.trim(),
          password: password,
        ));
  }

  Future<bool> signUp({required String email, required String password}) {
    return _run(() => _repository.signUpWithEmail(
          email: email.trim(),
          password: password,
        ));
  }

  Future<bool> sendPasswordResetEmail({required String email}) {
    return _run(
      () => _repository.sendPasswordResetEmail(email: email.trim()),
    );
  }

  Future<void> signOut() => _repository.signOut();

  /// Executa uma operação assíncrona de autenticação com o mesmo
  /// tratamento de loading/erro em todos os fluxos (login, cadastro,
  /// recuperação de senha) — evita repetir try/catch em cada método.
  Future<bool> _run(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on AuthFailure catch (failure) {
      _errorMessage = failure.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
