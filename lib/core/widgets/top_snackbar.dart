import 'package:flutter/material.dart';

class TopSnackbar {
  static void show({
    BuildContext? context,
    OverlayState? overlayState,
    required String message,
    required Color backgroundColor,
  }) {
    // Get the OverlayState
    final activeOverlayState = overlayState ?? (context != null ? Overlay.of(context) : null);
    if (activeOverlayState == null) return;

    // Declare the OverlayEntry variable
    late OverlayEntry overlayEntry;

    // Create an OverlayEntry
    overlayEntry = OverlayEntry(
      builder: (context) => TopSnackbarWidget(
        message: message,
        backgroundColor: backgroundColor,
        onDismissed: () {
          overlayEntry.remove(); // Remove the overlay when dismissed
        },
      ),
    );

    // Insert the OverlayEntry
    activeOverlayState.insert(overlayEntry);

    // Automatically dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}

class TopSnackbarWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final VoidCallback onDismissed;

  const TopSnackbarWidget({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.onDismissed,
  });

  @override
  TopSnackbarWidgetState createState() => TopSnackbarWidgetState();
}

class TopSnackbarWidgetState extends State<TopSnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Define the slide animation
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0), // Start from the top
      end: Offset.zero, // Slide down to the normal position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            color: widget.backgroundColor,
            child: SafeArea(
              bottom: false,
              child: Text(
                widget.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
