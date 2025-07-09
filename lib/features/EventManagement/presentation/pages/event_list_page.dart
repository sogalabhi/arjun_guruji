import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/pages/calendar_page.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/widgets/featured_events_carousel.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/widgets/past_events_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/bloc/event_bloc.dart';
import 'package:hive/hive.dart';
import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final interestedBox = Hive.box('interestedBox');
    return BlocProvider(
      create: (_) => EventBloc()..add(FetchEvents()),
      child: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventsLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is EventsLoaded) {
            final events = state.events;
            final featuredAndRecurringEvents = events
                .where((event) =>
                    event.eventType == "Recurring" || event.isFeatured)
                .toList();
            featuredAndRecurringEvents.sort((a, b) {
              if (a.isFeatured && !b.isFeatured) {
                return -1;
              } else if (!a.isFeatured && b.isFeatured) {
                return 1;
              } else {
                return a.eventType == "Recurring" ? -1 : 1;
              }
            });
            return Scaffold(
              appBar: GradientAppBar(
                title: 'Events',
                actions: [
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalendarPage(events: events),
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: GradientBackground(
                child: RefreshIndicator(
                  onRefresh: () async {
                    // Dispatch FetchEvents and wait for reload
                    final bloc = BlocProvider.of<EventBloc>(context);
                    bloc.add(FetchEvents());
                    // Wait for EventsLoaded state
                    await bloc.stream.firstWhere((state) => state is EventsLoaded || state is EventsError);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            'Major Events',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FeaturedEventsCarousel(
                          events: featuredAndRecurringEvents,
                          interestedBox: interestedBox,
                        ),
                        const SizedBox(height: 16),
                        PastEventsList(
                            events: events, interestedBox: interestedBox),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (state is EventsError) {
            return Scaffold(
              appBar: GradientAppBar(
                title: 'Events',
              ),
              body: Center(child: Text(state.message)),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
