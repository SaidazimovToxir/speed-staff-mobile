abstract class EmployerProfileRemoteDataSource {
  Future<Map<String, dynamic>> getEmployerProfile();
  Future<void> updateEmployerProfile(Map<String, dynamic> data);
}

class EmployerProfileMockDataSourceImpl implements EmployerProfileRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getEmployerProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      "name": "The Golden Grill",
      "location": "123 Culinary Blvd, Suite 40",
      "rating": "4.8",
      "vacanciesCount": "4",
      "about":
          "The Golden Grill is a premier destination for world-class culinary experiences...",
    };
  }

  @override
  Future<void> updateEmployerProfile(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
