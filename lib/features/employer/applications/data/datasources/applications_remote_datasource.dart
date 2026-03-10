import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';

abstract class ApplicationsRemoteDataSource {
  Future<List<CandidateEntity>> getVacancyApplications();
  Future<CandidateEntity> getCandidateDetails(String candidateId);
  Future<String> updateApplicationStatus(String newStatus);
}

class ApplicationsMockDataSourceImpl implements ApplicationsRemoteDataSource {
  @override
  Future<List<CandidateEntity>> getVacancyApplications() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      CandidateEntity(
        id: "1",
        name: "John Doe",
        role: "Shortlisted",
        rating: "4.8",
        reviewCount: "2h ago",
      ),
      CandidateEntity(
        id: "2",
        name: "Sarah Jenkins",
        role: "New",
        rating: "4.6",
        reviewCount: "5h ago",
      ),
      CandidateEntity(
        id: "3",
        name: "Michael Chen",
        role: "Interviewing",
        rating: "4.9",
        reviewCount: "1d ago",
      ),
      CandidateEntity(
        id: "4",
        name: "Elena Rodriguez",
        role: "New",
        rating: "4.7",
        reviewCount: "2d ago",
      ),
    ];
  }

  @override
  Future<CandidateEntity> getCandidateDetails(String candidateId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return CandidateEntity(
      id: candidateId,
      name: "Alisher Karimov",
      role: "Senior Barista",
      rating: "4.8",
      reviewCount: "124 reviews",
      skills: [
        "Coffee Art",
        "Customer Service",
        "Cash Handling",
        "Team Management",
        "Inventory Mgmt",
      ],
      experiences: [
        ExperienceEntity(
          company: "Gourmet Coffee Lab",
          role: "Lead Barista",
          period: "Jan 2021 - Present • 3 yrs 2 mos",
          description:
              "Managing a team of 5 baristas, overseeing daily operations, and ensuring top-tier customer satisfaction.",
          isPresent: true,
        ),
      ],
      documents: [
        DocumentEntity(
          name: "Resume_Alisher_K.pdf",
          info: "1.2 MB • Updated 2 days ago",
        ),
      ],
    );
  }

  @override
  Future<String> updateApplicationStatus(String newStatus) async {
    await Future.delayed(const Duration(seconds: 1));
    return newStatus;
  }
}
