import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:flutter/material.dart';
import 'featured_event_card.dart';
import 'package:hive/hive.dart';

class FeaturedEventsCarousel extends StatelessWidget {
  final List<EventEntity> events;
  final Box interestedBox;

  const FeaturedEventsCarousel({super.key, required this.events, required this.interestedBox});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return FeaturedEventCard(event: events[index], interestedBox: interestedBox);
        },
      ),
    );
  }
}
