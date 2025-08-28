import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/notification_repository.dart';
import 'ui/cubit/notification_cubit.dart';
import 'ui/pages/notification_overview_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification App',
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue[900],
          foregroundColor: Colors.white,
        ),
      ),
      home: BlocProvider<NotificationCubit>(
        create: (BuildContext context) => NotificationCubit(NotificationRepository())
          ..loadNotifications(),
        child: const NotificationOverviewPage(),
      ),
    );
  }
}
