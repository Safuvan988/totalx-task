import '../entities/auth_entity.dart';

/// Abstract contract for the auth repository
abstract class AuthRepository {
  /// Sends OTP to [phoneNumber] via MSG91.
  /// Returns [AuthEntity] with the reqId on success.
  Future<AuthEntity> sendOtp(String phoneNumber);

  /// Verifies the [otp] entered by the user.
  /// Returns the verified [AuthEntity] on success.
  Future<AuthEntity> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String reqId,
  });
}
