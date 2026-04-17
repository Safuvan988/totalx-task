import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched when user taps "Get OTP"
class SendOtpEvent extends AuthEvent {
  final String phoneNumber;

  const SendOtpEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

/// Dispatched when user taps "Verify"
class VerifyOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String otp;
  final String reqId;

  const VerifyOtpEvent({
    required this.phoneNumber,
    required this.otp,
    required this.reqId,
  });

  @override
  List<Object?> get props => [phoneNumber, otp, reqId];
}

/// Dispatched when user taps "Resend"
class ResendOtpEvent extends AuthEvent {
  final String phoneNumber;

  const ResendOtpEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}
