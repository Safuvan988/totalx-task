import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Use case: Get a paginated list of users (supports lazy loading)
class GetUsersUseCase {
  final UserRepository _repository;

  const GetUsersUseCase(this._repository);

  Future<List<UserEntity>> call({required int offset, required int limit}) {
    return _repository.getUsers(offset: offset, limit: limit);
  }
}
