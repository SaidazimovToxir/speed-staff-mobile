import 'package:speed_staff_mobile/features/employer/profile/domain/entities/employer_profile_entity.dart';

class EmployerProfileModel extends EmployerProfileEntity {
  const EmployerProfileModel({
    required super.name,
    required super.location,
    required super.rating,
    required super.vacanciesCount,
    required super.about,
  });

  factory EmployerProfileModel.fromJson(Map<String, dynamic> json) {
    return EmployerProfileModel(
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      rating: json['rating'] as String? ?? '0',
      vacanciesCount: json['vacanciesCount'] as String? ?? '0',
      about: json['about'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'rating': rating,
      'vacanciesCount': vacanciesCount,
      'about': about,
    };
  }
}
