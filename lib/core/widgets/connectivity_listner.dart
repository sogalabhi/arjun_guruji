import 'package:arjun_guruji/core/widgets/top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:arjun_guruji/core/services/connectivity_service.dart';

class ConnectivityListener extends StatefulWidget {
  final Widget child;

  const ConnectivityListener({super.key, required this.child});

  @override
  ConnectivityListenerState createState() => ConnectivityListenerState();
}

class ConnectivityListenerState extends State<ConnectivityListener> {
  final Connectivity _connectivity = Connectivity();
  bool? _wasOnline;

  @override
  void initState() {
    super.initState();
    _listenForConnectivityChanges();
  }

  void _listenForConnectivityChanges() {
    _connectivity.onConnectivityChanged.listen((result) {
      final online = result.isNotEmpty && result.first != ConnectivityResult.none;
      ConnectivityService.isOnline.value = online;
      
      // If this is the initial event on app load, just save the status and do not show snackbar.
      if (_wasOnline == null) {
        _wasOnline = online;
        return;
      }

      // Show snackbar only if the status actually changed
      if (online != _wasOnline) {
        _wasOnline = online;
        final overlayState = ConnectivityService.navigatorKey.currentState?.overlay;
        if (overlayState != null) {
          if (!online) {
            // No internet: stay visible until connectivity returns.
            TopSnackbar.show(
              overlayState: overlayState,
              message: 'No internet connection',
              backgroundColor: Colors.red.shade700,
              icon: Icons.wifi_off,
              autoDismiss: null,
            );
          } else {
            // Back online: the same pill turns green, then slides away.
            TopSnackbar.show(
              overlayState: overlayState,
              message: 'Back online',
              backgroundColor: Colors.green.shade800,
              icon: Icons.check_circle,
              autoDismiss: const Duration(seconds: 2),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
