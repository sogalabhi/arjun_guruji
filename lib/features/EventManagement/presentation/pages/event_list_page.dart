import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/widgets/featured_events_carousel.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/widgets/past_events_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/bloc/event_bloc.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:hive/hive.dart';
import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';
import 'package:arjun_guruji/injection_container.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  DateTime _getNextOccurrenceDate(EventEntity event, DateTime today) {
    if (event.eventType == "Recurring" &&
        event.day != null &&
        event.frequency == "weekly") {
      return _getNextWeeklyOccurrence(event, today);
    } else {
      return event.startDate;
    }
  }

  DateTime _getNextWeeklyOccurrence(EventEntity event, DateTime today) {
    final targetWeekday = _dayStringToWeekday(event.day!);
    final currentWeekday = today.weekday;

    int daysToAdd = targetWeekday - currentWeekday;
    if (daysToAdd <= 0) {
      daysToAdd += 7;
    }

    final nextOccurrence = today.add(Duration(days: daysToAdd));

    if (nextOccurrence.isAfter(event.endDate)) {
      return event.startDate;
    }

    return nextOccurrence;
  }

  int _dayStringToWeekday(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return DateTime.monday;
      case 'tuesday':
        return DateTime.tuesday;
      case 'wednesday':
        return DateTime.wednesday;
      case 'thursday':
        return DateTime.thursday;
      case 'friday':
        return DateTime.friday;
      case 'saturday':
        return DateTime.saturday;
      case 'sunday':
        return DateTime.sunday;
      default:
        return DateTime.monday;
    }
  }

  String _weekdayToString(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  DateTime? _getNextOrTodayOccurrence(EventEntity event, DateTime today) {
    if (event.eventType == "Recurring" &&
        event.day != null &&
        event.frequency == "weekly") {
      final eventStart = DateTime(
          event.startDate.year, event.startDate.month, event.startDate.day);
      final eventEnd =
          DateTime(event.endDate.year, event.endDate.month, event.endDate.day);
      if (today.isBefore(eventStart)) return eventStart;
      if (today.isAfter(eventEnd)) return null;
      final weekdayString = _weekdayToString(today.weekday).toLowerCase();
      if (weekdayString == event.day!.toLowerCase()) {
        return today;
      }
      for (int i = 1; i <= 7; i++) {
        final nextDay = today.add(Duration(days: i));
        final nextWeekdayString =
            _weekdayToString(nextDay.weekday).toLowerCase();
        if (nextWeekdayString == event.day!.toLowerCase() &&
            !nextDay.isAfter(eventEnd)) {
          return nextDay;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final interestedBox = Hive.box('interestedBox');
    return BlocProvider(
      create: (_) => sl<EventBloc>()..add(FetchEvents()),
      child: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventsLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is EventsLoaded) {
            final events = state.events;
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);

            final upcomingEvents = events.where((event) {
              if (event.eventType == "Recurring") {
                return _getNextOrTodayOccurrence(event, today) != null;
              } else {
                final eventDate = DateTime(event.startDate.year,
                    event.startDate.month, event.startDate.day);
                return !eventDate.isBefore(today);
              }
            }).toList();

            upcomingEvents.sort((a, b) {
              final aNextDate = a.eventType == "Recurring"
                  ? _getNextOrTodayOccurrence(a, today) ?? DateTime(2100)
                  : _getNextOccurrenceDate(a, today);
              final bNextDate = b.eventType == "Recurring"
                  ? _getNextOrTodayOccurrence(b, today) ?? DateTime(2100)
                  : _getNextOccurrenceDate(b, today);
              return aNextDate.compareTo(bNextDate);
            });

            return Scaffold(
              appBar: const GradientAppBar(title: 'All Events'),
              body: GradientBackground(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final bloc = BlocProvider.of<EventBloc>(context);
                    bloc.add(FetchEvents());
                    await bloc.stream.firstWhere(
                        (state) => state is EventsLoaded || state is EventsError);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (events.isEmpty) ...[
                          const SizedBox(height: 40),
                          const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.event_note_outlined,
                                    size: 72, color: Colors.white60),
                                SizedBox(height: 16),
                                Text(
                                  "No events available",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "There are currently no events registered.",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              'Upcoming Events',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (upcomingEvents.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Center(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white
                                        .withAlpha((0.05 * 255).toInt()),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Column(
                                    children: [
                                      Icon(Icons.event_available_outlined,
                                          color: Colors.white60, size: 48),
                                      SizedBox(height: 12),
                                      Text(
                                        "No upcoming events scheduled",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Check back later for new programs.",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          else
                            FeaturedEventsCarousel(
                              events: upcomingEvents,
                              interestedBox: interestedBox,
                            ),
                          const SizedBox(height: 16),
                          PastEventsList(
                              events: events, interestedBox: interestedBox),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (state is EventsError) {
            return Scaffold(
              appBar: const GradientAppBar(title: 'All Events'),
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
