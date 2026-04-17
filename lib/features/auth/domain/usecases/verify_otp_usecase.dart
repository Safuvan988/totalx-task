import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case: Verify OTP entered by the user
class VerifyOtpUseCase {
  final AuthRepository _repository;

  const VerifyOtpUseCase(this._repository);

  Future<AuthEntity> call({
    required String phoneNumber,
    required String otp,
    required String reqId,
  }) {
    return _repository.verifyOtp(
      phoneNumber: phoneNumber,
      otp: otp,
      reqId: reqId,
    );
  }
}
