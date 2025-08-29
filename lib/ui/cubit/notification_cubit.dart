import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/notifications.dart';
import '../../data/notification_repository.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this.repository) : super(const NotificationState());
  final NotificationRepository repository;

  Future<void> loadNotifications() async {
    emit(state.copyWith(isLoading: true));
    try {
      final List<WorkNotifications> notifications = await repository.getNotifications();
      emit(state.copyWith(notifications: notifications, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void filterByStatus(NotificationStatus? status) {
    emit(state.copyWith(currentFilter: status));
  }

  Future<void> updateNotificationStatus(String id, NotificationStatus newStatus) async {
    try {
      await repository.updateStatus(id, newStatus);

      final List<WorkNotifications> updatedNotifications = state.notifications.map((WorkNotifications notification) {
        if (notification.id == id) {
          return notification.copyWith(status: newStatus);
        }
        return notification;
      }).toList();

      emit(state.copyWith(notifications: updatedNotifications));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
