import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omninexus_app/main.dart';

// Using absolute imports based on your pubspec.yaml name
import 'package:omninexus_app/screens/splash_screen.dart';
import 'package:omninexus_app/screens/logs_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    // Added an errorBuilder just in case a route fails during your recording
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/nexus',
        name: 'nexus',
        builder: (context, state) => ChatScreen(),
      ),
      GoRoute(
        path: '/logs',
        name: 'logs',
        builder: (context, state) => LogsScreen(),
      ),
    ],
  );
}
