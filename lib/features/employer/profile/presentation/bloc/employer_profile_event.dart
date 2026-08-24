import 'package:equatable/equatable.dart';

abstract class EmployerProfileEvent extends Equatable {
  const EmployerProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadEmployerProfile extends EmployerProfileEvent {}

class CreateEmployerProfile extends EmployerProfileEvent {
  final Map<String, dynamic> data;
  final String? logoPath;

  const CreateEmployerProfile(this.data, {this.logoPath});

  @override
  List<Object?> get props => [data, logoPath];
}

class UpdateEmployerProfile extends EmployerProfileEvent {
  final Map<String, dynamic> data;
  final String? logoPath;

  const UpdateEmployerProfile(this.data, {this.logoPath});

  @override
  List<Object?> get props => [data, logoPath];
}
