import 'package:equatable/equatable.dart';

class EmployerProfileEntity extends Equatable {
  final String name;
  final String location;
  final String rating;
  final String vacanciesCount;
  final String about;

  const EmployerProfileEntity({
    required this.name,
    required this.location,
    required this.rating,
    required this.vacanciesCount,
    required this.about,
  });

  @override
  List<Object?> get props => [name, location, rating, vacanciesCount, about];
}
