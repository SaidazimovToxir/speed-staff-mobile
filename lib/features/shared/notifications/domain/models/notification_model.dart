class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String timeAgo;
  final bool isUnread;
  final String type; // e.g., 'viewed', 'vacancy', 'shortlisted'

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timeAgo,
    this.isUnread = false,
    required this.type,
  });
}
