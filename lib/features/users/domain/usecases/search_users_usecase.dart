import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Use case: Search users by name or phone number
class SearchUsersUseCase {
  final UserRepository _repository;

  const SearchUsersUseCase(this._repository);

  Future<List<UserEntity>> call(String query) {
    return _repository.searchUsers(query);
  }
}
