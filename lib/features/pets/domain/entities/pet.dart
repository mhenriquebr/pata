import 'package:pata/core/domain/identifiable.dart';
import 'package:pata/features/pets/domain/entities/pet_sex.dart';
import 'package:pata/features/pets/domain/entities/pet_species.dart';
import 'package:pata/features/pets/domain/entities/vaccination_status.dart';

/// Entidade principal do aplicativo: um pet cadastrado por um
/// responsável do órgão "Pata".
///
/// É uma classe imutável (todos os campos `final`); qualquer alteração
/// deve passar por [copyWith]. As regras de validação de negócio (nome
/// obrigatório, peso positivo, data de nascimento não pode ser no
/// futuro) ficam encapsuladas aqui no domínio — nunca na camada de UI.
class Pet implements Identifiable {
  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.sex,
    required this.breed,
    required this.birthDate,
    required this.weightKg,
    required this.vaccinationStatus,
    this.notes = '',
  }) {
    if (name.trim().isEmpty) {
      throw ArgumentError('O nome do pet não pode ser vazio.');
    }
    if (weightKg <= 0) {
      throw ArgumentError('O peso deve ser um valor positivo.');
    }
    if (birthDate.isAfter(DateTime.now())) {
      throw ArgumentError('A data de nascimento não pode estar no futuro.');
    }
  }

  @override
  final String id;
  final String name;
  final PetSpecies species;
  final PetSex sex;
  final String breed;
  final DateTime birthDate;
  final double weightKg;
  final VaccinationStatus vaccinationStatus;
  final String notes;

  int get ageInYears {
    final DateTime now = DateTime.now();
    int years = now.year - birthDate.year;
    final bool birthdayNotReachedThisYear = now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day);
    if (birthdayNotReachedThisYear) {
      years--;
    }
    return years < 0 ? 0 : years;
  }

  Pet copyWith({
    String? name,
    PetSpecies? species,
    PetSex? sex,
    String? breed,
    DateTime? birthDate,
    double? weightKg,
    VaccinationStatus? vaccinationStatus,
    String? notes,
  }) {
    return Pet(
      id: id,
      name: name ?? this.name,
      species: species ?? this.species,
      sex: sex ?? this.sex,
      breed: breed ?? this.breed,
      birthDate: birthDate ?? this.birthDate,
      weightKg: weightKg ?? this.weightKg,
      vaccinationStatus: vaccinationStatus ?? this.vaccinationStatus,
      notes: notes ?? this.notes,
    );
  }
}
