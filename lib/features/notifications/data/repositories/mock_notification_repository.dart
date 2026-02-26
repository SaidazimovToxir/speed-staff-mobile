
import 'package:speed_staff_mobile/features/notifications/domain/models/notification_model.dart';

class MockNotificationRepository {
  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 'n1',
      title: 'Application Viewed',
      description: 'Your application for Senior Barista was viewed by Downtown Coffee Hub.',
      timeAgo: '2h ago',
      isUnread: true,
      type: 'viewed',
    ),
    NotificationModel(
      id: 'n2',
      title: 'New Vacancy',
      description: 'A new Cook vacancy matches your profile at The Grand Bistro.',
      timeAgo: '5h ago',
      isUnread: false,
      type: 'vacancy',
    ),
    NotificationModel(
      id: 'n3',
      title: 'Shortlisted!',
      description: 'Congratulations! You have been shortlisted for the Floor Manager position.',
      timeAgo: '1d ago',
      isUnread: false,
      type: 'shortlisted',
    ),
  ];

  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return notifications;
  }
}
