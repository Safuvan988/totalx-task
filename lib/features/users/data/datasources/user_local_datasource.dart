import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

const _usersBoxName = 'users';

/// Local data source backed by Hive
abstract class UserLocalDataSource {
  Future<List<UserModel>> getUsers({required int offset, required int limit});
  Future<void> addUser(UserModel model);
  Future<List<UserModel>> searchUsers(String query);
  Future<List<UserModel>> getUsersByFilter(SortFilter filter);
  Future<int> getUserCount();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box<UserModel> _box;

  UserLocalDataSourceImpl(this._box);

  static Future<Box<UserModel>> openBox() async {
    return Hive.openBox<UserModel>(_usersBoxName);
  }

  @override
  Future<List<UserModel>> getUsers({
    required int offset,
    required int limit,
  }) async {
    final all = _box.values.toList();
    // Sort by createdAt descending (newest first)
    all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final end = (offset + limit).clamp(0, all.length);
    if (offset >= all.length) return [];
    return all.sublist(offset, end);
  }

  @override
  Future<void> addUser(UserModel model) async {
    await _box.put(model.id, model);
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    if (query.trim().isEmpty) return _box.values.toList();
    final q = query.toLowerCase().trim();
    return _box.values
        .where(
          (u) =>
              u.name.toLowerCase().contains(q) ||
              u.phone.contains(q),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<List<UserModel>> getUsersByFilter(SortFilter filter) async {
    final all = _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    switch (filter) {
      case SortFilter.elder:
        return all.where((u) => u.age >= 60).toList();
      case SortFilter.younger:
        return all.where((u) => u.age < 60).toList();
      case SortFilter.all:
        return all;
    }
  }

  @override
  Future<int> getUserCount() async => _box.length;
}
