import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pata/features/pets/data/firestore_error_translator.dart';
import 'package:pata/features/pets/data/pet_firestore_mapper.dart';
import 'package:pata/features/pets/domain/entities/pet.dart';
import 'package:pata/features/pets/domain/pet_failure.dart';
import 'package:pata/features/pets/domain/repositories/pet_repository.dart';

/// Implementação de [PetRepository] no Cloud Firestore.
///
/// Estrutura: `users/{uid}/pets/{petId}`. Cada usuário só enxerga a
/// própria subcoleção — e isso é garantido pelas Security Rules
/// (ver `firestore.rules`), não só pela interface. É a única classe do
/// projeto que importa `cloud_firestore`.
class FirestorePetRepository implements PetRepository {
  FirestorePetRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Sem internet, o Firestore deixa a escrita "pendurada" esperando o
  /// servidor. O timeout evita que o formulário fique travado.
  static const Duration _writeTimeout = Duration(seconds: 15);

  CollectionReference<Map<String, dynamic>> _pets(String userId) {
    return _firestore.collection('users').doc(userId).collection('pets');
  }

  @override
  Stream<List<Pet>> watchAll(String userId) {
    return _pets(userId)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      final List<Pet> pets = <Pet>[];
      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snapshot.docs) {
        try {
          pets.add(PetFirestoreMapper.fromDocument(doc));
        } catch (_) {
          // Documento fora do formato esperado: ignora em vez de quebrar
          // a lista inteira.
        }
      }
      pets.sort(
        (Pet a, Pet b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
      return pets;
    }).transform(
      StreamTransformer<List<Pet>, List<Pet>>.fromHandlers(
        handleError: (Object error, StackTrace stack, EventSink<List<Pet>> sink) {
          sink.addError(_toFailure(error));
        },
      ),
    );
  }

  @override
  Future<void> add(String userId, Pet pet) {
    return _run(
      () => _pets(userId).doc(pet.id).set(<String, dynamic>{
        ...PetFirestoreMapper.toMap(pet),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }),
    );
  }

  @override
  Future<void> update(String userId, Pet pet) {
    return _run(
      () => _pets(userId).doc(pet.id).update(<String, dynamic>{
        ...PetFirestoreMapper.toMap(pet),
        'updatedAt': FieldValue.serverTimestamp(),
      }),
    );
  }

  @override
  Future<void> delete(String userId, String petId) {
    return _run(() => _pets(userId).doc(petId).delete());
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action().timeout(_writeTimeout);
    } on TimeoutException {
      throw const PetFailure(
        'A operação demorou demais. Verifique sua conexão e tente novamente.',
      );
    } on FirebaseException catch (e) {
      throw PetFailure(translateFirestoreError(e.code));
    }
  }

  PetFailure _toFailure(Object error) {
    if (error is FirebaseException) {
      return PetFailure(translateFirestoreError(error.code));
    }
    return const PetFailure('Não foi possível carregar seus pets.');
  }
}
