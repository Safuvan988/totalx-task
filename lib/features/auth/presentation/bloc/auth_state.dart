import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state while waiting for API response
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// OTP has been sent successfully
class OtpSent extends AuthState {
  final AuthEntity authEntity;

  const OtpSent(this.authEntity);

  @override
  List<Object?> get props => [authEntity];
}

/// OTP verified, user is authenticated
class AuthSuccess extends AuthState {
  final AuthEntity authEntity;

  const AuthSuccess(this.authEntity);

  @override
  List<Object?> get props => [authEntity];
}

/// An error occurred
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
