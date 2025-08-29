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
      final List<WorkNotifications> notifications = await repository.getNotifications();

      expect(notifications, isNotEmpty);
      expect(notifications.length, 3);
      expect(notifications.first, isA<WorkNotifications>());
    });

    test('should update notification status', () async {
      final List<WorkNotifications> originalNotifications = await repository.getNotifications();
      final WorkNotifications firstNotification = originalNotifications.first;

      expect(firstNotification.status, NotificationStatus.openstaand);

      await repository.updateStatus(firstNotification.id, NotificationStatus.meeBezig);

      final List<WorkNotifications> updatedNotifications = await repository.getNotifications();
      final WorkNotifications updatedNotification = updatedNotifications.firstWhere(
        (WorkNotifications n) => n.id == firstNotification.id,
      );

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
      final List<WorkNotifications> notifications = await repository.getNotifications();

      expect(notifications.any((WorkNotifications n) => n.title.contains('Aanvraagformulier')), isTrue);
      expect(notifications.any((WorkNotifications n) => n.title.contains('S. Tetteren')), isTrue);
      expect(notifications.any((WorkNotifications n) => n.title.contains('C. Tan')), isTrue);
    });
  });
}
