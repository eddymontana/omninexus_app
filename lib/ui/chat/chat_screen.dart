import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 
import '../../../services/ai_orchestrator.dart'; 
import 'widgets/glass_bubble.dart';

/* NOTE: If you see a red error on go_router, run this in your terminal:
  flutter pub add go_router
*/

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // AI Orchestrator with your specific keys
  final AIOrchestrator _orchestrator = AIOrchestrator(
    apiKey: 'AIzaSyD5smAptl2HT9G4LvVHjgSJxBQoCqRVdjs',
    webhookUrl: 'https://hook.eu2.make.com/mbp68qiwznuwewmpmpiva7nhi4b1ma4v',
  );

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSend() async {
    if (_controller.text.isEmpty) return;

    final userMessage = _controller.text;
    setState(() {
      _messages.add({'role': 'user', 'text': userMessage});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      // Calling the updated AI Orchestrator that bypasses protocol errors
      final response = await _orchestrator.sendMessage(userMessage);
      setState(() {
        _messages.add({'role': 'nexus', 'text': response});
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'error', 'text': 'Orchestration Error: $e'});
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    // It's good practice to dispose the orchestrator too if it has an internal client
    _orchestrator.dispose(); 
    super.dispose();
  }

  void _clearChat() {
    setState(() => _messages.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "O M N I N E X U S", 
          style: TextStyle(
            letterSpacing: 2, 
            fontWeight: FontWeight.bold, 
            color: Colors.cyan
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // go_router navigation
        leading: IconButton(
          icon: const Icon(Icons.history, color: Colors.cyan),
          onPressed: () => context.push('/logs'), 
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.cyan),
            onPressed: _clearChat,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                return GlassBubble(
                  text: m['text']!,
                  isUser: m['role'] == 'user',
                );
              },
            ),
          ),
          if (_isLoading) 
            const LinearProgressIndicator(
              color: Colors.cyan, 
              backgroundColor: Colors.black
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.cyan.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _handleSend(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Issue command...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.cyan.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.cyan),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _handleSend,
            mini: true,
            backgroundColor: Colors.cyan,
            child: const Icon(Icons.bolt, color: Colors.black),
          ),
        ],
      ),
    );
  }
}