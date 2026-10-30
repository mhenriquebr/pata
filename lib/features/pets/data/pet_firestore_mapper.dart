import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pata/features/pets/domain/entities/pet.dart';
import 'package:pata/features/pets/domain/entities/pet_sex.dart';
import 'package:pata/features/pets/domain/entities/pet_species.dart';
import 'package:pata/features/pets/domain/entities/vaccination_status.dart';

/// Converte [Pet] <-> documento do Firestore.
///
/// Fica na camada `data`: a entidade de domínio não conhece Firestore.
/// O `id` do pet é o próprio id do documento (não é gravado como campo).
abstract final class PetFirestoreMapper {
  static Map<String, dynamic> toMap(Pet pet) {
    return <String, dynamic>{
      'name': pet.name,
      'species': pet.species.name,
      'sex': pet.sex.name,
      'breed': pet.breed,
      'birthDate': Timestamp.fromDate(pet.birthDate),
      'weightKg': pet.weightKg,
      'vaccinationStatus': pet.vaccinationStatus.name,
      'notes': pet.notes,
    };
  }

  static Pet fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic>? data = doc.data();
    if (data == null) {
      throw const FormatException('Documento sem dados.');
    }
    return Pet(
      id: doc.id,
      name: data['name'] as String,
      species: PetSpecies.values.byName(data['species'] as String),
      sex: PetSex.values.byName(data['sex'] as String),
      breed: data['breed'] as String,
      birthDate: (data['birthDate'] as Timestamp).toDate(),
      weightKg: (data['weightKg'] as num).toDouble(),
      vaccinationStatus:
          VaccinationStatus.values.byName(data['vaccinationStatus'] as String),
      notes: (data['notes'] as String?) ?? '',
    );
  }
}
