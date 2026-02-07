class ProjectLog {
  final String content;
  final String priority;
  final String timestamp;

  ProjectLog({required this.content, required this.priority, required this.timestamp});

  factory ProjectLog.fromJson(Map<String, dynamic> json) {
    return ProjectLog(
      content: json['content'] ?? '',
      priority: json['priority'] ?? 'Low',
      timestamp: json['timestamp'] ?? '',
    );
  }
}