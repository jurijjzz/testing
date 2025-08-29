import 'package:equatable/equatable.dart';

enum NotificationStatus { openstaand, meeBezig, afgerond }

class WorkNotifications extends Equatable {
  const WorkNotifications({
    required this.id,
    required this.title,
    required this.description,
    required this.details,
    required this.timestamp,
    required this.status,
  });

  final String id;
  final String title;
  final String description;
  final String details;
  final DateTime timestamp;
  final NotificationStatus status;

  WorkNotifications copyWith({NotificationStatus? status}) {
    return WorkNotifications(
      id: id,
      title: title,
      description: description,
      details: details,
      timestamp: timestamp,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, title, description, details, timestamp, status];
}
