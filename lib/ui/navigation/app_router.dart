import 'package:flutter/material.dart';
import 'package:flutter_winddown/ui/screens/landing_screen.dart';
import 'package:flutter_winddown/ui/screens/reflection_screen.dart';
import 'package:flutter_winddown/ui/screens/summary_screen.dart';
import 'package:flutter_winddown/ui/screens/settings_screen.dart';

class AppRouter {
  static const String landing = '/';
  static const String reflection = '/reflection';
  static const String summary = '/summary';
  static const String settings = '/settings';
  
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final routeName = routeSettings.name;
    if (routeName == landing) {
      return MaterialPageRoute(builder: (_) => const LandingScreen());
    } else if (routeName == reflection) {
      return MaterialPageRoute(builder: (_) => const ReflectionScreen());
    } else if (routeName == summary) {
      return MaterialPageRoute(builder: (_) => const SummaryScreen());
    } else if (routeName == settings) {
      return MaterialPageRoute(builder: (_) => const SettingsScreen());
    } else {
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${routeSettings.name}'),
          ),
        ),
      );
    }
  }
}

