import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/notifications.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';
import '../widgets/notification_card.dart';
import 'notification_detail_page.dart';

class NotificationOverviewPage extends StatelessWidget {
  const NotificationOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Meldingen'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (BuildContext context, NotificationState state) {
                return TabBar(
                  onTap: (int index) {
                    final NotificationStatus? status = _getStatusFromIndex(index);
                    context.read<NotificationCubit>().filterByStatus(status);
                  },
                  tabs: <Widget>[
                    _buildTab(
                      'Openstaand',
                      state.currentFilter == NotificationStatus.openstaand
                          ? Icons.notifications
                          : Icons.notifications_outlined,
                      state.openstaandCount,
                    ),
                    _buildTab(
                      'Mee bezig',
                      state.currentFilter == NotificationStatus.meeBezig ? Icons.access_time_filled : Icons.access_time,
                      state.meeBezigCount,
                    ),
                    _buildTab(
                      'Afgerond',
                      state.currentFilter == NotificationStatus.afgerond
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      state.afgerondCount,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (BuildContext context, NotificationState state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Error: ${state.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<NotificationCubit>().loadNotifications(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final List<WorkNotifications> notifications = state.filteredNotifications;

            if (notifications.isEmpty) {
              return Center(
                child: Text(_getEmptyMessage(state.currentFilter)),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<NotificationCubit>().loadNotifications(),
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  final WorkNotifications notification = notifications[index];
                  return NotificationCard(
                    notification: notification,
                    onTap: () => _navigateToDetail(context, notification),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTab(String label, IconData icon, int count) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: <Widget>[
          // Badge on top of icon
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Icon(icon, size: 25, color: Colors.white),
              if (count > 0)
                Positioned(
                  right: -8,
                  top: -8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[900],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$count',
                        style: const TextStyle(color: Colors.white, fontSize: 9),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  NotificationStatus? _getStatusFromIndex(int index) {
    switch (index) {
      case 0:
        return NotificationStatus.openstaand;
      case 1:
        return NotificationStatus.meeBezig;
      case 2:
        return NotificationStatus.afgerond;
      default:
        return null;
    }
  }

  String _getEmptyMessage(NotificationStatus? filter) {
    switch (filter) {
      case NotificationStatus.openstaand:
        return 'Geen openstaande meldingen';
      case NotificationStatus.meeBezig:
        return 'Geen meldingen in behandeling';
      case NotificationStatus.afgerond:
        return 'Geen afgeronde meldingen';
      case null:
        return 'Geen meldingen gevonden';
    }
  }

  void _navigateToDetail(BuildContext context, WorkNotifications notification) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<NotificationCubit>.value(
          value: context.read<NotificationCubit>(),
          child: NotificationDetailPage(notification),
        ),
      ),
    );
  }
}
