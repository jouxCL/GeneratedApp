import 'package:flutter/material.dart';

class GeneratedAppProvider extends ChangeNotifier {
  int _workDuration = 25;
  int _breakDuration = 5;
  int _longBreakDuration = 15;
  int _currentTime = 25 * 60;
  bool _isRunning = false;
  bool _isWorkSession = true;
  int _completedSessions = 0;
  Timer? _timer;

  int get workDuration => _workDuration;
  int get breakDuration => _breakDuration;
  int get longBreakDuration => _longBreakDuration;
  int get currentTime => _currentTime;
  bool get isRunning => _isRunning;
  bool get isWorkSession => _isWorkSession;
  int get completedSessions => _completedSessions;

  set workDuration(int value) {
    if (value >= 1 && value <= 60) {
      _workDuration = value;
      if (!_isRunning && _isWorkSession) {
        _currentTime = value * 60;
      }
      notifyListeners();
    }
  }

  set breakDuration(int value) {
    if (value >= 1 && value <= 30) {
      _breakDuration = value;
      if (!_isRunning && !_isWorkSession && _completedSessions % 4 != 0) {
        _currentTime = value * 60;
      }
      notifyListeners();
    }
  }

  set longBreakDuration(int value) {
    if (value >= 5 && value <= 60) {
      _longBreakDuration = value;
      if (!_isRunning && !_isWorkSession && _completedSessions % 4 == 0) {
        _currentTime = value * 60;
      }
      notifyListeners();
    }
  }

  void startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_currentTime > 0) {
          _currentTime--;
          notifyListeners();
        } else {
          _timer?.cancel();
          _isRunning = false;
          _switchSession();
          notifyListeners();
        }
      });
      notifyListeners();
    }
  }

  void pauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
      notifyListeners();
    }
  }

  void resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    if (_isWorkSession) {
      _currentTime = _workDuration * 60;
    } else {
      _currentTime = (_completedSessions % 4 == 0)
          ? _longBreakDuration * 60
          : _breakDuration * 60;
    }
    notifyListeners();
  }

  void _switchSession() {
    if (_isWorkSession) {
      _isWorkSession = false;
      _completedSessions++;
      _currentTime = (_completedSessions % 4 == 0)
          ? _longBreakDuration * 60
          : _breakDuration * 60;
    } else {
      _isWorkSession = true;
      _currentTime = _workDuration * 60;
    }
  }

  String get formattedTime {
    int minutes = _currentTime ~/ 60;
    int seconds = _currentTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Color get currentColor {
    if (_isWorkSession) {
      return Colors.deepOrange;
    } else {
      return Colors.teal;
    }
  }

  String get currentSessionType {
    return _isWorkSession
        ? 'Work Session'
        : (_completedSessions % 4 == 0 ? 'Long Break' : 'Short Break');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
