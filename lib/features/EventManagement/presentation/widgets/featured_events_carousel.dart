import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:flutter/material.dart';
import 'featured_event_card.dart';

class FeaturedEventsCarousel extends StatelessWidget {
  final List<EventEntity> events;

  const FeaturedEventsCarousel({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return FeaturedEventCard(event: events[index]);
        },
      ),
    );
  }
}
