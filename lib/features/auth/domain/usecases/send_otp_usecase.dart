import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case: Send OTP to the given phone number
class SendOtpUseCase {
  final AuthRepository _repository;

  const SendOtpUseCase(this._repository);

  Future<AuthEntity> call(String phoneNumber) {
    return _repository.sendOtp(phoneNumber);
  }
}
