import 'dart:async';
import 'package:flutter/material.dart';
import '../models/generatedapp_model.dart';

abstract class PomodoroLocalDataSource {
  Future<void> savePomodoroSession(PomodoroSession session);
  Future<List<PomodoroSession>> getAllPomodoroSessions();
  Future<PomodoroSession?> getPomodoroSessionById(int id);
  Future<void> deletePomodoroSession(int id);
  Future<void> updatePomodoroSession(PomodoroSession session);

  Future<void> saveAppSettings(AppSettings settings);
  Future<AppSettings?> getAppSettings();
}

class PomodoroLocalDataSourceImpl implements PomodoroLocalDataSource {
  static const String _sessionsKey = 'pomodoro_sessions';
  static const String _settingsKey = 'app_settings';
  static const String _lastSessionIdKey = 'last_session_id';

  @override
  Future<void> savePomodoroSession(PomodoroSession session) async {
    try {
      final prefs = await _getSharedPreferences();
      final sessionsJson = prefs.getStringList(_sessionsKey) ?? [];

      // Update or add session
      final sessionJson = jsonEncode(session.toJson());
      bool updated = false;

      for (int i = 0; i < sessionsJson.length; i++) {
        final existingSession = PomodoroSession.fromJson(
          jsonDecode(sessionsJson[i]) as Map<String, dynamic>,
        );
        if (existingSession.id == session.id) {
          sessionsJson[i] = sessionJson;
          updated = true;
          break;
        }
      }

      if (!updated) {
        sessionsJson.add(sessionJson);
      }

      await prefs.setStringList(_sessionsKey, sessionsJson);

      // Update last session ID if needed
      final lastId = prefs.getInt(_lastSessionIdKey) ?? 0;
      if (session.id > lastId) {
        await prefs.setInt(_lastSessionIdKey, session.id);
      }
    } catch (e) {
      debugPrint('Error saving pomodoro session: $e');
      rethrow;
    }
  }

  @override
  Future<List<PomodoroSession>> getAllPomodoroSessions() async {
    try {
      final prefs = await _getSharedPreferences();
      final sessionsJson = prefs.getStringList(_sessionsKey) ?? [];

      return sessionsJson.map((jsonString) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return PomodoroSession.fromJson(json);
      }).toList();
    } catch (e) {
      debugPrint('Error getting all pomodoro sessions: $e');
      return [];
    }
  }

  @override
  Future<PomodoroSession?> getPomodoroSessionById(int id) async {
    try {
      final sessions = await getAllPomodoroSessions();
      return sessions.firstWhere(
        (session) => session.id == id,
        orElse: () => null,
      );
    } catch (e) {
      debugPrint('Error getting pomodoro session by id: $e');
      return null;
    }
  }

  @override
  Future<void> deletePomodoroSession(int id) async {
    try {
      final prefs = await _getSharedPreferences();
      final sessionsJson = prefs.getStringList(_sessionsKey) ?? [];

      final updatedSessions = sessionsJson.where((jsonString) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return json['id'] != id;
      }).toList();

      await prefs.setStringList(_sessionsKey, updatedSessions);
    } catch (e) {
      debugPrint('Error deleting pomodoro session: $e');
      rethrow;
    }
  }

  @override
  Future<void> updatePomodoroSession(PomodoroSession session) async {
    await savePomodoroSession(session);
  }

  @override
  Future<void> saveAppSettings(AppSettings settings) async {
    try {
      final prefs = await _getSharedPreferences();
      final settingsJson = jsonEncode(settings.toJson());
      await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      debugPrint('Error saving app settings: $e');
      rethrow;
    }
  }

  @override
  Future<AppSettings?> getAppSettings() async {
    try {
      final prefs = await _getSharedPreferences();
      final settingsJson = prefs.getString(_settingsKey);

      if (settingsJson == null) {
        // Return default settings
        return AppSettings(
          defaultWorkDuration: 25,
          defaultBreakDuration: 5,
          autoStartBreaks: true,
          autoStartWork: false,
          soundEnabled: true,
          notificationsEnabled: true,
        );
      }

      final json = jsonDecode(settingsJson) as Map<String, dynamic>;
      return AppSettings.fromJson(json);
    } catch (e) {
      debugPrint('Error getting app settings: $e');
      return null;
    }
  }

  Future<int> getNextSessionId() async {
    try {
      final prefs = await _getSharedPreferences();
      final lastId = prefs.getInt(_lastSessionIdKey) ?? 0;
      return lastId + 1;
    } catch (e) {
      debugPrint('Error getting next session id: $e');
      return 1;
    }
  }

  // Helper method to simulate SharedPreferences
  Future<SharedPreferences> _getSharedPreferences() async {
    // In a real app, this would use the shared_preferences package
    // For this example, we'll create a simple in-memory implementation
    return SharedPreferences._();
  }
}

// Simple in-memory SharedPreferences simulation
class SharedPreferences {
  static SharedPreferences? _instance;
  final Map<String, dynamic> _storage = {};

  SharedPreferences._();

  static Future<SharedPreferences> getInstance() async {
    _instance ??= SharedPreferences._();
    return _instance!;
  }

  Future<SharedPreferences> _getInstance() async {
    return await getInstance();
  }

  Future<bool> setString(String key, String value) async {
    _storage[key] = value;
    return true;
  }

  Future<bool> setStringList(String key, List<String> value) async {
    _storage[key] = List<String>.from(value);
    return true;
  }

  Future<bool> setInt(String key, int value) async {
    _storage[key] = value;
    return true;
  }

  String? getString(String key) {
    return _storage[key] as String?;
  }

  List<String>? getStringList(String key) {
    final value = _storage[key];
    if (value is List) {
      return value.cast<String>().toList();
    }
    return null;
  }

  int? getInt(String key) {
    return _storage[key] as int?;
  }
}
