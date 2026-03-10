import 'package:equatable/equatable.dart';

abstract class EmployerHomeEvent extends Equatable {
  const EmployerHomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadEmployerDashboard extends EmployerHomeEvent {}
