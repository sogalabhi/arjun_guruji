import 'package:arjun_guruji/core/widgets/top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
      if (result == ConnectivityResult.none) {
        // No internet
        TopSnackbar.show(
          context: context,
          message: 'No Internet Connection',
          backgroundColor: Colors.red,
        );
      } else {
        // Internet connected
        TopSnackbar.show(
          context: context,
          message: 'Internet Connected',
          backgroundColor: Colors.green,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}