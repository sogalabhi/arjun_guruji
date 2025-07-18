import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/pages/event_details_page.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final EventEntity event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to EventDetailsPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsPage(event: event),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              // Image placeholder for event
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300], // Placeholder color
                ),
                child: Icon(Icons.event, size: 40, color: Colors.white),
              ),
              SizedBox(width: 10),
              // Event Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      event.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 10),
                    Text(
                      event.eventType == "Recurring" && event.day != null && event.frequency == "weekly"
                        ? "Every ${event.day!}"
                        : '${event.startDate.toLocal()} - ${event.endDate.toLocal()}',
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    SizedBox(height: 5),
                    Text(
                      event.venue,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              // Thumbs up icon for interested users
              IconButton(
                icon: Icon(
                  Icons.thumb_up_alt_outlined,
                  color: event.interestedCount > 0 ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  // Handle interested count
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
