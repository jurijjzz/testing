import '../core/notifications.dart';

class NotificationRepository {
  final List<Notification> _notifications = <Notification>[
    Notification(
      id: '1',
      title: 'Aanvraagformulier ontvangen',
      description: 'Ontvangen aanvraagformulier verpleging thuis',
      details: 'Ontvangen aanvraagformulier verpleging thuis met ZD-Nummer: ZD100015706',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      status: NotificationStatus.openstaand,
    ),
    Notification(
      id: '2',
      title: 'S. Tetteren',
      description: 'Het deksel is niet gesloten en de medicatie kan daardoor niet worden uitgegeven',
      details:
          'Het deksel is niet gesloten en de medicatie kan daardoor niet worden uitgegeven. Controleer het systeem.',
      timestamp: DateTime.now().subtract(const Duration(hours: 33)),
      status: NotificationStatus.openstaand,
    ),
    Notification(
      id: '3',
      title: 'C. Tan',
      description: 'Controleer de alarmfunctionaliteit',
      details: 'Controleer de alarmfunctionaliteit. Het alarm dat ontstaat kan veilig worden genegeerd.',
      timestamp: DateTime.now().subtract(const Duration(hours: 24)),
      status: NotificationStatus.openstaand,
    ),
  ];

  Future<List<Notification>> getNotifications() async {
    return List<Notification>.from(_notifications);
  }

  Future<void> updateStatus(String id, NotificationStatus status) async {
    final int index = _notifications.indexWhere((Notification n) => n.id == id);
    if (index >= 0) {
      _notifications[index] = _notifications[index].copyWith(status: status);
    }
  }
}
