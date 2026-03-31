import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _workMinutes = 25;
  int _breakMinutes = 5;
  int _seconds = 0;
  bool _isWorkTime = true;
  bool _isRunning = false;
  int _completedSessions = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _controller.repeat(reverse: true);
      _timerTick();
    }
  }

  void _pauseTimer() {
    if (_isRunning) {
      _isRunning = false;
      _controller.stop();
    }
  }

  void _resetTimer() {
    _isRunning = false;
    _controller.reset();
    _seconds = 0;
    _isWorkTime = true;
    setState(() {});
  }

  void _timerTick() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRunning) {
        if (_seconds > 0) {
          setState(() => _seconds--);
        } else {
          if (_isWorkTime) {
            _isWorkTime = false;
            _seconds = _breakMinutes * 60;
            _completedSessions++;
          } else {
            _isWorkTime = true;
            _seconds = _workMinutes * 60;
          }
        }
        _timerTick();
      }
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    int totalSeconds = _isWorkTime
        ? _workMinutes * 60 + _seconds
        : _breakMinutes * 60 + _seconds;
    String timerText = _formatTime(totalSeconds);
    String modeText = _isWorkTime ? 'Trabajo' : 'Descanso';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro'),
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6750A4).withOpacity(0.1),
                    border: Border.all(
                      color: const Color(0xFF6750A4),
                      width: 8,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          timerText,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6750A4),
                          ),
                        ),
                      ),
                      if (_isRunning)
                        Positioned.fill(
                          child: CircularProgressIndicator(
                            value: 1 -
                                (totalSeconds /
                                    (_isWorkTime
                                        ? _workMinutes * 60
                                        : _breakMinutes * 60)),
                            strokeWidth: 8,
                            color: const Color(0xFFCCC2DC),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            Text(
              modeText,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6750A4),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6750A4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: Row(
                    children: [
                      Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                      const SizedBox(width: 8),
                      Text(_isRunning ? 'Pausar' : 'Iniciar'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: _resetTimer,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6750A4),
                    side: const BorderSide(color: Color(0xFF6750A4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.refresh),
                      SizedBox(width: 8),
                      Text('Reiniciar'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFCCC2DC).withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Sesiones Completadas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6750A4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_completedSessions',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6750A4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Estadísticas',
          ),
        ],
        selectedIndex: 0,
        onDestinationSelected: (index) {},
      ),
    );
  }
}
