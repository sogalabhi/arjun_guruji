import 'package:arjun_guruji/features/Admin/presentation/pages/admin_login_page.dart';
import 'package:flutter/material.dart';
import 'package:arjun_guruji/features/Admin/presentation/pages/admin_events_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arjun_guruji/features/Admin/domain/repository/event_repository.dart';
import 'package:arjun_guruji/features/Admin/presentation/bloc/event_bloc.dart';
import 'package:arjun_guruji/features/Admin/presentation/bloc/event_event.dart';
import 'package:arjun_guruji/injection_container.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdminLoginPage()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Admin Dashboard!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.event),
              label: const Text('Manage Events'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RepositoryProvider.value(
                      value: sl<EventRepository>(),
                      child: BlocProvider<EventBloc>(
                        create: (_) => sl<EventBloc>()..add(LoadEvents()),
                        child: const AdminEventsPage(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
