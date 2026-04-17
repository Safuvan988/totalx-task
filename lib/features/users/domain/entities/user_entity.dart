import 'package:equatable/equatable.dart';

/// Core user domain entity
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String phone;
  final int age;
  final String? imagePath;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.age,
    this.imagePath,
    required this.createdAt,
  });

  /// Whether the user is categorized as "Elder" (age >= 60)
  bool get isElder => age >= 60;

  UserEntity copyWith({
    String? id,
    String? name,
    String? phone,
    int? age,
    String? imagePath,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, phone, age, imagePath, createdAt];
}

/// Sort filter for the user list
enum SortFilter { all, elder, younger }
