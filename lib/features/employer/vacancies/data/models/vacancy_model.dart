import 'package:speed_staff_mobile/features/employer/vacancies/domain/entities/vacancy_entity.dart';

class VacancyModel extends VacancyEntity {
  const VacancyModel({
    required super.id,
    required super.role,
    required super.company,
    required super.location,
    required super.appliedCount,
    required super.newCount,
    required super.status,
  });
  factory VacancyModel.fromJson(Map<String, dynamic> json) {
    return VacancyModel(
      id: json['id'] as String,
      role: json['role'] as String,
      company: json['company'] as String,
      location: json['location'] as String,
      appliedCount: json['applied_count'] as String,
      newCount: json['new_count'] as String,
      status: json['status'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'company': company,
      'location': location,
      'applied_count': appliedCount,
      'new_count': newCount,
      'status': status,
    };
  }
}
