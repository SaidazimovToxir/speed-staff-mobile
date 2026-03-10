import 'package:speed_staff_mobile/features/employer/employer_home/data/models/dashboard_model.dart';
import 'package:speed_staff_mobile/features/employer/applications/data/models/application_model.dart';

abstract class EmployerHomeRemoteDataSource {
  Future<EmployerStatsModel> getDashboardStats();
  Future<List<ApplicationModel>> getRecentApplications();
}

class EmployerHomeMockDataSourceImpl implements EmployerHomeRemoteDataSource {
  @override
  Future<EmployerStatsModel> getDashboardStats() async {
    await Future.delayed(const Duration(seconds: 1));
    return const EmployerStatsModel(
      activeVacancies: "12",
      totalApplications: "248",
      newToday: "+15",
    );
  }

  @override
  Future<List<ApplicationModel>> getRecentApplications() async {
    await Future.delayed(const Duration(seconds: 1));
    return const [
      ApplicationModel(
        id: "1",
        candidateName: "John Doe",
        role: "Senior Barista",
        status: "Interview",
        time: "now",
        rating: "4.8",
      ),
      ApplicationModel(
        id: "2",
        candidateName: "Sarah Jenkins",
        role: "Floor Manager",
        status: "Applied",
        time: "2h ago",
        rating: "4.6",
      ),
      ApplicationModel(
        id: "3",
        candidateName: "Michael Chen",
        role: "Kitchen Assistant",
        status: "Applied",
        time: "4h ago",
        rating: "4.9",
      ),
    ];
  }
}
