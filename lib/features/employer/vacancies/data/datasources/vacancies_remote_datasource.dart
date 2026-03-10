import 'package:speed_staff_mobile/features/employer/vacancies/domain/entities/vacancy_entity.dart';

abstract class VacanciesRemoteDataSource {
  Future<List<VacancyEntity>> getMyVacancies();
  Future<void> createVacancy(Map<String, dynamic> vacancyData);
}

class VacanciesMockDataSourceImpl implements VacanciesRemoteDataSource {
  @override
  Future<List<VacancyEntity>> getMyVacancies() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      VacancyEntity(
        id: "1",
        role: "Senior Barista",
        company: "Gourmet Coffee Lab",
        location: "Tashkent, Uzbekistan",
        appliedCount: "24",
        newCount: "3",
        status: "Active",
      ),
      VacancyEntity(
        id: "2",
        role: "Floor Manager",
        company: "The Golden Grill",
        location: "Tashkent, Uzbekistan",
        appliedCount: "12",
        newCount: "1",
        status: "Active",
      ),
      VacancyEntity(
        id: "3",
        role: "Kitchen Assistant",
        company: "Global Cuisine",
        location: "Tashkent, Uzbekistan",
        appliedCount: "45",
        newCount: "10",
        status: "Active",
      ),
    ];
  }

  @override
  Future<void> createVacancy(Map<String, dynamic> vacancyData) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
