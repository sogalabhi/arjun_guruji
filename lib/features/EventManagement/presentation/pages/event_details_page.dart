import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/bloc/event_bloc.dart';
import 'package:hive/hive.dart';
import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';
import 'package:arjun_guruji/features/Gallery/presentation/pages/full_page_viewer_page.dart';

class EventDetailsPage extends StatelessWidget {
  final EventEntity event;

  const EventDetailsPage({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EventBloc()..add(CheckInterestedStatus(event.id)),
      child: _EventDetailsView(event: event),
    );
  }
}

class _EventDetailsView extends StatefulWidget {
  final EventEntity event;
  const _EventDetailsView({required this.event});

  @override
  State<_EventDetailsView> createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends State<_EventDetailsView> {
  bool _pressed = false;
  bool _popAnim = false; // For pop animation
  late Box interestedBox;

  @override
  void initState() {
    super.initState();
    interestedBox = Hive.box('interestedBox');
    _pressed = interestedBox.get(widget.event.id, defaultValue: false);
  }

  void _onLikePressed(BuildContext context) async {
    setState(() {
      _popAnim = true;
    });
    await Future.delayed(const Duration(milliseconds: 150));
    setState(() {
      _popAnim = false;
      _pressed = true;
      interestedBox.put(widget.event.id, true);
    });
    context.read<EventBloc>().add(ToggleInterested(widget.event.id, true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: widget.event.title,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final imageUrl = widget.event.galleryLinks.isNotEmpty
                  ? widget.event.galleryLinks.first
                  : null;
              final text =
                  '${widget.event.title}\n\n${widget.event.description}';
              if (imageUrl != null && imageUrl.isNotEmpty) {
                await Share.share('$text\n\n$imageUrl');
              } else {
                await Share.share(text);
              }
            },
          ),
        ],
      ),
      body: BlocListener<EventBloc, EventState>(
        listener: (context, state) {
          if (state is InterestedCountState) {
            setState(() {}); // Triggers rebuild to update count
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.event.galleryLinks.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImageViewer(
                          imageUrls: widget.event.galleryLinks,
                          initialIndex: 0,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 250,
                        child: ImageWithShimmer(
                            url: widget.event.galleryLinks.first),
                      ),
                      // Subtle overlay to indicate tappable
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.grey[300],
                  child: const Icon(Icons.event, size: 100, color: Colors.grey),
                ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.event.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    BlocBuilder<EventBloc, EventState>(
                      builder: (context, state) {
                        int count = widget.event.interestedCount;
                        if (state is InterestedCountState) {
                          count = state.count;
                        }
                        return Row(
                          children: [
                            AnimatedScale(
                              scale: _popAnim ? 1.3 : 1.0,
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeOut,
                              child: IconButton(
                                icon: Icon(
                                  _pressed
                                      ? Icons.thumb_up_alt
                                      : Icons.thumb_up_alt_outlined,
                                  color: Colors.amber,
                                  size: 32,
                                ),
                                onPressed: _pressed
                                    ? null
                                    : () => _onLikePressed(context),
                              ),
                            ),
                            Text('$count'),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.event.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 20, color: Colors.black54),
                    const SizedBox(width: 8),
                    Text(
                      widget.event.eventType == "Recurring" &&
                              widget.event.day != null &&
                              widget.event.frequency == "weekly"
                          ? "Every ${widget.event.day!}"
                          : _getFormattedDateRange(
                              widget.event.startDate, widget.event.endDate),
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 20, color: Colors.black54),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.event.venue,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (widget.event.galleryLinks.length > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.event.galleryLinks.length - 1,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final imgUrl = widget.event.galleryLinks[index + 1];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FullScreenImageViewer(
                                        imageUrls: widget.event.galleryLinks,
                                        initialIndex: index + 1,
                                      ),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Image.network(
                                      imgUrl,
                                      width: 120,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        width: 120,
                                        height: 100,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image,
                                            size: 40, color: Colors.grey),
                                      ),
                                    ),
                                    // Subtle overlay to indicate tappable
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.black.withOpacity(0.1),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.fullscreen,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _getFormattedDateRange(DateTime start, DateTime end) {
    final startStr = "${start.day}/${start.month}/${start.year}";
    final endStr = "${end.day}/${end.month}/${end.year}";
    return startStr == endStr ? startStr : "$startStr - $endStr";
  }
}

// Helper widget for shimmer effect on image
class ImageWithShimmer extends StatelessWidget {
  final String url;
  const ImageWithShimmer({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 250,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 250,
            color: Colors.white,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        width: double.infinity,
        height: 250,
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, size: 100, color: Colors.grey),
      ),
    );
  }
}
