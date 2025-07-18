class TimeEntry {
  final String id;
  final String projectId;
  final String taskId;
  final DateTime date;
  final double totalTime;
  final String notes;

  TimeEntry({
    required this.id,
    required this.projectId,
    required this.taskId,
    required this.date,
    required this.totalTime,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'taskId': taskId,
    'date': date.toIso8601String(),
    'totalTime': totalTime,
    'notes': notes,
  };

  factory TimeEntry.fromJson(Map<String, dynamic> json) => TimeEntry(
    id: json['id'],
    projectId: json['projectId'],
    taskId: json['taskId'],
    date: DateTime.parse(json['date']),
    totalTime: json['totalTime'],
    notes: json['notes'],
  );
}
