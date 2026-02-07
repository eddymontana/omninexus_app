import 'package:go_router/go_router.dart';
import '../screens/chat_screen.dart'; 
import '../screens/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/', // Start at the Splash Screen
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/nexus',
        name: 'nexus',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/logs',
        builder: (context, state) => const LogsScreen(),
      ),
    ],
  );
}