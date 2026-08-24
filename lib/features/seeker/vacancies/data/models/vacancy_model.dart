import 'package:speed_staff_mobile/features/seeker/vacancies/domain/entities/vacancy.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/domain/entities/paginated_vacancies.dart';

class EmployerShortModel extends EmployerShort {
  const EmployerShortModel({
    required super.id,
    required super.restaurantName,
    super.logoUrl,
    super.city,
    super.rating,
    super.isVerified,
    super.totalReviews,
  });

  factory EmployerShortModel.fromJson(Map<String, dynamic> json) {
    return EmployerShortModel(
      id: json['id']?.toString() ?? '',
      restaurantName: json['restaurant_name']?.toString() ?? '',
      logoUrl: json['logo_url']?.toString(),
      city: json['city']?.toString(),
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      isVerified: json['is_verified'] as bool?,
      totalReviews: json['total_reviews'] as int?,
    );
  }
}

class VacancySkillModel extends VacancySkill {
  const VacancySkillModel({
    required super.skillId,
    required super.nameUz,
    required super.nameRu,
    super.nameEn,
    super.category,
    super.isRequired,
  });

  factory VacancySkillModel.fromJson(Map<String, dynamic> json) {
    // Handle nested: {"skill": {...}, "is_required": true}
    final skillData = json['skill'] as Map<String, dynamic>? ?? json;
    return VacancySkillModel(
      skillId: skillData['id'] is int
          ? skillData['id'] as int
          : int.tryParse(skillData['id']?.toString() ?? '') ?? 0,
      nameUz: skillData['name_uz']?.toString() ?? '',
      nameRu: skillData['name_ru']?.toString() ?? '',
      nameEn: skillData['name_en']?.toString(),
      category: skillData['category']?.toString(),
      isRequired: json['is_required'] as bool? ?? false,
    );
  }
}

class VacancyModel extends Vacancy {
  const VacancyModel({
    required super.id,
    super.employerId,
    required super.title,
    super.position,
    super.description,
    super.requirements,
    super.salaryMin,
    super.salaryMax,
    super.salaryType,
    super.workType,
    super.schedule,
    super.status,
    super.isPremium,
    super.viewsCount,
    super.applicationsCount,
    super.experienceMin,
    super.experienceMax,
    super.createdAt,
    super.expiresAt,
    super.employer,
    super.skills,
  });

  factory VacancyModel.fromJson(Map<String, dynamic> json) {
    final employerJson = json['employer'] as Map<String, dynamic>?;
    final skillsList = json['skills'] as List<dynamic>? ?? [];
    return VacancyModel(
      id: json['id']?.toString() ?? '',
      employerId: json['employer_id']?.toString(),
      title: json['title']?.toString() ?? '',
      position: json['position']?.toString(),
      description: json['description']?.toString(),
      requirements: json['requirements']?.toString(),
      salaryMin: json['salary_min'] != null ? (json['salary_min'] as num).toInt() : null,
      salaryMax: json['salary_max'] != null ? (json['salary_max'] as num).toInt() : null,
      salaryType: json['salary_type']?.toString(),
      workType: json['work_type']?.toString(),
      schedule: json['schedule']?.toString(),
      status: json['status']?.toString(),
      isPremium: json['is_premium'] as bool?,
      viewsCount: json['views_count'] as int?,
      applicationsCount: json['applications_count'] as int?,
      experienceMin: json['experience_min'] as int?,
      experienceMax: json['experience_max'] as int?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      expiresAt: json['expires_at'] != null ? DateTime.tryParse(json['expires_at']) : null,
      employer: employerJson != null ? EmployerShortModel.fromJson(employerJson) : null,
      skills: skillsList.map((e) => VacancySkillModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class PaginatedVacanciesModel extends PaginatedVacancies {
  const PaginatedVacanciesModel({
    required super.items,
    required super.page,
    required super.limit,
    required super.total,
    required super.pages,
    required super.hasNext,
    required super.hasPrev,
  });

  factory PaginatedVacanciesModel.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>? ?? [])
        .map((e) => VacancyModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    return PaginatedVacanciesModel(
      items: items,
      page: meta['page'] as int? ?? 1,
      limit: meta['limit'] as int? ?? 20,
      total: meta['total'] as int? ?? 0,
      pages: meta['pages'] as int? ?? 1,
      hasNext: meta['has_next'] as bool? ?? false,
      hasPrev: meta['has_prev'] as bool? ?? false,
    );
  }
}
