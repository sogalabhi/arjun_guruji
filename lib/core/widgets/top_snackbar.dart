import 'dart:async';

import 'package:arjun_guruji/core/motion/motion.dart';
import 'package:flutter/material.dart';

/// A single pill banner pinned below the status bar.
/// Only one is ever shown: calling [show] again updates the existing pill
/// (colour, icon and text morph in place) instead of stacking another.
class TopSnackbar {
  static OverlayEntry? _entry;
  static GlobalKey<_TopSnackbarPillState>? _pillKey;
  static Timer? _timer;
  static final ValueNotifier<_BannerData> _data =
      ValueNotifier(const _BannerData('', Colors.grey, Icons.info_outline));

  /// Shows (or updates) the banner. Pass [autoDismiss] null to keep it
  /// visible until [dismiss] is called.
  static void show({
    BuildContext? context,
    OverlayState? overlayState,
    required String message,
    required Color backgroundColor,
    IconData icon = Icons.info_outline,
    Duration? autoDismiss = const Duration(seconds: 3),
  }) {
    _timer?.cancel();
    _timer = null;

    if (_entry != null) {
      // Update the existing pill; if it was on its way out, bring it back.
      _data.value = _BannerData(message, backgroundColor, icon);
      _pillKey?.currentState?.show();
    } else {
      final activeOverlayState =
          overlayState ?? (context != null ? Overlay.of(context) : null);
      if (activeOverlayState == null) return;

      _data.value = _BannerData(message, backgroundColor, icon);
      final key = GlobalKey<_TopSnackbarPillState>();
      _pillKey = key;
      _entry = OverlayEntry(
        builder: (_) => _TopSnackbarPill(
          key: key,
          data: _data,
          onHidden: _remove,
        ),
      );
      activeOverlayState.insert(_entry!);
    }

    if (autoDismiss != null) {
      _timer = Timer(autoDismiss, dismiss);
    }
  }

  /// Slides the banner out; it is removed from the overlay once hidden.
  static void dismiss() {
    _timer?.cancel();
    _timer = null;
    _pillKey?.currentState?.hide();
  }

  static void _remove() {
    _entry?.remove();
    _entry = null;
    _pillKey = null;
  }
}

class _BannerData {
  final String message;
  final Color color;
  final IconData icon;

  const _BannerData(this.message, this.color, this.icon);
}

class _TopSnackbarPill extends StatefulWidget {
  final ValueNotifier<_BannerData> data;
  final VoidCallback onHidden;

  const _TopSnackbarPill({
    super.key,
    required this.data,
    required this.onHidden,
  });

  @override
  State<_TopSnackbarPill> createState() => _TopSnackbarPillState();
}

class _TopSnackbarPillState extends State<_TopSnackbarPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  bool _hiding = false;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Motion.standard);
    _slide = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: MotionCurves.standard,
    ));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed && _hiding) widget.onHidden();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    show();
  }

  /// Slides/fades in (or jumps in when reduce-motion is on).
  void show() {
    _hiding = false;
    if (Motion.reduced(context)) {
      _controller.value = 1.0;
    } else {
      _controller.forward();
    }
  }

  /// Slides/fades out, then asks the owner to remove the overlay entry.
  void hide() {
    if (_hiding) return;
    _hiding = true;
    if (Motion.reduced(context)) {
      _controller.value = 0.0;
      widget.onHidden();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = Motion.reduced(context);
    final morph = Motion.duration(context, Motion.standard);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      // Purely informational: never block touches underneath.
      child: IgnorePointer(
        child: SlideTransition(
          position: reduced
              ? const AlwaysStoppedAnimation<Offset>(Offset.zero)
              : _slide,
          child: FadeTransition(
            opacity: _controller,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.paddingOf(context).top + 8,
                16,
                0,
              ),
              child: Center(
                child: ValueListenableBuilder<_BannerData>(
                  valueListenable: widget.data,
                  builder: (context, data, _) {
                    return Semantics(
                      liveRegion: true,
                      child: Material(
                        type: MaterialType.transparency,
                        child: AnimatedContainer(
                          duration: morph,
                          curve: MotionCurves.standard,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: data.color,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33000000),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: AnimatedSize(
                            duration: morph,
                            curve: MotionCurves.standard,
                            child: AnimatedSwitcher(
                              duration: morph,
                              child: Row(
                                key: ValueKey(data.message),
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(data.icon, color: Colors.white, size: 24),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      data.message,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
