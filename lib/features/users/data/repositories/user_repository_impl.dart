import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';
import '../models/user_model.dart';

/// Concrete implementation of [UserRepository] backed by Hive local storage
class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _localDataSource;

  const UserRepositoryImpl(this._localDataSource);

  @override
  Future<List<UserEntity>> getUsers({
    required int offset,
    required int limit,
  }) async {
    final models = await _localDataSource.getUsers(
      offset: offset,
      limit: limit,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addUser(UserEntity user) async {
    await _localDataSource.addUser(UserModel.fromEntity(user));
  }

  @override
  Future<List<UserEntity>> searchUsers(String query) async {
    final models = await _localDataSource.searchUsers(query);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<UserEntity>> getUsersByFilter(SortFilter filter) async {
    final models = await _localDataSource.getUsersByFilter(filter);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<int> getUserCount() => _localDataSource.getUserCount();
}
