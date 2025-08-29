import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/notifications.dart';
import '../cubit/notification_cubit.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage(this.notification, {super.key});

  final WorkNotifications notification;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Melding ZorgDomein'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Vandaag • ${notification.timestamp.hour}:${notification.timestamp.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildStatusActionSection(context),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.description, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Bericht uit team inbox',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(notification.details),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Zou openen in ZorgDomein')),
                );
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open in ZorgDomein'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusActionSection(BuildContext context) {
    switch (notification.status) {
      case NotificationStatus.openstaand:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: <Widget>[
              const Icon(Icons.warning),
              const SizedBox(width: 8),
              const Text('Nog niet opgepakt'),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  context.read<NotificationCubit>().updateNotificationStatus(
                    notification.id,
                    NotificationStatus.meeBezig,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Pak op'),
              ),
            ],
          ),
        );

      case NotificationStatus.meeBezig:
        return Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<NotificationCubit>().updateNotificationStatus(
                    notification.id,
                    NotificationStatus.afgerond,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Afronden'),
              ),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.info, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text('Opgepakt door jou'),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      context.read<NotificationCubit>().updateNotificationStatus(
                        notification.id,
                        NotificationStatus.openstaand,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Pak niet op'),
                  ),
                ],
              ),
            ),
          ],
        );

      case NotificationStatus.afgerond:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: <Widget>[
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Afgerond'),
            ],
          ),
        );
    }
  }
}
