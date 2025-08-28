import 'package:equatable/equatable.dart';

enum NotificationStatus { openstaand, meeBezig, afgerond }

class Notification extends Equatable {
  const Notification({
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

  Notification copyWith({NotificationStatus? status}) {
    return Notification(
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
