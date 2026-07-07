import 'package:flutter/material.dart';

class ConnectivityService {
  static final ValueNotifier<bool> isOnline = ValueNotifier(true);
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
