import 'package:arjun_guruji/features/EventManagement/presentation/pages/event_details_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';

class CalendarPage extends StatefulWidget {
  final List<EventEntity> events;
  const CalendarPage({super.key, required this.events});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<EventEntity>> _eventsMap = {};
  List<EventEntity> _selectedEvents = [];

  List<EventEntity> _getEventsForDay(DateTime day) {
    return _eventsMap[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _buildEventsMap(List<EventEntity> events) {
    final map = <DateTime, List<EventEntity>>{};
    for (final event in events) {
      // Handle recurring events (weekly)
      if (event.eventType == 'Recurring' &&
          event.frequency == 'weekly' &&
          event.day != null) {
        DateTime current = event.startDate;
        while (!current.isAfter(event.endDate)) {
          if (_weekdayToString(current.weekday) == event.day) {
            final key = DateTime(current.year, current.month, current.day);
            map.putIfAbsent(key, () => []).add(event);
          }
          current = current.add(const Duration(days: 1));
        }
      } else {
        // Simple or one-time event
        DateTime current = event.startDate;
        while (!current.isAfter(event.endDate)) {
          final key = DateTime(current.year, current.month, current.day);
          map.putIfAbsent(key, () => []).add(event);
          current = current.add(const Duration(days: 1));
        }
      }
    }
    setState(() {
      _eventsMap = map;
      _selectedEvents = _getEventsForDay(_selectedDay ?? _focusedDay);
    });
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

  @override
  Widget build(BuildContext context) {
    _buildEventsMap(widget.events);
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          TableCalendar<EventEntity>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents = _getEventsForDay(selectedDay);
              });
            },
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              markerDecoration:
                  BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedEvents.length,
              itemBuilder: (context, index) {
                final event = _selectedEvents[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EventDetailsPage(event: event),
                        ),
                      );
                    },
                    title: Text(event.title),
                    subtitle: Text(event.description),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
