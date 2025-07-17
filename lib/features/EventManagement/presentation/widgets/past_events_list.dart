import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/pages/event_details_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PastEventsList extends StatelessWidget {
  final List<EventEntity> events;
  final Box interestedBox;

  const PastEventsList({super.key, required this.events, required this.interestedBox});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Get major past events (featured events that are in the past)
    final majorPastEvents = events.where((e) =>
      e.isFeatured && 
      e.eventType != 'Recurring' &&
      e.startDate.isBefore(today)
    ).toList();
    
    // Get all previous weeks events (events that ended more than 7 days ago)
    final previousWeeksEvents = events.where((e) =>
      e.endDate.isBefore(today.subtract(const Duration(days: 7)))
    ).toList();
    
    // Combine and remove duplicates
    final allPastEvents = <EventEntity>{};
    allPastEvents.addAll(majorPastEvents);
    allPastEvents.addAll(previousWeeksEvents);
    
    final pastEvents = allPastEvents.toList();
    pastEvents.sort((a, b) => b.startDate.compareTo(a.startDate)); // Sort by date descending

    if (pastEvents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("Will be updated",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Events',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pastEvents.length,
          itemBuilder: (context, index) {
            final event = pastEvents[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${event.startDate.toLocal()}".split(' ')[0],
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.venue,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Handle view details action
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EventDetailsPage(event: event),
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
                    const SizedBox(width: 8),
                    Icon(
                      interestedBox.get(event.id, defaultValue: false)
                          ? Icons.thumb_up_alt
                          : Icons.thumb_up_alt_outlined,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.people, size: 18, color: Colors.black54),
                        const SizedBox(width: 6),
                        Text(
                          "${event.interestedCount} Interested",
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
