import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/instant_relief_tools/breathing_page.dart';
import '../pages/instant_relief_tools/stretching_page.dart';
import '../pages/instant_relief_tools/relaxation_page.dart';
import '../pages/calendar_page.dart';
import 'no_transition_page_route.dart';
import '../pages/hotlines_page.dart';


class AppRoutes {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return NoTransitionPageRoute(builder: (_) => const HomePage(), settings: settings);
      case '/breathing':
        return NoTransitionPageRoute(builder: (_) => const BreathingPage(), settings: settings);
      case '/stretching':
        return NoTransitionPageRoute(builder: (_) => const StretchingPage(), settings: settings);
      case '/relaxation':
        return NoTransitionPageRoute(builder: (_) => const RelaxationPage(), settings: settings);
      case '/calendar':
        return NoTransitionPageRoute(builder: (_) => const CalendarPage(), settings: settings);
      case '/hotlines':
        return NoTransitionPageRoute(builder: (_) => const HotlinesPage(), settings: settings);
      default:
        return NoTransitionPageRoute(builder: (_) => const HomePage(), settings: settings);
    }
  }
}
