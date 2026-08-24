class EmployerShort {
  final String id;
  final String restaurantName;
  final String? logoUrl;
  final String? city;
  final double? rating;
  final bool? isVerified;
  final int? totalReviews;

  const EmployerShort({
    required this.id,
    required this.restaurantName,
    this.logoUrl,
    this.city,
    this.rating,
    this.isVerified,
    this.totalReviews,
  });
}

class VacancySkill {
  final int skillId;
  final String nameUz;
  final String nameRu;
  final String? nameEn;
  final String? category;
  final bool isRequired;

  const VacancySkill({
    required this.skillId,
    required this.nameUz,
    required this.nameRu,
    this.nameEn,
    this.category,
    this.isRequired = false,
  });
}

class Vacancy {
  final String id;
  final String? employerId;
  final String title;
  final String? position;
  final String? description;
  final String? requirements;
  final int? salaryMin;
  final int? salaryMax;
  final String? salaryType;
  final String? workType;
  final String? schedule;
  final String? status;
  final bool? isPremium;
  final int? viewsCount;
  final int? applicationsCount;
  final int? experienceMin;
  final int? experienceMax;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final EmployerShort? employer;
  final List<VacancySkill> skills;

  const Vacancy({
    required this.id,
    this.employerId,
    required this.title,
    this.position,
    this.description,
    this.requirements,
    this.salaryMin,
    this.salaryMax,
    this.salaryType,
    this.workType,
    this.schedule,
    this.status,
    this.isPremium,
    this.viewsCount,
    this.applicationsCount,
    this.experienceMin,
    this.experienceMax,
    this.createdAt,
    this.expiresAt,
    this.employer,
    this.skills = const [],
  });
}
