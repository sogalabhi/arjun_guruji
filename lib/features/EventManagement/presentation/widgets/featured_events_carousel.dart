import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:flutter/material.dart';
import 'featured_event_card.dart';
import 'package:hive/hive.dart';

class FeaturedEventsCarousel extends StatefulWidget {
  final List<EventEntity> events;
  final Box interestedBox;

  const FeaturedEventsCarousel(
      {super.key, required this.events, required this.interestedBox});

  @override
  _FeaturedEventsCarouselState createState() => _FeaturedEventsCarouselState();
}

class _FeaturedEventsCarouselState extends State<FeaturedEventsCarousel> {
  late final PageController _controller;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _controller = PageController();
    if (widget.events.length > 1) {
      Future.delayed(Duration.zero, _startAutoScroll);
    }
  }

  void _startAutoScroll() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return false;
      if (widget.events.length <= 1) return false;
      _currentPage = (_currentPage + 1) % widget.events.length;
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      return mounted;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.events.length,
        onPageChanged: (index) => _currentPage = index,
        itemBuilder: (context, index) {
          return FeaturedEventCard(
              event: widget.events[index], interestedBox: widget.interestedBox);
        },
      ),
    );
  }
}
