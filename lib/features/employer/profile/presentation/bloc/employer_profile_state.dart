import 'package:equatable/equatable.dart';

abstract class EmployerProfileState extends Equatable {
  const EmployerProfileState();

  @override
  List<Object?> get props => [];
}

class EmployerProfileInitial extends EmployerProfileState {}

class EmployerProfileLoading extends EmployerProfileState {}

class EmployerProfileLoaded extends EmployerProfileState {
  final Map<String, dynamic> profileData;
  const EmployerProfileLoaded(this.profileData);

  @override
  List<Object?> get props => [profileData];
}

class EmployerProfileUpdated extends EmployerProfileState {}

class EmployerProfileError extends EmployerProfileState {
  final String message;
  const EmployerProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
