import 'package:pata/features/pets/domain/entities/pet.dart';
import 'package:pata/features/pets/domain/entities/pet_sex.dart';
import 'package:pata/features/pets/domain/entities/pet_species.dart';
import 'package:pata/features/pets/domain/entities/vaccination_status.dart';
import 'package:pata/features/pets/domain/repositories/pet_repository.dart';
import 'package:uuid/uuid.dart';

/// Implementação concreta de [PetRepository] que guarda os dados apenas
/// em memória (lista local), conforme permitido pelo Trabalho 1.
///
/// TODO(T3 - Cloud Firestore): substituir/complementar esta implementação
/// por uma que persista os dados no Cloud Firestore, vinculados ao usuário
/// autenticado (introduzido no Trabalho 2 com Firebase Authentication).
class InMemoryPetRepository implements PetRepository {
  InMemoryPetRepository() {
    _pets.addAll(_seedData());
  }

  final List<Pet> _pets = <Pet>[];
  final Uuid _uuid = const Uuid();

  @override
  Future<List<Pet>> getAll() async {
    // Retorna uma cópia para impedir que quem consome a lista altere
    // o estado interno do repositório diretamente.
    return List<Pet>.unmodifiable(_pets);
  }

  @override
  Future<Pet?> getById(String id) async {
    for (final Pet pet in _pets) {
      if (pet.id == id) {
        return pet;
      }
    }
    return null;
  }

  @override
  Future<void> add(Pet pet) async {
    _pets.add(pet);
  }

  @override
  Future<void> update(Pet pet) async {
    final int index = _pets.indexWhere((Pet p) => p.id == pet.id);
    if (index == -1) {
      throw StateError('Pet com id "${pet.id}" não encontrado.');
    }
    _pets[index] = pet;
  }

  @override
  Future<void> delete(String id) async {
    _pets.removeWhere((Pet pet) => pet.id == id);
  }

  List<Pet> _seedData() {
    return <Pet>[
      Pet(
        id: _uuid.v4(),
        name: 'Thor',
        species: PetSpecies.dog,
        sex: PetSex.male,
        breed: 'Vira-lata caramelo',
        birthDate: DateTime(2021, 3, 12),
        weightKg: 18.5,
        vaccinationStatus: VaccinationStatus.upToDate,
        notes: 'Vacinação em dia. Gosta de correr no quintal.',
      ),
      Pet(
        id: _uuid.v4(),
        name: 'Luna',
        species: PetSpecies.cat,
        sex: PetSex.female,
        breed: 'Siamês',
        birthDate: DateTime(2022, 7, 30),
        weightKg: 4.2,
        vaccinationStatus: VaccinationStatus.upToDate,
        notes: 'Alimentação controlada — ração indicada pelo veterinário.',
      ),
      Pet(
        id: _uuid.v4(),
        name: 'Bidu',
        species: PetSpecies.dog,
        sex: PetSex.male,
        breed: 'Poodle',
        birthDate: DateTime(2024, 5, 20),
        weightKg: 3.8,
        vaccinationStatus: VaccinationStatus.partiallyStarted,
        notes: 'Filhote, ainda no esquema de vacinação.',
      ),
      Pet(
        id: _uuid.v4(),
        name: 'Mia',
        species: PetSpecies.cat,
        sex: PetSex.female,
        breed: 'Vira-lata',
        birthDate: DateTime(2023, 11, 2),
        weightKg: 3.5,
        vaccinationStatus: VaccinationStatus.notStarted,
        notes: '',
      ),
    ];
  }
}
