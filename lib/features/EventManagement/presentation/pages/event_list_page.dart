import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/pages/calendar_page.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/widgets/featured_events_carousel.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/widgets/past_events_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/bloc/event_bloc.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:hive/hive.dart';
import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  // Helper method to check if a recurring event has future occurrences
  bool _hasFutureOccurrence(EventEntity event, DateTime today) {
    if (event.eventType != "Recurring" || event.day == null || event.frequency != "weekly") {
      return false;
    }
    
    // Check if the event end date is in the future
    if (event.endDate.isBefore(today)) {
      return false;
    }
    
    // Check if there's at least one future occurrence
    final nextDate = _getNextOccurrenceDate(event, today);
    return nextDate != null;
  }

  // Helper method to get the next occurrence date for an event
  DateTime _getNextOccurrenceDate(EventEntity event, DateTime today) {
    if (event.eventType == "Recurring" && event.day != null && event.frequency == "weekly") {
      // For recurring events, calculate the next occurrence
      return _getNextWeeklyOccurrence(event, today);
    } else {
      // For non-recurring events, return the start date
      return event.startDate;
    }
  }

  // Helper method to get the next weekly occurrence
  DateTime _getNextWeeklyOccurrence(EventEntity event, DateTime today) {
    final targetWeekday = _dayStringToWeekday(event.day!);
    final currentWeekday = today.weekday;
    
    int daysToAdd = targetWeekday - currentWeekday;
    if (daysToAdd <= 0) {
      daysToAdd += 7; // Move to next week
    }
    
    final nextOccurrence = today.add(Duration(days: daysToAdd));
    
    // Check if this occurrence is within the event's date range
    if (nextOccurrence.isAfter(event.endDate)) {
      return event.startDate; // Return start date if no future occurrences
    }
    
    return nextOccurrence;
  }

  // Helper method to convert day string to weekday number
  int _dayStringToWeekday(String day) {
    switch (day.toLowerCase()) {
      case 'monday': return DateTime.monday;
      case 'tuesday': return DateTime.tuesday;
      case 'wednesday': return DateTime.wednesday;
      case 'thursday': return DateTime.thursday;
      case 'friday': return DateTime.friday;
      case 'saturday': return DateTime.saturday;
      case 'sunday': return DateTime.sunday;
      default: return DateTime.monday;
    }
  }

  // Helper method to convert weekday number to string
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

  // Helper method to check if a recurring event occurs today
  bool _isOccurrenceToday(EventEntity event, DateTime today) {
    if (event.eventType == "Recurring" && event.day != null && event.frequency == "weekly") {
      final eventStart = DateTime(event.startDate.year, event.startDate.month, event.startDate.day);
      final eventEnd = DateTime(event.endDate.year, event.endDate.month, event.endDate.day);
      if (today.isBefore(eventStart) || today.isAfter(eventEnd)) return false;
      final weekdayString = _weekdayToString(today.weekday).toLowerCase();
      return weekdayString == event.day!.toLowerCase();
    }
    return false;
  }

  // Helper method to get the next occurrence date for a recurring event (including today)
  DateTime? _getNextOrTodayOccurrence(EventEntity event, DateTime today) {
    if (event.eventType == "Recurring" && event.day != null && event.frequency == "weekly") {
      final eventStart = DateTime(event.startDate.year, event.startDate.month, event.startDate.day);
      final eventEnd = DateTime(event.endDate.year, event.endDate.month, event.endDate.day);
      if (today.isBefore(eventStart)) return eventStart;
      if (today.isAfter(eventEnd)) return null;
      final weekdayString = _weekdayToString(today.weekday).toLowerCase();
      if (weekdayString == event.day!.toLowerCase()) {
        return today;
      }
      // Find the next occurrence after today
      for (int i = 1; i <= 7; i++) {
        final nextDay = today.add(Duration(days: i));
        final nextWeekdayString = _weekdayToString(nextDay.weekday).toLowerCase();
        if (nextWeekdayString == event.day!.toLowerCase() && !nextDay.isAfter(eventEnd)) {
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
      create: (_) => EventBloc()..add(FetchEvents()),
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
            
            // Get upcoming events (future + today) including recurring events
            final upcomingEvents = events.where((event) {
              if (event.eventType == "Recurring") {
                // For recurring events, include if today or any future date matches recurrence day
                return _getNextOrTodayOccurrence(event, today) != null;
              } else {
                // For non-recurring events, check if they start today or in the future (ignore time)
                final eventDate = DateTime(event.startDate.year, event.startDate.month, event.startDate.day);
                return !eventDate.isBefore(today); // include today
              }
            }).toList();
            
            // Sort upcoming events by their next occurrence date
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
                            'Upcoming Events',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FeaturedEventsCarousel(
                          events: upcomingEvents,
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
