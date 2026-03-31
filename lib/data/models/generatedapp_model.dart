import 'dart:convert';

class PomodoroSession {
  final int id;
  final DateTime startTime;
  final DateTime? endTime;
  final int workDuration; // in minutes
  final int breakDuration; // in minutes
  final bool isCompleted;
  final String? notes;

  PomodoroSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.workDuration,
    required this.breakDuration,
    required this.isCompleted,
    this.notes,
  });

  PomodoroSession copyWith({
    int? id,
    DateTime? startTime,
    DateTime? endTime,
    int? workDuration,
    int? breakDuration,
    bool? isCompleted,
    String? notes,
  }) {
    return PomodoroSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      workDuration: workDuration ?? this.workDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'workDuration': workDuration,
      'breakDuration': breakDuration,
      'isCompleted': isCompleted,
      'notes': notes,
    };
  }

  factory PomodoroSession.fromJson(Map<String, dynamic> json) {
    return PomodoroSession(
      id: json['id'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      workDuration: json['workDuration'] as int,
      breakDuration: json['breakDuration'] as int,
      isCompleted: json['isCompleted'] as bool,
      notes: json['notes'] as String?,
    );
  }

  @override
  String toString() {
    return 'PomodoroSession(id: $id, startTime: $startTime, endTime: $endTime, workDuration: $workDuration, breakDuration: $breakDuration, isCompleted: $isCompleted, notes: $notes)';
  }
}

class AppSettings {
  final int defaultWorkDuration; // in minutes
  final int defaultBreakDuration; // in minutes
  final bool autoStartBreaks;
  final bool autoStartWork;
  final bool soundEnabled;
  final bool notificationsEnabled;

  AppSettings({
    required this.defaultWorkDuration,
    required this.defaultBreakDuration,
    required this.autoStartBreaks,
    required this.autoStartWork,
    required this.soundEnabled,
    required this.notificationsEnabled,
  });

  AppSettings copyWith({
    int? defaultWorkDuration,
    int? defaultBreakDuration,
    bool? autoStartBreaks,
    bool? autoStartWork,
    bool? soundEnabled,
    bool? notificationsEnabled,
  }) {
    return AppSettings(
      defaultWorkDuration: defaultWorkDuration ?? this.defaultWorkDuration,
      defaultBreakDuration: defaultBreakDuration ?? this.defaultBreakDuration,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartWork: autoStartWork ?? this.autoStartWork,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultWorkDuration': defaultWorkDuration,
      'defaultBreakDuration': defaultBreakDuration,
      'autoStartBreaks': autoStartBreaks,
      'autoStartWork': autoStartWork,
      'soundEnabled': soundEnabled,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      defaultWorkDuration: json['defaultWorkDuration'] as int,
      defaultBreakDuration: json['defaultBreakDuration'] as int,
      autoStartBreaks: json['autoStartBreaks'] as bool,
      autoStartWork: json['autoStartWork'] as bool,
      soundEnabled: json['soundEnabled'] as bool,
      notificationsEnabled: json['notificationsEnabled'] as bool,
    );
  }

  @override
  String toString() {
    return 'AppSettings(defaultWorkDuration: $defaultWorkDuration, defaultBreakDuration: $defaultBreakDuration, autoStartBreaks: $autoStartBreaks, autoStartWork: $autoStartWork, soundEnabled: $soundEnabled, notificationsEnabled: $notificationsEnabled)';
  }
}
