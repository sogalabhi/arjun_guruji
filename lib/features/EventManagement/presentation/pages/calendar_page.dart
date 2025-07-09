import 'package:arjun_guruji/features/EventManagement/presentation/pages/event_details_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';
import 'package:arjun_guruji/core/widgets/gradient_background.dart';

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

  // Method to get color based on event type
  Color _getEventTypeColor(String eventType) {
    switch (eventType) {
      case 'Recurring':
        return Colors.green;
      case 'Featured':
        return Colors.purple;
      case 'One-time':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  List<EventEntity> _getEventsForDay(DateTime day) {
    return _eventsMap[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _buildEventsMap(List<EventEntity> events) {
    final map = <DateTime, List<EventEntity>>{};
    for (final event in events) {
      // Ensure single-day events are mapped
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
        DateTime current = event.startDate;
        while (!current.isAfter(event.endDate)) {
          final key = DateTime(current.year, current.month, current.day);
          map.putIfAbsent(key, () => []).add(event);
          current = current.add(const Duration(days: 1));
        }
      }
    }
    _eventsMap = map;
    _selectedEvents = _getEventsForDay(_selectedDay ?? _focusedDay);
  }

  @override
  void initState() {
    super.initState();
    _buildEventsMap(widget.events);
  }

  @override
  void didUpdateWidget(covariant CalendarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.events != widget.events) {
      setState(() {
        _buildEventsMap(widget.events);
      });
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

  // Helper method to build a legend item
  // Widget _buildLegendItem(String label, Color color) {
  //   return Row(
  //     children: [
  //       Container(
  //         width: 12,
  //         height: 12,
  //         decoration: BoxDecoration(
  //           color: color,
  //           shape: BoxShape.circle,
  //         ),
  //       ),
  //       const SizedBox(width: 4),
  //       Text(
  //         label,
  //         style: const TextStyle(
  //           fontSize: 12,
  //           color: Colors.white,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Calendar',
      ),
      body: GradientBackground(
        child: Column(
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
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return const SizedBox();

                  return Positioned(
                    bottom: 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: events.take(3).map((event) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1.0),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getEventTypeColor(event.eventType),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                formatButtonTextStyle: TextStyle(color: Colors.white),
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: Colors.white),
              ),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color(0xFF9C27B0),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                // For better visibility on gradient background
                defaultTextStyle: TextStyle(color: Colors.white),
                weekendTextStyle: TextStyle(color: Colors.white70),
                outsideTextStyle: TextStyle(color: Colors.white38),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Events for Selected Day',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedEvents.length,
                itemBuilder: (context, index) {
                  final event = _selectedEvents[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                EventDetailsPage(event: event),
                          ),
                        );
                      },
                      leading: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getEventTypeColor(event.eventType),
                          shape: BoxShape.circle,
                        ),
                      ),
                      title: Text(event.title),
                      subtitle: Text(event.description),
                      // trailing: Chip(
                      //   backgroundColor: _getEventTypeColor(event.eventType)
                      //       .withOpacity(0.2),
                      //   label: Text(
                      //     event.eventType,
                      //     style: TextStyle(
                      //       color: _getEventTypeColor(event.eventType),
                      //       fontSize: 12,
                      //     ),
                      //   ),
                      // ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
           ],
        ),
      ),
    );
  }
}
