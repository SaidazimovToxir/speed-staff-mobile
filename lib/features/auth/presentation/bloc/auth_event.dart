import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String phoneNumber;
  const SendOtpEvent(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyOtpEvent extends AuthEvent {
  final String otpCode;
  const VerifyOtpEvent(this.otpCode);

  @override
  List<Object> get props => [otpCode];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  const SignInEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
