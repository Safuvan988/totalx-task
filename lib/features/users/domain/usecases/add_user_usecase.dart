import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Use case: Add a new user to the local store
class AddUserUseCase {
  final UserRepository _repository;

  const AddUserUseCase(this._repository);

  Future<void> call(UserEntity user) {
    return _repository.addUser(user);
  }
}
