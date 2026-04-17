import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/auth_entity.dart';

/// Remote datasource that wraps MSG91 OTP API.
/// When [AppConstants.useMockOtp] is true, simulates the API for development.
abstract class AuthRemoteDataSource {
  Future<AuthEntity> sendOtp(String phoneNumber);
  Future<AuthEntity> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String reqId,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl();

  @override
  Future<AuthEntity> sendOtp(String phoneNumber) async {
    if (AppConstants.useMockOtp) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      return AuthEntity(
        phoneNumber: phoneNumber,
        reqId: 'mock_req_${DateTime.now().millisecondsSinceEpoch}',
      );
    }

    // Real MSG91 implementation:
    // final response = await OTPWidget.sendOTP({'identifier': '91$phoneNumber'});
    // return AuthEntity(phoneNumber: phoneNumber, reqId: response['reqId']);
    throw UnimplementedError('Set useMockOtp=false and configure real MSG91 credentials');
  }

  @override
  Future<AuthEntity> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String reqId,
  }) async {
    if (AppConstants.useMockOtp) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (otp == AppConstants.mockOtp) {
        return AuthEntity(
          phoneNumber: phoneNumber,
          reqId: reqId,
          isVerified: true,
        );
      }
      throw Exception('Invalid OTP. Use ${AppConstants.mockOtp} for testing.');
    }

    // Real MSG91 implementation:
    // final response = await OTPWidget.verifyOTP({'reqId': reqId, 'otp': otp});
    // if (response['type'] == 'success') { ... }
    throw UnimplementedError('Set useMockOtp=false and configure real MSG91 credentials');
  }
}
