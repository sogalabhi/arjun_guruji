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

  @override
  void initState() {
    super.initState();
    _listenForConnectivityChanges();
  }

  void _listenForConnectivityChanges() {
    _connectivity.onConnectivityChanged.listen((result) {
      final online = result.isNotEmpty && result.first != ConnectivityResult.none;
      ConnectivityService.isOnline.value = online;
      final overlayState = ConnectivityService.navigatorKey.currentState?.overlay;
      if (overlayState != null) {
        if (!online) {
          // No internet
          TopSnackbar.show(
            overlayState: overlayState,
            message: 'No Internet Connection',
            backgroundColor: Colors.red,
          );
        } else {
          // Internet connected
          TopSnackbar.show(
            overlayState: overlayState,
            message: 'Internet Connected',
            backgroundColor: Colors.green,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
