import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/mock_notification_repository.dart';
import '../../domain/models/notification_model.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final MockNotificationRepository repository;
  
  NotificationBloc({required this.repository}) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
  }

  Future<void> _onLoadNotifications(LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final notifications = await repository.getNotifications();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
