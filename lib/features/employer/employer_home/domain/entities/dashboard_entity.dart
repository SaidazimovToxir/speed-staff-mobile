import 'package:equatable/equatable.dart';

class EmployerStatsEntity extends Equatable {
  final String activeVacancies;
  final String totalApplications;
  final String newToday;
  const EmployerStatsEntity({
    required this.activeVacancies,
    required this.totalApplications,
    required this.newToday,
  });
  @override
  List<Object?> get props => [activeVacancies, totalApplications, newToday];
}
