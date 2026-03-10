import 'package:equatable/equatable.dart';

abstract class EmployerProfileEvent extends Equatable {
  const EmployerProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadEmployerProfile extends EmployerProfileEvent {}

class UpdateEmployerProfile extends EmployerProfileEvent {
  final Map<String, dynamic> data;
  const UpdateEmployerProfile(this.data);

  @override
  List<Object?> get props => [data];
}
