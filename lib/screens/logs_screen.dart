import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  // For the hackathon demo, you can hardcode a few logs or 
  // connect this to a GET request from your Google Sheet/Make.com
  final List<Map<String, String>> mockLogs = const [
    {'content': 'Database latency fix', 'priority': 'High', 'timestamp': '2026-02-07'},
    {'content': 'UI Glassmorphism update', 'priority': 'Medium', 'timestamp': '2026-02-06'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("P R O J E C T  L O G S", style: TextStyle(color: Colors.cyan, letterSpacing: 2)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.cyan),
          onPressed: () => context.go('/nexus'),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockLogs.length,
        itemBuilder: (context, index) {
          final log = mockLogs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: _getPriorityColor(log['priority']!).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.assignment, color: _getPriorityColor(log['priority']!)),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(log['content']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(log['timestamp']!, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                    ],
                  ),
                ),
                _buildPriorityBadge(log['priority']!),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getPriorityColor(String p) {
    if (p == 'High') return Colors.redAccent;
    if (p == 'Medium') return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  Widget _buildPriorityBadge(String p) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPriorityColor(p).withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(p, style: TextStyle(color: _getPriorityColor(p), fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}