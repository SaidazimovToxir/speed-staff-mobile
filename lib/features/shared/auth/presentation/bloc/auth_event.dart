import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class SendOtpEvent extends AuthEvent {
  final String telephoneNumber;

  const SendOtpEvent(this.telephoneNumber);

  @override
  List<Object?> get props => [telephoneNumber];
}

class VerifyOtpEvent extends AuthEvent {
  final String telephoneNumber;
  final String confirmCode;

  const VerifyOtpEvent({required this.telephoneNumber, required this.confirmCode});

  @override
  List<Object?> get props => [telephoneNumber, confirmCode];
}

class FinalizeRegistrationEvent extends AuthEvent {
  final String phone;
  final String code;
  final String password;
  final String role;
  final String? firstName;
  final String? lastName;
  final String? restaurantName;

  const FinalizeRegistrationEvent({
    required this.phone,
    required this.code,
    required this.password,
    required this.role,
    this.firstName,
    this.lastName,
    this.restaurantName,
  });

  @override
  List<Object?> get props => [phone, code, password, role, firstName, lastName, restaurantName];
}

class LogoutEvent extends AuthEvent {}
