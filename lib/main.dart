import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'core/constants/task_constants.dart';

void main() {
  runApp(const HumanityLoopApp());
}

class HumanityLoopApp extends StatelessWidget {
  const HumanityLoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Humanity Loop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0B18),
      ),
      home: const HomeScreen(),
    );
  }
}

/// Dynamic game logo drawn using CustomPainter
class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..shader = const LinearGradient(
        colors: [Color(0xFFFF007F), Color(0xFF7928CA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, ringPaint);

    final sparkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(center.dx, center.dy - 8);
    path.lineTo(center.dx + 3, center.dy - 3);
    path.lineTo(center.dx + 8, center.dy);
    path.lineTo(center.dx + 3, center.dy + 3);
    path.lineTo(center.dx, center.dy + 8);
    path.lineTo(center.dx - 3, center.dy + 3);
    path.lineTo(center.dx - 8, center.dy);
    path.lineTo(center.dx - 3, center.dy - 3);
    path.close();

    canvas.drawPath(path, sparkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Random _random = Random();
  String _currentTask = '';
  int _userLevel = 1;
  int _streak = 5;
  bool _isLoading = false;
  final TextEditingController _reflectionController = TextEditingController();

  // Time-bound countdown state
  Timer? _countdownTimer;
  int _timerSeconds = 30;
  int _durationMinutes = 30;
  bool _isTimerActive = false;
  String _reflectionHeading = "Post-Quest Reflection";

  @override
  void initState() {
    super.initState();
    _generateNewTask();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _reflectionController.dispose();
    super.dispose();
  }

  int _extractDurationMinutes(String task) {
    // 1. Years
    final regexYears = RegExp(r'\b(\d+)\s*(?:straight|consecutive\s*)?years?\b', caseSensitive: false);
    final matchYears = regexYears.firstMatch(task);
    if (matchYears != null) {
      return int.parse(matchYears.group(1)!) * 365 * 24 * 60;
    }

    // 2. Months
    final regexMonths = RegExp(r'\b(\d+)\s*months?\b', caseSensitive: false);
    final matchMonths = regexMonths.firstMatch(task);
    if (matchMonths != null) {
      return int.parse(matchMonths.group(1)!) * 30 * 24 * 60;
    }

    // 2. Days
    final regexDays = RegExp(r'\b(\d+)\s*(?:straight|consecutive\s*)?days?\b', caseSensitive: false);
    final matchDays = regexDays.firstMatch(task);
    if (matchDays != null) {
      return int.parse(matchDays.group(1)!) * 24 * 60;
    }

    // 3. Hours
    final regexHours = RegExp(r'\b(\d+)\s*(?:straight|full\s*)?hours?\b', caseSensitive: false);
    final matchHours = regexHours.firstMatch(task);
    if (matchHours != null) {
      return int.parse(matchHours.group(1)!) * 60;
    }

    // 4. Minutes
    final regexMin = RegExp(r'\b(\d+)\s*(?:full\s*)?minutes?\b', caseSensitive: false);
    final matchMin = regexMin.firstMatch(task);
    if (matchMin != null) {
      return int.parse(matchMin.group(1)!);
    }

    if (task.contains('sundown') || task.contains('today')) {
      return 24 * 60;
    }

    final fallbackTimes = [10, 15, 30, 45];
    return fallbackTimes[task.length % fallbackTimes.length];
  }

  void _generateNewTask() {
    _countdownTimer?.cancel();
    setState(() {
      _isLoading = true;
      _reflectionController.clear();
      _isTimerActive = true;
      _reflectionHeading = "Post-Quest Reflection";
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      // Direct extraction from 5,000 unique tasks
      final index = _random.nextInt(TaskConstants.all5000Tasks.length);
      final task = TaskConstants.all5000Tasks[index];
      final extractedTime = _extractDurationMinutes(task);

      setState(() {
        _currentTask = task;
        _isLoading = false;
        _durationMinutes = extractedTime;
        _timerSeconds = extractedTime * 60;
      });

      // Start countdown timer
      _startTimer();
    });
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isTimerActive = false;
          _reflectionHeading = "🎉 How did you feel when you completed this task?";
        });
      }
    });
  }

  void _completeTask() {
    if (_isTimerActive) return;

    if (_reflectionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('💡 Share your feedback about how you feel first.'),
          backgroundColor: Color(0xFF7928CA),
        ),
      );
      return;
    }

    setState(() {
      _userLevel = (_userLevel + 1).clamp(1, 5000);
      _streak++;
    });

    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1B35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '🎉 Quest Clear!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'You successfully leveled up to Level $_userLevel out of 5,000!',
          style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _generateNewTask();
            },
            child: const Text(
              'Next Quest',
              style: TextStyle(color: Color(0xFFFFD600), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B18),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF007F)))
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Simple Header Bar
                      _buildMinimalHeader(),
                      const SizedBox(height: 28),

                      // 2. Focused Quest Card
                      _buildQuestCard(),
                      const SizedBox(height: 24),

                      // 3. Short Minimal Reflection Field
                      _buildReflectionInput(),
                      const SizedBox(height: 28),

                      // 4. Time-Bound Countdown Badge
                      _buildTimerBadge(),
                      const SizedBox(height: 18),

                      // 5. Simple Action Buttons
                      _buildMinimalActions(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildMinimalHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  'assets/logo.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'HUMAN LOOP',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF191336),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2C2257), width: 1.2),
          ),
          child: Text(
            '🔥 $_streak   •   LVL $_userLevel/${TaskConstants.all5000Tasks.length}',
            style: const TextStyle(
              color: Color(0xFFFFD600),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestCard() {
    final categoryColor = const Color(0xFFFF6B9D);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF191238),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2E2257), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Elegant category pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '💝',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 6),
                Text(
                  'SELF IMPROVEMENT',
                  style: TextStyle(
                    color: categoryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Main Task Text Only
          Text(
            _currentTask,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins',
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              _buildSmallMetric(Icons.timer_outlined, _formatDisplayTime(_durationMinutes)),
              const SizedBox(width: 10),
              _buildSmallMetric(Icons.military_tech, 'Micro'),
              const SizedBox(width: 10),
              _buildSmallMetric(Icons.diamond_outlined, '12 XP'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSmallMetric(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF22174C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11.5),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionInput() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF161033),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF291E51), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _reflectionHeading,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _reflectionController,
            style: const TextStyle(color: Colors.white, fontSize: 13.5),
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Describe your feeling and impact...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 13),
              filled: true,
              fillColor: const Color(0xFF100A24),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDisplayTime(int totalMinutes) {
    if (totalMinutes >= 525600) {
      final years = totalMinutes ~/ 525600;
      return "$years year";
    }
    if (totalMinutes >= 43200) {
      final months = totalMinutes ~/ 43200;
      return "$months month";
    }
    if (totalMinutes >= 1440) {
      final days = totalMinutes ~/ 1440;
      return "$days days";
    }
    if (totalMinutes >= 60) {
      final hours = totalMinutes ~/ 60;
      return "$hours hr";
    }
    return "$totalMinutes min";
  }

  String _formatTime(int seconds) {
    if (seconds >= 86400) {
      final days = seconds ~/ 86400;
      final hours = (seconds % 86400) ~/ 3600;
      final mins = (seconds % 3600) ~/ 60;
      final secs = seconds % 60;
      return "${days}d ${hours}h ${mins}m ${secs}s";
    }
    if (seconds >= 3600) {
      final hours = seconds ~/ 3600;
      final mins = (seconds % 3600) ~/ 60;
      final secs = seconds % 60;
      return "${hours}h ${mins}m ${secs}s";
    }
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return "$m:${s.toString().padLeft(2, '0')}";
  }

  Widget _buildTimerBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _isTimerActive ? const Color(0xFF221235) : const Color(0xFF132A1D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isTimerActive ? const Color(0xFF6B1D5F) : const Color(0xFF1E5B3D),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isTimerActive ? Icons.hourglass_top : Icons.check_circle_outline,
            size: 18,
            color: _isTimerActive ? const Color(0xFFFF007F) : const Color(0xFF4CAF50),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _isTimerActive
                  ? 'Time bound activity remaining: ${_formatTime(_timerSeconds)}'
                  : 'Time bound activity complete!',
              style: TextStyle(
                color: _isTimerActive ? const Color(0xFFFFB2E2) : const Color(0xFFA1E7BF),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalActions() {
    return Row(
      children: [
        // Skip Button
        Expanded(
          child: ElevatedButton(
            onPressed: _isTimerActive ? null : _generateNewTask,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF211947),
              foregroundColor: const Color(0xFF94A3B8),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Skip',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Complete Button
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              gradient: _isTimerActive
                  ? null
                  : const LinearGradient(
                      colors: [Color(0xFFFF007F), Color(0xFF7928CA)],
                    ),
              color: _isTimerActive ? Colors.grey.withOpacity(0.1) : null,
              borderRadius: BorderRadius.circular(16),
              boxShadow: _isTimerActive
                  ? []
                  : [
                      BoxShadow(
                        color: const Color(0xFFFF007F).withOpacity(0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      )
                    ],
            ),
            child: ElevatedButton(
              onPressed: _isTimerActive ? null : _completeTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white.withOpacity(0.2),
                shadowColor: Colors.transparent,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Complete Quest',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Made with Bob IBM AI assistant
