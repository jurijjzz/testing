import 'package:equatable/equatable.dart';

import '../../core/notifications.dart';

class NotificationState extends Equatable {
  const NotificationState({
    this.notifications = const <Notification>[],
    this.currentFilter,
    this.isLoading = false,
    this.error,
  });

  final List<Notification> notifications;
  final NotificationStatus? currentFilter;
  final bool isLoading;
  final String? error;

  NotificationState copyWith({
    List<Notification>? notifications,
    NotificationStatus? currentFilter,
    bool? isLoading,
    String? error,
    bool clearFilter = false,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      currentFilter: clearFilter ? null : (currentFilter ?? this.currentFilter),
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  List<Notification> get filteredNotifications {
    if (currentFilter == null) return notifications;
    return notifications.where((Notification n) => n.status == currentFilter).toList();
  }

  // Count of notifications per status
  int get openstaandCount => notifications.where((Notification n) => n.status == NotificationStatus.openstaand).length;

  int get meeBezigCount => notifications.where((Notification n) => n.status == NotificationStatus.meeBezig).length;

  int get afgerondCount => notifications.where((Notification n) => n.status == NotificationStatus.afgerond).length;

  @override
  List<Object?> get props => <Object?>[notifications, currentFilter, isLoading, error];
}
