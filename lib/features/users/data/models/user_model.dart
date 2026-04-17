import 'package:hive/hive.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final int age;

  @HiveField(4)
  final String? imagePath;

  @HiveField(5)
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.age,
    this.imagePath,
    required this.createdAt,
  });

  /// Convert domain entity → Hive model
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      age: entity.age,
      imagePath: entity.imagePath,
      createdAt: entity.createdAt,
    );
  }

  /// Convert Hive model → domain entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      phone: phone,
      age: age,
      imagePath: imagePath,
      createdAt: createdAt,
    );
  }
}
