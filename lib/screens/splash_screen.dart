import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    // Navigate to Nexus after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/nexus');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bolt, size: 80, color: Colors.cyan),
              const SizedBox(height: 20),
              const Text(
                "O M N I N E X U S",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "AGENTIC AI ORCHESTRATOR",
                style: TextStyle(
                  color: Colors.cyan.withOpacity(0.6),
                  fontSize: 12,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}