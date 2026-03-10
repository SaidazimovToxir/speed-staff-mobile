import 'package:equatable/equatable.dart';

class ExperienceEntity extends Equatable {
  final String company;
  final String role;
  final String period;
  final String description;
  final bool isPresent;
  const ExperienceEntity({
    required this.company,
    required this.role,
    required this.period,
    required this.description,
    this.isPresent = false,
  });
  @override
  List<Object?> get props => [company, role, period, description, isPresent];
}

class DocumentEntity extends Equatable {
  final String name;
  final String info;
  const DocumentEntity({required this.name, required this.info});
  @override
  List<Object?> get props => [name, info];
}

class CandidateEntity extends Equatable {
  final String id;
  final String name;
  final String? role;
  final String rating;
  final String? reviewCount;
  final List<String>? skills;
  final List<ExperienceEntity>? experiences;
  final List<DocumentEntity>? documents;
  const CandidateEntity({
    required this.id,
    required this.name,
    this.role,
    required this.rating,
    this.reviewCount,
    this.skills,
    this.experiences,
    this.documents,
  });
  @override
  List<Object?> get props => [
    id,
    name,
    role,
    rating,
    reviewCount,
    skills,
    experiences,
    documents,
  ];
}

class ApplicationEntity extends Equatable {
  final String id;
  final String candidateName;
  final String role;
  final String status;
  final String time;
  final String rating;
  const ApplicationEntity({
    required this.id,
    required this.candidateName,
    required this.role,
    required this.status,
    required this.time,
    required this.rating,
  });
  @override
  List<Object?> get props => [id, candidateName, role, status, time, rating];
}
