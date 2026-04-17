import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Concrete implementation of [AuthRepository]
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<AuthEntity> sendOtp(String phoneNumber) async {
    try {
      return await _remoteDataSource.sendOtp(phoneNumber);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthEntity> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String reqId,
  }) async {
    try {
      return await _remoteDataSource.verifyOtp(
        phoneNumber: phoneNumber,
        otp: otp,
        reqId: reqId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
