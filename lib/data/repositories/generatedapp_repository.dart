import 'dart:async';
import '../datasources/generatedapp_local_datasource.dart';
import '../models/generatedapp_model.dart';

abstract class PomodoroRepository {
  Future<PomodoroSession> startNewSession({
    required int workDuration,
    required int breakDuration,
    String? notes,
  });

  Future<void> completeSession(int sessionId);
  Future<void> updateSessionNotes(int sessionId, String notes);
  Future<List<PomodoroSession>> getTodaySessions();
  Future<List<PomodoroSession>> getAllSessions();
  Future<PomodoroSession?> getActiveSession();
  Future<void> deleteSession(int sessionId);

  Future<AppSettings> getAppSettings();
  Future<void> saveAppSettings(AppSettings settings);
  Future<void> resetAppSettings();
}

class PomodoroRepositoryImpl implements PomodoroRepository {
  final PomodoroLocalDataSource _localDataSource;

  PomodoroRepositoryImpl(this._localDataSource);

  @override
  Future<PomodoroSession> startNewSession({
    required int workDuration,
    required int breakDuration,
    String? notes,
  }) async {
    final nextId = await (_localDataSource as PomodoroLocalDataSourceImpl)
        .getNextSessionId();

    final session = PomodoroSession(
      id: nextId,
      startTime: DateTime.now(),
      endTime: null,
      workDuration: workDuration,
      breakDuration: breakDuration,
      isCompleted: false,
      notes: notes,
    );

    await _localDataSource.savePomodoroSession(session);
    return session;
  }

  @override
  Future<void> completeSession(int sessionId) async {
    final session = await _localDataSource.getPomodoroSessionById(sessionId);
    if (session != null) {
      final updatedSession = session.copyWith(
        endTime: DateTime.now(),
        isCompleted: true,
      );
      await _localDataSource.updatePomodoroSession(updatedSession);
    }
  }

  @override
  Future<void> updateSessionNotes(int sessionId, String notes) async {
    final session = await _localDataSource.getPomodoroSessionById(sessionId);
    if (session != null) {
      final updatedSession = session.copyWith(notes: notes);
      await _localDataSource.updatePomodoroSession(updatedSession);
    }
  }

  @override
  Future<List<PomodoroSession>> getTodaySessions() async {
    final allSessions = await _localDataSource.getAllPomodoroSessions();
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    return allSessions.where((session) {
      return session.startTime.isAfter(todayStart) &&
          session.startTime.isBefore(todayEnd);
    }).toList();
  }

  @override
  Future<List<PomodoroSession>> getAllSessions() async {
    return await _localDataSource.getAllPomodoroSessions();
  }

  @override
  Future<PomodoroSession?> getActiveSession() async {
    final allSessions = await _localDataSource.getAllPomodoroSessions();
    return allSessions.firstWhere(
      (session) => !session.isCompleted,
      orElse: () => null,
    );
  }

  @override
  Future<void> deleteSession(int sessionId) async {
    await _localDataSource.deletePomodoroSession(sessionId);
  }

  @override
  Future<AppSettings> getAppSettings() async {
    final settings = await _localDataSource.getAppSettings();
    return settings ??
        AppSettings(
          defaultWorkDuration: 25,
          defaultBreakDuration: 5,
          autoStartBreaks: true,
          autoStartWork: false,
          soundEnabled: true,
          notificationsEnabled: true,
        );
  }

  @override
  Future<void> saveAppSettings(AppSettings settings) async {
    await _localDataSource.saveAppSettings(settings);
  }

  @override
  Future<void> resetAppSettings() async {
    final defaultSettings = AppSettings(
      defaultWorkDuration: 25,
      defaultBreakDuration: 5,
      autoStartBreaks: true,
      autoStartWork: false,
      soundEnabled: true,
      notificationsEnabled: true,
    );
    await _localDataSource.saveAppSettings(defaultSettings);
  }
}
