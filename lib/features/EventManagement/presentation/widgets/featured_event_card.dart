import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/pages/event_details_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FeaturedEventCard extends StatelessWidget {
  final EventEntity event;
  final Box interestedBox;

  const FeaturedEventCard({super.key, required this.event, required this.interestedBox});

  bool get isLive {
    final now = DateTime.now();
    return (event.startDate.isBefore(now) ||
            event.startDate.isAtSameMomentAs(now)) &&
        (event.endDate.isAfter(now) || event.endDate.isAtSameMomentAs(now)) &&
        (event.eventType != "Recurring");
  }

  String getFormattedDateRange() {
    if (event.eventType == "Recurring" && event.day != null && event.frequency == "weekly") {
      return "Every "+event.day!;
    }
    final start = "${event.startDate.day}/${event.startDate.month}/${event.startDate.year}";
    final end = "${event.endDate.day}/${event.endDate.month}/${event.endDate.year}";
    return start == end ? start : "$start - $end";
  }

  // Helper method to get the next occurrence date for recurring events
  DateTime? _getNextOccurrenceDate() {
    if (event.eventType != "Recurring" || event.day == null || event.frequency != "weekly") {
      return null;
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventStart = DateTime(event.startDate.year, event.startDate.month, event.startDate.day);
    final eventEnd = DateTime(event.endDate.year, event.endDate.month, event.endDate.day);
    final targetWeekday = _dayStringToWeekday(event.day!);
    final currentWeekday = today.weekday;
    // If today is the event day and within the event's date range, return today
    if (currentWeekday == targetWeekday && !today.isBefore(eventStart) && !today.isAfter(eventEnd)) {
      return today;
    }
    int daysToAdd = targetWeekday - currentWeekday;
    if (daysToAdd <= 0) {
      daysToAdd += 7; // Move to next week
    }
    final nextOccurrence = today.add(Duration(days: daysToAdd));
    // Check if this occurrence is within the event's date range
    if (nextOccurrence.isAfter(eventEnd)) {
      return null; // No future occurrences
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

  @override
  Widget build(BuildContext context) {
    
    print("event: ${event.galleryLinks}");
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage('assets/img12.jpg'),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Stack(

        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                event.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 18, color: Colors.black54),
                  const SizedBox(width: 6),
                  Text(
                    getFormattedDateRange(),
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 18, color: Colors.black54),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      event.venue,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.people, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "${event.interestedCount} Interested",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    interestedBox.get(event.id, defaultValue: false)
                        ? Icons.thumb_up_alt
                        : Icons.thumb_up_alt_outlined,
                    color: Colors.amber,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailsPage(event: event),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          if (isLive)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
