import 'package:equatable/equatable.dart';

// Seeker qisqa profil entity
class SeekerShortEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final String? position;
  final double rating;
  final String? city;
  final bool isAvailable;

  const SeekerShortEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
    this.position,
    required this.rating,
    this.city,
    required this.isAvailable,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, firstName, lastName, avatarUrl, position, rating, city, isAvailable];
}

// Employer qisqa profil entity
class EmployerShortEntity extends Equatable {
  final String id;
  final String restaurantName;
  final String? logoUrl;
  final String? city;
  final double rating;
  final bool isVerified;
  final int totalReviews;

  const EmployerShortEntity({
    required this.id,
    required this.restaurantName,
    this.logoUrl,
    this.city,
    required this.rating,
    required this.isVerified,
    required this.totalReviews,
  });

  @override
  List<Object?> get props => [id, restaurantName, logoUrl, city, rating, isVerified, totalReviews];
}

// Vacancy qisqa entity
class VacancyShortEntity extends Equatable {
  final String id;
  final String title;
  final String position;
  final int? salaryMin;
  final int? salaryMax;
  final String salaryType;
  final String workType;
  final bool isPremium;
  final String status;
  final EmployerShortEntity employer;
  final DateTime createdAt;

  const VacancyShortEntity({
    required this.id,
    required this.title,
    required this.position,
    this.salaryMin,
    this.salaryMax,
    required this.salaryType,
    required this.workType,
    required this.isPremium,
    required this.status,
    required this.employer,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, position, salaryMin, salaryMax, salaryType, workType, isPremium, status, employer, createdAt];
}

// Application ro'yxat uchun qisqa entity
class ApplicationShortEntity extends Equatable {
  final String id;
  final String status;
  final DateTime appliedAt;
  final SeekerShortEntity seeker;

  const ApplicationShortEntity({
    required this.id,
    required this.status,
    required this.appliedAt,
    required this.seeker,
  });

  @override
  List<Object?> get props => [id, status, appliedAt, seeker];
}

// Application detail entity
class ApplicationDetailEntity extends Equatable {
  final String id;
  final String status;
  final String? coverLetter;
  final String? employerNote;
  final DateTime appliedAt;
  final DateTime? viewedAt;
  final VacancyShortEntity vacancy;
  final SeekerShortEntity seeker;

  const ApplicationDetailEntity({
    required this.id,
    required this.status,
    this.coverLetter,
    this.employerNote,
    required this.appliedAt,
    this.viewedAt,
    required this.vacancy,
    required this.seeker,
  });

  bool get isFinal => status == 'hired' || status == 'rejected';

  List<String> get allowedTransitions {
    switch (status) {
      case 'sent':
        return ['shortlisted', 'rejected'];
      case 'viewed':
        return ['shortlisted', 'rejected'];
      case 'shortlisted':
        return ['hired', 'rejected'];
      default:
        return [];
    }
  }

  @override
  List<Object?> get props => [id, status, coverLetter, employerNote, appliedAt, viewedAt, vacancy, seeker];
}

// Paginated meta
class PaginationMeta extends Equatable {
  final int page;
  final int limit;
  final int total;
  final int pages;
  final bool hasNext;
  final bool hasPrev;

  const PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
    required this.hasNext,
    required this.hasPrev,
  });

  @override
  List<Object?> get props => [page, limit, total, pages, hasNext, hasPrev];
}

class PaginatedApplications extends Equatable {
  final List<ApplicationShortEntity> items;
  final PaginationMeta meta;

  const PaginatedApplications({required this.items, required this.meta});

  @override
  List<Object?> get props => [items, meta];
}
