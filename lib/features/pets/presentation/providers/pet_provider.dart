import 'package:flutter/foundation.dart';
import 'package:pata/features/pets/domain/entities/pet.dart';
import 'package:pata/features/pets/domain/entities/pet_sex.dart';
import 'package:pata/features/pets/domain/entities/pet_species.dart';
import 'package:pata/features/pets/domain/entities/vaccination_status.dart';
import 'package:pata/features/pets/domain/repositories/pet_repository.dart';
import 'package:uuid/uuid.dart';

/// Estado e regras de apresentação da feature "pets".
///
/// Esta classe é a única responsável por conversar com o [PetRepository]
/// (camada de domínio/data) e expor um estado pronto para a UI consumir.
/// Nenhum widget deve acessar o repositório diretamente — isso mantém a
/// lógica de negócio fora da camada de apresentação, conforme exigido.
class PetProvider extends ChangeNotifier {
  PetProvider(this._repository);

  final PetRepository _repository;
  final Uuid _uuid = const Uuid();

  List<Pet> _pets = <Pet>[];
  bool _isLoading = false;
  String? _errorMessage;

  List<Pet> get pets => List<Pet>.unmodifiable(_pets);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Carrega (ou recarrega) a lista de pets a partir do repositório.
  Future<void> loadPets() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _pets = await _repository.getAll();
    } catch (_) {
      _errorMessage = 'Não foi possível carregar a lista de pets.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Pet?> getPetById(String id) async {
    try {
      return await _repository.getById(id);
    } catch (_) {
      _errorMessage = 'Não foi possível carregar os dados do pet.';
      notifyListeners();
      return null;
    }
  }

  /// Cria e persiste um novo pet. Retorna `true` em caso de sucesso.
  ///
  /// As validações de negócio (nome obrigatório, peso positivo, etc.)
  /// acontecem dentro do construtor de [Pet] — aqui apenas capturamos
  /// o eventual [ArgumentError] e convertemos em mensagem para a UI.
  Future<bool> addPet({
    required String name,
    required PetSpecies species,
    required PetSex sex,
    required String breed,
    required DateTime birthDate,
    required double weightKg,
    required VaccinationStatus vaccinationStatus,
    String notes = '',
  }) async {
    try {
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
      await _repository.add(pet);
      await loadPets();
      return true;
    } on ArgumentError catch (error) {
      _errorMessage = error.message.toString();
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Não foi possível cadastrar o pet. Tente novamente.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deletePet(String id) async {
    try {
      await _repository.delete(id);
      await loadPets();
      return true;
    } catch (_) {
      _errorMessage = 'Não foi possível excluir o pet.';
      notifyListeners();
      return false;
    }
  }
}
