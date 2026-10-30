import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pata/features/pets/domain/entities/pet.dart';
import 'package:pata/features/pets/domain/entities/pet_sex.dart';
import 'package:pata/features/pets/domain/entities/pet_species.dart';
import 'package:pata/features/pets/domain/entities/vaccination_status.dart';
import 'package:pata/features/pets/domain/pet_failure.dart';
import 'package:pata/features/pets/domain/repositories/pet_repository.dart';
import 'package:uuid/uuid.dart';

/// Estado da feature "pets" para a UI.
///
/// Escuta em tempo real os pets do usuário autenticado (Stream do
/// Firestore) e expõe as ações de CRUD. O UID vem da sessão, via
/// [bindUser] (chamado pelo ProxyProvider em `app/app.dart`) — nunca de
/// um campo digitado em tela.
class PetProvider extends ChangeNotifier {
  PetProvider(this._repository);

  final PetRepository _repository;
  final Uuid _uuid = const Uuid();

  String? _userId;
  StreamSubscription<List<Pet>>? _subscription;
  List<Pet> _pets = <Pet>[];
  bool _isLoading = false;
  String? _loadError;
  String? _errorMessage;
  bool _disposed = false;

  List<Pet> get pets => List<Pet>.unmodifiable(_pets);

  /// `true` enquanto a primeira resposta do Firestore não chegou.
  bool get isLoading => _isLoading;

  /// Erro ao CARREGAR a lista (ex.: sem permissão, sem conexão).
  String? get loadError => _loadError;

  /// Erro da última AÇÃO (cadastrar, editar, excluir).
  String? get errorMessage => _errorMessage;

  Pet? petById(String id) {
    for (final Pet pet in _pets) {
      if (pet.id == id) return pet;
    }
    return null;
  }

  /// Liga o provider ao usuário logado (ou desliga, se `null`).
  /// Ao trocar de usuário, a lista anterior é descartada.
  void bindUser(String? userId) {
    if (userId == _userId) return;
    _userId = userId;
    _subscribe();
  }

  /// Tenta carregar a lista de novo (botão "Tentar novamente").
  void retry() => _subscribe();

  void _subscribe() {
    _subscription?.cancel();
    _subscription = null;
    _pets = <Pet>[];
    _loadError = null;

    final String? userId = _userId;
    if (userId == null) {
      _isLoading = false;
      scheduleMicrotask(_notify);
      return;
    }

    _isLoading = true;
    _subscription = _repository.watchAll(userId).listen(
      (List<Pet> pets) {
        _pets = pets;
        _isLoading = false;
        _loadError = null;
        _notify();
      },
      onError: (Object error) {
        _isLoading = false;
        _loadError = error is PetFailure
            ? error.message
            : 'Não foi possível carregar seus pets.';
        _notify();
      },
    );
    // Adiado: _subscribe pode rodar durante o build (ProxyProvider).
    scheduleMicrotask(_notify);
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<bool> addPet({
    required String name,
    required PetSpecies species,
    required PetSex sex,
    required String breed,
    required DateTime birthDate,
    required double weightKg,
    required VaccinationStatus vaccinationStatus,
    String notes = '',
  }) {
    return _execute((String userId) {
      final Pet pet = Pet(
        id: _uuid.v4(),
        name: name.trim(),
        species: species,
        sex: sex,
        breed: breed.trim(),
        birthDate: birthDate,
        weightKg: weightKg,
        vaccinationStatus: vaccinationStatus,
        notes: notes.trim(),
      );
      return _repository.add(userId, pet);
    });
  }

  Future<bool> updatePet({
    required String id,
    required String name,
    required PetSpecies species,
    required PetSex sex,
    required String breed,
    required DateTime birthDate,
    required double weightKg,
    required VaccinationStatus vaccinationStatus,
    String notes = '',
  }) {
    return _execute((String userId) {
      final Pet pet = Pet(
        id: id,
        name: name.trim(),
        species: species,
        sex: sex,
        breed: breed.trim(),
        birthDate: birthDate,
        weightKg: weightKg,
        vaccinationStatus: vaccinationStatus,
        notes: notes.trim(),
      );
      return _repository.update(userId, pet);
    });
  }

  Future<bool> deletePet(String id) {
    return _execute((String userId) => _repository.delete(userId, id));
  }

  /// Tratamento único de erro para todas as ações de escrita.
  Future<bool> _execute(Future<void> Function(String userId) action) async {
    _errorMessage = null;
    final String? userId = _userId;
    if (userId == null) {
      _errorMessage = 'Sua sessão expirou. Entre novamente.';
      return false;
    }
    try {
      await action(userId);
      return true;
    } on PetFailure catch (failure) {
      _errorMessage = failure.message;
      return false;
    } on ArgumentError catch (error) {
      _errorMessage = error.message.toString();
      return false;
    } catch (_) {
      _errorMessage = 'Não foi possível concluir a operação. Tente novamente.';
      return false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    super.dispose();
  }
}
