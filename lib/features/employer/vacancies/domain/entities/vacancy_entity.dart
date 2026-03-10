import 'package:equatable/equatable.dart';

class VacancyEntity extends Equatable {
  final String id;
  final String role;
  final String company;
  final String location;
  final String appliedCount;
  final String newCount;
  final String status;
  const VacancyEntity({
    required this.id,
    required this.role,
    required this.company,
    required this.location,
    required this.appliedCount,
    required this.newCount,
    required this.status,
  });
  @override
  List<Object?> get props => [
    id,
    role,
    company,
    location,
    appliedCount,
    newCount,
    status,
  ];
}
