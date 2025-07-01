import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/EventManagement/data/model/events_model.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/activity.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/widgets/featured_events_carousel.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/widgets/past_events_list.dart';
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
      rsvpCount: 50,
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
      rsvpCount: 20,
    );

    // Create a simple event for Datta Jayanti, Mysuru (One-day event)
    EventModel simpleEvent = EventModel(
        title: "Datta Jayanti",
        eventType: "Simple",
        startDate: DateTime(2025, 04, 25),
        endDate: DateTime(2025, 04, 27),
        venue: "Venue 2",
        city: "Mysuru",
        place: "Ashrama",
        description:
            "ಅಶ್ರಮದಲ್ಲಿ ದತ್ತ ಜಯಂತಿಯನ್ನು ಭಕ್ತಿ ಮತ್ತು ಹರ್ಷದಿಂದ ಆಚರಿಸಲಾಗುತ್ತದೆ. ವಿಶೇಷ ಪೂಜೆಗಳು, ಭಜನೆಗಳು ಮತ್ತು ಸತ್ಸಂಗಗಳು ನಡೆಯಲಿವೆ. ಪೂಜೆಯ ನಂತರ ಪ್ರಸಾದ ವಿತರಣೆ ಮಾಡಲಾಗುತ್ತದೆ. ಎಲ್ಲರಿಗೂ ಭಾಗವಹಿಸಲು ಆಹ್ವಾನ.",
        interestedCount: 0,
        galleryLinks: [],
        status: "Upcoming",
        rsvp: false,
        rsvpCount: 532,
        isFeatured: true);

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
      startDate: DateTime(2024, 11, 10),
      endDate: DateTime(2024, 11, 18),
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
// Create a simple event for Datta Jayanti, Mysuru (One-day event)
    EventModel simpleEvent2 = EventModel(
        title: "Datta Jayanti 2",
        eventType: "Simple",
        startDate: DateTime(2024, 04, 25),
        endDate: DateTime(2024, 04, 27),
        venue: "Venue 2",
        city: "Mysuru",
        place: "Ashrama",
        description:
            "ಅಶ್ರಮದಲ್ಲಿ ದತ್ತ ಜಯಂತಿಯನ್ನು ಭಕ್ತಿ ಮತ್ತು ಹರ್ಷದಿಂದ ಆಚರಿಸಲಾಗುತ್ತದೆ. ವಿಶೇಷ ಪೂಜೆಗಳು, ಭಜನೆಗಳು ಮತ್ತು ಸತ್ಸಂಗಗಳು ನಡೆಯಲಿವೆ. ಪೂಜೆಯ ನಂತರ ಪ್ರಸಾದ ವಿತರಣೆ ಮಾಡಲಾಗುತ್ತದೆ. ಎಲ್ಲರಿಗೂ ಭಾಗವಹಿಸಲು ಆಹ್ವಾನ.",
        interestedCount: 0,
        galleryLinks: [],
        status: "Upcoming",
        rsvp: false,
        rsvpCount: 532,
        isFeatured: true);
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
      simpleEvent2
    ];

    List<EventEntity> featuredAndRecurringEvents = events.where((event) {
      return event.eventType == "Recurring" || event.isFeatured;
    }).toList();

// Sort the list: First by isFeatured (true first), then by eventType ("Recurring" events)
    featuredAndRecurringEvents.sort((a, b) {
      if (a.isFeatured && !b.isFeatured) {
        return -1; // a comes first if a is featured
      } else if (!a.isFeatured && b.isFeatured) {
        return 1; // b comes first if b is featured
      } else {
        // If both are either featured or recurring, sort by eventType
        return a.eventType == "Recurring" ? -1 : 1;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // TODO: Navigate to Calendar Page
            },
          ),
        ],
      ),
      body: GradientBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FeaturedEventsCarousel(events: featuredAndRecurringEvents),
            const SizedBox(height: 16),
            PastEventsList(events: events),
          ],
        ),
      ),
    );
  }
}
