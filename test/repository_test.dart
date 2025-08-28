import 'package:adapta_test/core/notifications.dart';
import 'package:adapta_test/data/notification_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationRepository', () {
    late NotificationRepository repository;

    setUp(() {
      repository = NotificationRepository();
    });

    test('should return list of notifications', () async {
      final List<Notification> notifications = await repository.getNotifications();

      expect(notifications, isNotEmpty);
      expect(notifications.length, 3);
      expect(notifications.first, isA<Notification>());
    });

    test('should update notification status', () async {
      final List<Notification> originalNotifications = await repository.getNotifications();
      final Notification firstNotification = originalNotifications.first;

      expect(firstNotification.status, NotificationStatus.openstaand);

      await repository.updateStatus(firstNotification.id, NotificationStatus.meeBezig);

      final List<Notification> updatedNotifications = await repository.getNotifications();
      final Notification updatedNotification = updatedNotifications
          .firstWhere((Notification n) => n.id == firstNotification.id);

      expect(updatedNotification.status, NotificationStatus.meeBezig);
    });

    test('should not update non-existent notification', () async {
      // Should not throw error when updating non-existent notification
      expect(
            () => repository.updateStatus('non-existent', NotificationStatus.meeBezig),
        returnsNormally,
      );
    });

    test('should contain correct notification data', () async {
      final List<Notification> notifications = await repository.getNotifications();

      expect(notifications.any((Notification n) => n.title.contains('Aanvraagformulier')), isTrue);
      expect(notifications.any((Notification n) => n.title.contains('S. Tetteren')), isTrue);
      expect(notifications.any((Notification n) => n.title.contains('C. Tan')), isTrue);
    });
  });
}
