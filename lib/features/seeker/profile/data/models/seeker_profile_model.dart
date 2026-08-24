import 'package:speed_staff_mobile/features/seeker/profile/domain/entities/seeker_profile.dart';

// ─── SeekerProfileModel ───────────────────────────────────────────────────────
class SeekerProfileModel extends SeekerProfile {
  const SeekerProfileModel({
    super.id,
    super.userId,
    super.firstName,
    super.lastName,
    super.middleName,
    super.avatarUrl,
    super.birthDate,
    super.gender,
    super.experienceYears,
    super.city,
    super.district,
    super.expectedSalaryMin,
    super.expectedSalaryMax,
    super.bio,
    super.isAvailable,
    super.resumeUrl,
    super.rating,
    super.totalReviews,
    super.createdAt,
    super.updatedAt,
    super.skills,
    super.experiences,
    super.documents,
  });

  factory SeekerProfileModel.fromJson(Map<String, dynamic> json) {
    // Parse skills: [ { "skill": {...}, "level": "advanced" } ]
    final List<SeekerSkillEntry> parsedSkills = [];
    if (json['skills'] is List) {
      for (final item in json['skills'] as List) {
        if (item is Map<String, dynamic>) {
          final skill = item['skill'] is Map ? item['skill'] as Map<String, dynamic> : item;
          final level = item['level']?.toString() ?? 'beginner';
          parsedSkills.add(SeekerSkillEntryModel.fromJson(skill, level: level));
        }
      }
    }

    // Parse experiences
    final List<SeekerExperienceModel> parsedExperiences = [];
    if (json['experiences'] is List) {
      for (final e in json['experiences'] as List) {
        if (e is Map<String, dynamic>) {
          parsedExperiences.add(SeekerExperienceModel.fromJson(e));
        }
      }
    }

    // Parse documents
    final List<SeekerDocumentModel> parsedDocuments = [];
    if (json['documents'] is List) {
      for (final d in json['documents'] as List) {
        if (d is Map<String, dynamic>) {
          parsedDocuments.add(SeekerDocumentModel.fromJson(d));
        }
      }
    }

    return SeekerProfileModel(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString(),
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      middleName: json['middle_name']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
      birthDate: json['birth_date']?.toString(),
      gender: json['gender']?.toString(),
      experienceYears: (json['experience_years'] as num?)?.toInt() ?? 0,
      city: json['city']?.toString(),
      district: json['district']?.toString(),
      expectedSalaryMin: (json['expected_salary_min'] as num?)?.toInt(),
      expectedSalaryMax: (json['expected_salary_max'] as num?)?.toInt(),
      bio: json['bio']?.toString(),
      isAvailable: json['is_available'] as bool? ?? true,
      resumeUrl: json['resume_url']?.toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      skills: parsedSkills,
      experiences: parsedExperiences,
      documents: parsedDocuments,
    );
  }
}

// ─── SeekerSkillEntryModel ────────────────────────────────────────────────────
class SeekerSkillEntryModel extends SeekerSkillEntry {
  const SeekerSkillEntryModel({
    required super.skillId,
    super.nameUz,
    super.nameRu,
    super.nameEn,
    super.category,
    super.level,
  });

  factory SeekerSkillEntryModel.fromJson(Map<String, dynamic> json, {String level = 'beginner'}) {
    return SeekerSkillEntryModel(
      skillId: (json['id'] as num?)?.toInt() ?? 0,
      nameUz: json['name_uz']?.toString() ?? '',
      nameRu: json['name_ru']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      level: level,
    );
  }
}

// ─── SeekerExperienceModel ────────────────────────────────────────────────────
class SeekerExperienceModel extends SeekerExperience {
  const SeekerExperienceModel({
    required super.id,
    required super.companyName,
    required super.position,
    required super.startDate,
    super.endDate,
    super.description,
  });

  factory SeekerExperienceModel.fromJson(Map<String, dynamic> json) {
    return SeekerExperienceModel(
      id: json['id']?.toString() ?? '',
      companyName: json['company_name']?.toString() ?? '',
      position: json['position']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString(),
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'company_name': companyName,
    'position': position,
    'start_date': startDate,
    'end_date': endDate,
    'description': description,
  };
}

// ─── SeekerDocumentModel ──────────────────────────────────────────────────────
class SeekerDocumentModel extends SeekerDocument {
  const SeekerDocumentModel({
    required super.id,
    required super.title,
    required super.docType,
    super.fileUrl,
    super.isVerified,
    super.createdAt,
  });

  factory SeekerDocumentModel.fromJson(Map<String, dynamic> json) {
    return SeekerDocumentModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Hujjat',
      docType: json['doc_type']?.toString() ?? 'other',
      fileUrl: json['file_url']?.toString(),
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }
}

// ─── SkillModel (for GET /api/seeker/skills/all) ──────────────────────────────
class SkillModel {
  final int id;
  final String nameUz;
  final String nameRu;
  final String nameEn;
  final String category;

  const SkillModel({
    required this.id,
    this.nameUz = '',
    this.nameRu = '',
    this.nameEn = '',
    this.category = '',
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nameUz: json['name_uz']?.toString() ?? '',
      nameRu: json['name_ru']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
    );
  }

  String get displayName => nameUz.isNotEmpty ? nameUz : (nameRu.isNotEmpty ? nameRu : nameEn);
}
