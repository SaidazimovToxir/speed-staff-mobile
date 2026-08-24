import 'package:equatable/equatable.dart';

class SeekerProfile extends Equatable {
  final String? id;
  final String? userId;
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? avatarUrl;
  final String? birthDate;
  final String? gender;
  final int experienceYears;
  final String? city;
  final String? district;
  final int? expectedSalaryMin;
  final int? expectedSalaryMax;
  final String? bio;
  final bool isAvailable;
  final String? resumeUrl;
  final double rating;
  final int totalReviews;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<SeekerSkillEntry> skills;
  final List<SeekerExperience> experiences;
  final List<SeekerDocument> documents;

  const SeekerProfile({
    this.id,
    this.userId,
    this.firstName = '',
    this.lastName = '',
    this.middleName,
    this.avatarUrl,
    this.birthDate,
    this.gender,
    this.experienceYears = 0,
    this.city,
    this.district,
    this.expectedSalaryMin,
    this.expectedSalaryMax,
    this.bio,
    this.isAvailable = true,
    this.resumeUrl,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.createdAt,
    this.updatedAt,
    this.skills = const [],
    this.experiences = const [],
    this.documents = const [],
  });

  String get fullName => [firstName, lastName].where((s) => s.isNotEmpty).join(' ');

  @override
  List<Object?> get props => [
    id, userId, firstName, lastName, middleName, avatarUrl, birthDate, gender,
    experienceYears, city, district, expectedSalaryMin, expectedSalaryMax,
    bio, isAvailable, resumeUrl, rating, totalReviews, skills, experiences, documents,
  ];
}

class SeekerSkillEntry extends Equatable {
  final int skillId;
  final String nameUz;
  final String nameRu;
  final String nameEn;
  final String category;
  final String level;

  const SeekerSkillEntry({
    required this.skillId,
    this.nameUz = '',
    this.nameRu = '',
    this.nameEn = '',
    this.category = '',
    this.level = 'beginner',
  });

  @override
  List<Object?> get props => [skillId, nameUz, nameRu, nameEn, category, level];
}

class SeekerExperience extends Equatable {
  final String id;
  final String companyName;
  final String position;
  final String startDate;
  final String? endDate;
  final String? description;

  const SeekerExperience({
    required this.id,
    required this.companyName,
    required this.position,
    required this.startDate,
    this.endDate,
    this.description,
  });

  bool get currentlyWorkHere => endDate == null || endDate!.isEmpty;

  @override
  List<Object?> get props => [id, companyName, position, startDate, endDate, description];
}

class SeekerDocument extends Equatable {
  final String id;
  final String title;
  final String docType;
  final String? fileUrl;
  final bool isVerified;
  final DateTime? createdAt;

  const SeekerDocument({
    required this.id,
    required this.title,
    required this.docType,
    this.fileUrl,
    this.isVerified = false,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, docType, fileUrl, isVerified, createdAt];
}
