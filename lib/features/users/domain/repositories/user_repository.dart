import '../entities/user_entity.dart';

/// Abstract contract for user data operations
abstract class UserRepository {
  /// Fetches a paginated page of users.
  /// [offset] is the starting index, [limit] is the page size.
  Future<List<UserEntity>> getUsers({
    required int offset,
    required int limit,
  });

  /// Adds a new user to the store.
  Future<void> addUser(UserEntity user);

  /// Searches users by [query] (matches name or phone).
  Future<List<UserEntity>> searchUsers(String query);

  /// Returns all users matching the [filter].
  Future<List<UserEntity>> getUsersByFilter(SortFilter filter);

  /// Returns the total count of all stored users.
  Future<int> getUserCount();
}
