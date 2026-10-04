import 'package:pata/features/pets/domain/entities/pet.dart';

/// Contrato de acesso a dados da entidade [Pet].
///
/// A camada de apresentação depende apenas desta interface, nunca de
/// uma implementação concreta (Dependency Inversion). Nesta etapa existe
/// uma única implementação em memória ([InMemoryPetRepository]); no
/// Trabalho 3, uma implementação baseada em Cloud Firestore poderá
/// substituí-la sem que nenhuma tela precise ser alterada.
abstract interface class PetRepository {
  Future<List<Pet>> getAll();
  Future<Pet?> getById(String id);
  Future<void> add(Pet pet);
  Future<void> update(Pet pet);
  Future<void> delete(String id);
}
