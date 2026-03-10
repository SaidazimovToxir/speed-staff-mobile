import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';

class ExperienceModel extends ExperienceEntity {
  const ExperienceModel({
    required super.company,
    required super.role,
    required super.period,
    required super.description,
    super.isPresent,
  });
  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      company: json['company'] as String,
      role: json['role'] as String,
      period: json['period'] as String,
      description: json['description'] as String,
      isPresent: json['is_present'] as bool? ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'role': role,
      'period': period,
      'description': description,
      'is_present': isPresent,
    };
  }
}

class DocumentModel extends DocumentEntity {
  const DocumentModel({required super.name, required super.info});
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      name: json['name'] as String,
      info: json['info'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {'name': name, 'info': info};
  }
}

class CandidateModel extends CandidateEntity {
  const CandidateModel({
    required super.id,
    required super.name,
    super.role,
    required super.rating,
    super.reviewCount,
    super.skills,
    super.experiences,
    super.documents,
  });
  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String?,
      rating: json['rating'] as String,
      reviewCount: json['review_count'] as String?,
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      experiences: (json['experiences'] as List<dynamic>?)
          ?.map((e) => ExperienceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      documents: (json['documents'] as List<dynamic>?)
          ?.map((e) => DocumentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'rating': rating,
      'review_count': reviewCount,
      'skills': skills,
      'experiences': experiences
          ?.cast<ExperienceModel>()
          .map((e) => e.toJson())
          .toList(),
      'documents': documents
          ?.cast<DocumentModel>()
          .map((e) => e.toJson())
          .toList(),
    };
  }
}

class ApplicationModel extends ApplicationEntity {
  const ApplicationModel({
    required super.id,
    required super.candidateName,
    required super.role,
    required super.status,
    required super.time,
    required super.rating,
  });
  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] as String,
      candidateName: json['candidate_name'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      time: json['time'] as String,
      rating: json['rating'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'candidate_name': candidateName,
      'role': role,
      'status': status,
      'time': time,
      'rating': rating,
    };
  }
}
