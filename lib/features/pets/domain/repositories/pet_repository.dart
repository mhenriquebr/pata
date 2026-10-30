import 'package:pata/features/pets/domain/entities/pet.dart';

/// Contrato de acesso aos pets de UM usuário.
///
/// O [userId] (UID da sessão autenticada) é sempre informado por quem
/// chama — nunca digitado em tela. [watchAll] é um Stream: a lista se
/// atualiza sozinha após cadastrar, editar ou excluir.
abstract interface class PetRepository {
  Stream<List<Pet>> watchAll(String userId);
  Future<void> add(String userId, Pet pet);
  Future<void> update(String userId, Pet pet);
  Future<void> delete(String userId, String petId);
}
