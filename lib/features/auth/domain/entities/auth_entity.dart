import 'package:equatable/equatable.dart';

/// Core auth domain entity
class AuthEntity extends Equatable {
  final String phoneNumber;
  final String reqId;
  final bool isVerified;

  const AuthEntity({
    required this.phoneNumber,
    required this.reqId,
    this.isVerified = false,
  });

  AuthEntity copyWith({
    String? phoneNumber,
    String? reqId,
    bool? isVerified,
  }) {
    return AuthEntity(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      reqId: reqId ?? this.reqId,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  List<Object?> get props => [phoneNumber, reqId, isVerified];
}
