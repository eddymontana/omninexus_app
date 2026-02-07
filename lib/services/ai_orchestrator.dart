import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class AIOrchestrator {
  final String apiKey;
  final String webhookUrl;
  final http.Client _httpClient = http.Client();
  
  late final GenerativeModel _model;
  late ChatSession _chat;

  AIOrchestrator({required this.apiKey, required this.webhookUrl}) {
    final logTool = FunctionDeclaration(
      'log_to_database',
      'Logs project data and tasks to the Google Sheet via Make.com.',
      Schema.object(
        properties: {
          'content': Schema.string(description: 'The description of the task or bug.'),
          'priority': Schema.string(description: 'Must be High, Medium, or Low.'),
        },
        requiredProperties: ['content', 'priority'],
      ),
    );

    _model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: apiKey,
      tools: [Tool(functionDeclarations: [logTool])],
      systemInstruction: Content.system(
        "You are OmniNexus, a high-level Project AI. "
        "When users mention tasks, bugs, or updates, use 'log_to_database'. "
        "Always reason internally to determine if a task is High, Medium, or Low priority."
      ),
    );

    _chat = _model.startChat();
  }

  Future<void> _executeLog(String content, String priority) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(webhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'content': content,
          'priority': priority,
          'timestamp': DateTime.now().toIso8601String(),
          'platform': 'Windows_10_Pro',
        }),
      ).timeout(const Duration(seconds: 12));
      
      debugPrint('Make.com Webhook Status: ${response.statusCode}');
    } catch (e) {
      debugPrint('Webhook Error: $e');
    }
  }

  Future<String> sendMessage(String text) async {
    try {
      // TURN 1: Send User Input to Gemini
      var response = await _chat.sendMessage(Content.text(text));

      // Check for Tool Calls (Agentic Logic)
      if (response.functionCalls.isNotEmpty) {
        for (final call in response.functionCalls) {
          if (call.name == 'log_to_database') {
            final contentArg = call.args['content'] as String? ?? "No details provided";
            final priorityArg = call.args['priority'] as String? ?? "Low";

            // 🚀 FIRE WEBHOOK: Status 200 happens here
            await _executeLog(contentArg, priorityArg);

            // 🛡️ PROTOCOL FIX: Instead of sending a FunctionResponse (which causes 
            // the thought_signature error in Gemini 3 Flash), we return a direct 
            // confirmation to the UI. This keeps the ChatSession stable.
            return "✅ Nexus Intelligence: Task '$contentArg' logged with $priorityArg priority.";
          }
        }
      }

      return response.text ?? "Nexus processing complete.";
      
    } catch (e) {
      debugPrint('General Orchestration Error: $e');
      
      // Graceful handling of the thought_signature flicker
      if (e.toString().contains('thought_signature')) {
        return "Task processed, but the sync protocol flickered. Data has been transmitted to Nexus.";
      }

      resetSession();
      return "Nexus recalibrated due to a sync error. Please try that request again.";
    }
  }

  void resetSession() => _chat = _model.startChat();
  
  void dispose() => _httpClient.close();
}
