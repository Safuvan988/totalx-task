import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Use case: Filter/sort users by age category
/// - [SortFilter.all]     → all users
/// - [SortFilter.elder]   → users aged 60 or above
/// - [SortFilter.younger] → users aged below 60
class SortUsersUseCase {
  final UserRepository _repository;

  const SortUsersUseCase(this._repository);

  Future<List<UserEntity>> call(SortFilter filter) {
    return _repository.getUsersByFilter(filter);
  }
}
