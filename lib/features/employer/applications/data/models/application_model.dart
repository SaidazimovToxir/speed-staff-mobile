import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';

class SeekerShortModel extends SeekerShortEntity {
  const SeekerShortModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.avatarUrl,
    super.position,
    required super.rating,
    super.city,
    required super.isAvailable,
  });

  factory SeekerShortModel.fromJson(Map<String, dynamic> json) {
    return SeekerShortModel(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      position: json['position'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      city: json['city'] as String?,
      isAvailable: json['is_available'] as bool? ?? false,
    );
  }
}

class EmployerShortModel extends EmployerShortEntity {
  const EmployerShortModel({
    required super.id,
    required super.restaurantName,
    super.logoUrl,
    super.city,
    required super.rating,
    required super.isVerified,
    required super.totalReviews,
  });

  factory EmployerShortModel.fromJson(Map<String, dynamic> json) {
    return EmployerShortModel(
      id: json['id'] as String,
      restaurantName: json['restaurant_name'] as String,
      logoUrl: json['logo_url'] as String?,
      city: json['city'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isVerified: json['is_verified'] as bool? ?? false,
      totalReviews: json['total_reviews'] as int? ?? 0,
    );
  }
}

class VacancyShortModel extends VacancyShortEntity {
  const VacancyShortModel({
    required super.id,
    required super.title,
    required super.position,
    super.salaryMin,
    super.salaryMax,
    required super.salaryType,
    required super.workType,
    required super.isPremium,
    required super.status,
    required super.employer,
    required super.createdAt,
  });

  factory VacancyShortModel.fromJson(Map<String, dynamic> json) {
    return VacancyShortModel(
      id: json['id'] as String,
      title: json['title'] as String,
      position: json['position'] as String,
      salaryMin: json['salary_min'] as int?,
      salaryMax: json['salary_max'] as int?,
      salaryType: json['salary_type'] as String? ?? 'negotiable',
      workType: json['work_type'] as String? ?? 'fulltime',
      isPremium: json['is_premium'] as bool? ?? false,
      status: json['status'] as String? ?? 'active',
      employer: EmployerShortModel.fromJson(json['employer'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class ApplicationShortModel extends ApplicationShortEntity {
  const ApplicationShortModel({
    required super.id,
    required super.status,
    required super.appliedAt,
    required super.seeker,
  });

  factory ApplicationShortModel.fromJson(Map<String, dynamic> json) {
    return ApplicationShortModel(
      id: json['id'] as String,
      status: json['status'] as String,
      appliedAt: DateTime.parse(json['applied_at'] as String),
      seeker: SeekerShortModel.fromJson(json['seeker'] as Map<String, dynamic>),
    );
  }
}

class ApplicationDetailModel extends ApplicationDetailEntity {
  const ApplicationDetailModel({
    required super.id,
    required super.status,
    super.coverLetter,
    super.employerNote,
    required super.appliedAt,
    super.viewedAt,
    required super.vacancy,
    required super.seeker,
  });

  factory ApplicationDetailModel.fromJson(Map<String, dynamic> json) {
    return ApplicationDetailModel(
      id: json['id'] as String,
      status: json['status'] as String,
      coverLetter: json['cover_letter'] as String?,
      employerNote: json['employer_note'] as String?,
      appliedAt: DateTime.parse(json['applied_at'] as String),
      viewedAt: json['viewed_at'] != null ? DateTime.parse(json['viewed_at'] as String) : null,
      vacancy: VacancyShortModel.fromJson(json['vacancy'] as Map<String, dynamic>),
      seeker: SeekerShortModel.fromJson(json['seeker'] as Map<String, dynamic>),
    );
  }
}

class PaginatedApplicationsModel extends PaginatedApplications {
  const PaginatedApplicationsModel({required super.items, required super.meta});

  factory PaginatedApplicationsModel.fromJson(Map<String, dynamic> json) {
    final metaJson = json['meta'] as Map<String, dynamic>;
    final items = (json['items'] as List<dynamic>)
        .map((e) => ApplicationShortModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return PaginatedApplicationsModel(
      items: items,
      meta: PaginationMeta(
        page: metaJson['page'] as int,
        limit: metaJson['limit'] as int,
        total: metaJson['total'] as int,
        pages: metaJson['pages'] as int,
        hasNext: metaJson['has_next'] as bool,
        hasPrev: metaJson['has_prev'] as bool,
      ),
    );
  }
}
