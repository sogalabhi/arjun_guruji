import 'package:arjun_guruji/features/EventManagement/data/model/events_model.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/activity.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/widgets/event_card.dart';
import 'package:flutter/material.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded list of events

    EventModel recurringEvent1 = EventModel(
      title: "Sai Baba Arti",
      eventType: "Recurring",
      startDate: DateTime(2025, 4, 13),
      endDate: DateTime(2025, 12, 31),
      venue: "Gurunivasa",
      city: "Mysuru",
      place: "Gurunivasa",
      frequency: "weekly",
      day: "Thursday",
      description: "Weekly Sai Baba Arti every Thursday",
      interestedCount: 0,
      galleryLinks: [],
      status: "Upcoming",
      rsvp: false,
      rsvpCount: 0,
    );

    // Create a recurring event for Arti in Venue 2, Bengaluru (Weekly Monday)
    EventModel recurringEvent2 = EventModel(
      title: "Arti in Venue 2",
      eventType: "Recurring",
      startDate: DateTime(2025, 4, 13),
      endDate: DateTime(2025, 12, 31),
      venue: "Venue 2",
      city: "Bengaluru",
      place: "Venue 2",
      frequency: "weekly",
      day: "Monday",
      description: "Weekly Arti every Monday",
      interestedCount: 0,
      galleryLinks: [],
      status: "Upcoming",
      rsvp: false,
      rsvpCount: 0,
    );

    // Create a simple event for Datta Jayanti, Mysuru (One-day event)
    EventModel simpleEvent = EventModel(
      title: "Datta Jayanti",
      eventType: "Simple",
      startDate: DateTime(2025, 12, 20),
      endDate: DateTime(2025, 12, 20),
      venue: "Venue 2",
      city: "Mysuru",
      place: "Ashrama",
      description: "Datta Jayanti celebration at Ashrama",
      interestedCount: 0,
      galleryLinks: [],
      status: "Upcoming",
      rsvp: false,
      rsvpCount: 0,
    );

    // Create a nested event for Navaratri Celebrations (Nov 10-18, 2025)
    List<ActivityEntity> navaratriActivities = [];
    for (int i = 0; i < 9; i++) {
      navaratriActivities.add(ActivityEntity(
        time: "Morning",
        activity: "Homa",
        venue: "Ashrama, Mysuru",
      ));
      navaratriActivities.add(ActivityEntity(
        time: "Evening",
        activity: "Bhajans",
        venue: "Gurunivasa, Mysuru",
      ));
    }

    EventModel nestedEvent = EventModel(
      title: "Navaratri Celebrations",
      eventType: "Nested",
      startDate: DateTime(2025, 11, 10),
      endDate: DateTime(2025, 11, 18),
      venue: "Ashrama, Mysuru",
      city: "Mysuru",
      place: "Ashrama, Mysuru",
      activities: navaratriActivities,
      description: "9 Days of Navaratri Celebrations with Homa and Bhajans",
      interestedCount: 0,
      galleryLinks: [],
      status: "Upcoming",
      rsvp: false,
      rsvpCount: 0,
    );

    // Create a non-trust event with Guruji as a guest (at Sringeri Mutt, Shimoga)
    EventModel nonTrustEvent = EventModel(
      title: "Guruji Visit",
      eventType: "Non-Trust",
      startDate: DateTime(2025, 12, 1),
      endDate: DateTime(2025, 12, 1),
      venue: "Sringeri Mutt",
      city: "Shimoga",
      place: "Sringeri Mutt",
      guest: "Guruji",
      description: "Guruji is visiting Sringeri Mutt",
      interestedCount: 0,
      galleryLinks: [],
      status: "Upcoming",
      rsvp: false,
      rsvpCount: 0,
    );
    List<EventEntity> events = [
      recurringEvent1,
      recurringEvent2,
      simpleEvent,
      nestedEvent,
      nonTrustEvent,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              // Navigate to calendar page or show calendar popup
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Button (Placeholder for now)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Filter logic goes here
              },
              child: Text('Filter Events'),
            ),
          ),
          // EventModel List
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return EventCard(event: events[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
