import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../../domain/usecases/fetch_notifications_usecase.dart';
import '../../data/repository/notifications_repository_impl.dart';
import '../../data/datasource/notifications_remote_ds.dart';
import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationBloc(
        FetchNotificationsUseCase(
          NotificationsRepositoryImpl(
            NotificationsRemoteDataSource(),
          ),
        ),
      )..add(FetchNotifications()),
      child: Scaffold(
        appBar: GradientAppBar(
          title: 'Notifications',
        ),
        body: GradientBackground(
          child: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is NotificationLoaded) {
                final notifications = state.notifications;
                if (notifications.isEmpty) {
                  return const Center(child: Text('No notifications'));
                }
                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (notification.image != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Image.network(notification.image!),
                              ),
                            Text(
                              notification.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              notification.description,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${notification.dateTime.toLocal()}".split(' ')[0],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            if (notification.onTapLink != null)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () async {
                                    try {
                                      final url = notification.onTapLink!;
                                      final uri = Uri.parse(url);
                                      
                                      // Try to launch URL with external application mode
                                      if (await canLaunchUrl(uri)) {
                                        final result = await launchUrl(
                                          uri, 
                                          mode: LaunchMode.externalApplication,
                                        );
                                        if (!result) {
                                          throw Exception('Failed to launch URL');
                                        }
                                      } else {
                                        // If canLaunchUrl returns false, try with platform default mode
                                        final result = await launchUrl(
                                          uri, 
                                          mode: LaunchMode.platformDefault,
                                        );
                                        if (!result) {
                                          throw Exception('No app found to handle this URL');
                                        }
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Could not open the link: ${e.toString()}"),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text("View Details"),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is NotificationError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
