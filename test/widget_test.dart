import 'package:adapta_test/core/notifications.dart';
import 'package:adapta_test/ui/cubit/notification_cubit.dart';
import 'package:adapta_test/ui/pages/notification_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationCubit extends Mock implements NotificationCubit {}

void main() {
  setUpAll(() {
    registerFallbackValue(NotificationStatus.openstaand);
  });

  group('NotificationDetailPage Widget Tests', () {
    late MockNotificationCubit mockCubit;

    setUp(() {
      mockCubit = MockNotificationCubit();
    });

    Widget createTestWidget(WorkNotifications notification) {
      return MaterialApp(
        home: BlocProvider<NotificationCubit>(
          create: (_) => mockCubit,
          child: NotificationDetailPage(notification),
        ),
      );
    }

    testWidgets('displays basic notification info', (WidgetTester tester) async {
      final WorkNotifications notification = WorkNotifications(
        id: '1',
        title: 'Test Title',
        description: 'Test Description',
        details: 'Test notification details',
        timestamp: DateTime.now(),
        status: NotificationStatus.openstaand,
      );

      await tester.pumpWidget(createTestWidget(notification));

      expect(find.text('Melding ZorgDomein'), findsOneWidget);
      expect(find.text('Test notification details'), findsOneWidget);
      expect(find.text('Bericht uit team inbox'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('shows pak op button for openstaand notification', (WidgetTester tester) async {
      final WorkNotifications notification = WorkNotifications(
        id: '1',
        title: 'Test',
        description: 'Test',
        details: 'Test details',
        timestamp: DateTime.now(),
        status: NotificationStatus.openstaand,
      );

      await tester.pumpWidget(createTestWidget(notification));

      expect(find.text('Nog niet opgepakt'), findsOneWidget);
      expect(find.text('Pak op'), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('shows afronden button for meeBezig notification', (WidgetTester tester) async {
      final WorkNotifications notification = WorkNotifications(
        id: '1',
        title: 'Test',
        description: 'Test',
        details: 'Test details',
        timestamp: DateTime.now(),
        status: NotificationStatus.meeBezig,
      );

      await tester.pumpWidget(createTestWidget(notification));

      expect(find.text('Afronden'), findsOneWidget);
      expect(find.text('Opgepakt door jou'), findsOneWidget);
      expect(find.text('Pak niet op'), findsOneWidget);
    });

    testWidgets('shows completed status for afgerond notification', (WidgetTester tester) async {
      final WorkNotifications notification = WorkNotifications(
        id: '1',
        title: 'Test',
        description: 'Test',
        details: 'Test details',
        timestamp: DateTime.now(),
        status: NotificationStatus.afgerond,
      );

      await tester.pumpWidget(createTestWidget(notification));

      expect(find.text('Afgerond'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('Pak op'), findsNothing);
      expect(find.text('Afronden'), findsNothing);
    });
  });
}
