import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';
import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:arjun_guruji/features/EventManagement/domain/services/panchang_service.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/bloc/event_bloc.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/pages/event_details_page.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/pages/event_list_page.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/widgets/panchang_card.dart';
import 'package:arjun_guruji/features/Settings/presentation/bloc/settings_bloc.dart';
import 'package:arjun_guruji/features/Settings/presentation/bloc/settings_event.dart';
import 'package:arjun_guruji/features/Settings/presentation/bloc/settings_state.dart';
import 'package:arjun_guruji/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarEventPage extends StatelessWidget {
  const CalendarEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EventBloc>()..add(FetchEvents()),
      child: const _CalendarEventView(),
    );
  }
}

class _CalendarEventView extends StatefulWidget {
  const _CalendarEventView();

  @override
  State<_CalendarEventView> createState() => _CalendarEventViewState();
}

class _CalendarEventViewState extends State<_CalendarEventView> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<EventEntity>> _eventsMap = {};
  List<EventEntity> _selectedEvents = [];

  Color _dotColor(String eventType) {
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

  String _weekdayToString(int weekday) {
    const days = ['', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday];
  }

  void _buildEventsMap(List<EventEntity> events) {
    final map = <DateTime, List<EventEntity>>{};
    for (final event in events) {
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
    _selectedEvents = _getEventsForDay(_selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, eventState) {
        final events = eventState is EventsLoaded ? eventState.events : <EventEntity>[];
        if (eventState is EventsLoaded) {
          _buildEventsMap(events);
        }

        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            final cityName = settingsState.settings.panchangCity;
            final panchangInfo = PanchangService.getForDate(_selectedDay, cityName);
            final supportedCities = PanchangService.supportedCities;

            return Scaffold(
              appBar: GradientAppBar(title: 'Events & Calendar'),
              body: GradientBackground(
                child: eventState is EventsLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: () async {
                          final bloc = context.read<EventBloc>();
                          bloc.add(FetchEvents());
                          await bloc.stream.firstWhere(
                              (s) => s is EventsLoaded || s is EventsError);
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TableCalendar<EventEntity>(
                                firstDay: DateTime.utc(2020, 1, 1),
                                lastDay: DateTime.utc(2030, 12, 31),
                                focusedDay: _focusedDay,
                                selectedDayPredicate: (day) =>
                                    isSameDay(_selectedDay, day),
                                eventLoader: _getEventsForDay,
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay = focusedDay;
                                    _selectedEvents =
                                        _getEventsForDay(selectedDay);
                                  });
                                },
                                calendarBuilders: CalendarBuilders(
                                  markerBuilder: (context, date, dayEvents) {
                                    if (dayEvents.isEmpty) return const SizedBox();
                                    return Positioned(
                                      bottom: 1,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: dayEvents.take(3).map((e) {
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 1),
                                            width: 7,
                                            height: 7,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _dotColor(e.eventType),
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
                                  formatButtonVisible: false,
                                  titleTextStyle: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  leftChevronIcon: Icon(Icons.chevron_left,
                                      color: Colors.white),
                                  rightChevronIcon: Icon(Icons.chevron_right,
                                      color: Colors.white),
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
                                  defaultTextStyle:
                                      TextStyle(color: Colors.white),
                                  weekendTextStyle:
                                      TextStyle(color: Colors.white70),
                                  outsideTextStyle:
                                      TextStyle(color: Colors.white38),
                                ),
                              ),
                              PanchangCard(
                                info: panchangInfo,
                                cityName: cityName,
                                availableCities: supportedCities,
                                onCityChanged: (city) {
                                  context
                                      .read<SettingsBloc>()
                                      .add(UpdatePanchangCity(city));
                                },
                              ),
                              _EventsForDay(
                                selectedDay: _selectedDay,
                                events: _selectedEvents,
                                allEvents: events,
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
              ),
            );
          },
        );
      },
    );
  }
}

class _EventsForDay extends StatelessWidget {
  final DateTime selectedDay;
  final List<EventEntity> events;
  final List<EventEntity> allEvents;

  const _EventsForDay({
    required this.selectedDay,
    required this.events,
    required this.allEvents,
  });

  String _formattedDay() {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${selectedDay.day} ${months[selectedDay.month]}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Events — ${_formattedDay()}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (events.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'No events for this day',
                style: TextStyle(color: Colors.white60, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            )
          else
            ...events.map((event) => _EventDayTile(event: event)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.list_alt, color: Colors.white),
              label: const Text('View All Events',
                  style: TextStyle(color: Colors.white)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white38),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EventListPage()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventDayTile extends StatelessWidget {
  final EventEntity event;

  const _EventDayTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EventDetailsPage(event: event),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.09),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _dotColor(event.eventType),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    event.venue,
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white38, size: 20),
          ],
        ),
      ),
    );
  }

  Color _dotColor(String eventType) {
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
}
