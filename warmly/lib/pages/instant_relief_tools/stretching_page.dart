import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/bottom_nav_bar.dart';

class StretchingPage extends StatefulWidget {
  const StretchingPage({super.key});

  @override
  State<StretchingPage> createState() => _StretchingPageState();
}

class _StretchingPageState extends State<StretchingPage>
    with SingleTickerProviderStateMixin {
  int? _activeTimerIndex;
  int _remainingSeconds = 0;
  bool _isTimerRunning = false;
  Timer? _timer;
  StateSetter? _modalSetState;

  final List<Map<String, dynamic>> stretches = [
    {
      'title': 'Child\'s Pose',
      'duration': '1-3 minutes',
      'timerSeconds': 120,
      'difficulty': 'Easy',
      'icon': Icons.self_improvement,
      'description':
          'Gently stretches the lower back and hips, promoting relaxation and easing tension.',
      'steps': [
        'Kneel on the floor with your big toes touching',
        'Sit back on your heels and separate your knees hip-width apart',
        'Exhale and lay your torso down between your thighs',
        'Extend your arms forward or rest them alongside your body',
        'Breathe deeply and relax into the pose',
      ],
      'benefits': 'Relieves lower back pain and calms the nervous system',
    },
    {
      'title': 'Cat-Cow Stretch',
      'duration': '2-3 minutes',
      'timerSeconds': 150,
      'difficulty': 'Easy',
      'icon': Icons.pets,
      'description':
          'A gentle flow between two poses that massages the spine and belly organs.',
      'steps': [
        'Start on your hands and knees in a tabletop position',
        'Inhale, drop your belly, lift your chest and tailbone (Cow)',
        'Exhale, round your spine, tuck your chin to chest (Cat)',
        'Continue flowing between poses with your breath',
        'Move slowly and mindfully',
      ],
      'benefits': 'Increases spinal flexibility and massages abdominal organs',
    },
    {
      'title': 'Supine Twist',
      'duration': '1-2 minutes each side',
      'timerSeconds': 120,
      'difficulty': 'Easy',
      'icon': Icons.rotate_right,
      'description':
          'A gentle twisting pose that releases tension in the lower back and hips.',
      'steps': [
        'Lie on your back with arms extended out to the sides',
        'Bring your knees to your chest',
        'Lower both knees to one side while keeping shoulders flat',
        'Turn your head to the opposite direction',
        'Hold, then repeat on the other side',
      ],
      'benefits': 'Relieves lower back tension and aids digestion',
    },
    {
      'title': 'Butterfly Stretch',
      'duration': '2-3 minutes',
      'timerSeconds': 150,
      'difficulty': 'Easy',
      'icon': Icons.favorite,
      'description': 'Opens the hips and stretches the inner thighs and groin.',
      'steps': [
        'Sit with your back straight',
        'Bring the soles of your feet together',
        'Hold your feet with your hands',
        'Gently press your knees toward the floor with your elbows',
        'Keep your spine elongated and breathe deeply',
      ],
      'benefits': 'Opens hips and improves circulation to the pelvic area',
    },
    {
      'title': 'Happy Baby Pose',
      'duration': '1-2 minutes',
      'timerSeconds': 90,
      'difficulty': 'Easy',
      'icon': Icons.child_care,
      'description':
          'A playful pose that gently stretches the hips and lower back.',
      'steps': [
        'Lie on your back',
        'Bend your knees and bring them toward your chest',
        'Grab the outside edges of your feet',
        'Pull your knees toward your armpits',
        'Rock gently side to side if it feels good',
      ],
      'benefits': 'Releases tension in hips and lower back',
    },
    {
      'title': 'Reclining Bound Angle',
      'duration': '3-5 minutes',
      'timerSeconds': 240,
      'difficulty': 'Easy',
      'icon': Icons.airline_seat_flat,
      'description': 'A deeply relaxing pose that opens the hips and chest.',
      'steps': [
        'Lie on your back',
        'Bring the soles of your feet together, knees falling out to sides',
        'Place hands on belly or out to sides',
        'Close your eyes and breathe deeply',
        'Stay as long as comfortable',
      ],
      'benefits': 'Deeply relaxing, opens hips, and eases cramps',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(int index) {
    setState(() {
      _activeTimerIndex = index;
      _remainingSeconds = stretches[index]['timerSeconds'];
      _isTimerRunning = true;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        setState(() {});
        _modalSetState?.call(() {});
      } else {
        _stopTimer();
        _showCompletionDialog(index);
      }
    });
  }

  void _pauseTimer() {
    setState(() {
      _isTimerRunning = false;
    });
    _modalSetState?.call(() {});
    _timer?.cancel();
  }

  void _resumeTimer() {
    setState(() {
      _isTimerRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        setState(() {});
        _modalSetState?.call(() {});
      } else {
        _stopTimer();
        _showCompletionDialog(_activeTimerIndex!);
      }
    });
  }

  void _stopTimer() {
    setState(() {
      _isTimerRunning = false;
      _activeTimerIndex = null;
      _remainingSeconds = 0;
    });
    _modalSetState?.call(() {});
    _timer?.cancel();
  }

  void _showCompletionDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.celebration, color: const Color(0xFF6A5AE0)),
            const SizedBox(width: 8),
            const Text('Great Job!'),
          ],
        ),
        content: Text('You\'ve completed ${stretches[index]['title']}! 🎉'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showStretchDetail(
    BuildContext context,
    Map<String, dynamic> stretch,
    int index,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          _modalSetState = setModalState;
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6A5AE0).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                stretch['icon'],
                                size: 32,
                                color: const Color(0xFF6A5AE0),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stretch['title'],
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          stretch['difficulty'],
                                          style: TextStyle(
                                            color: Colors.green[700],
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.timer,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        stretch['duration'],
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Enhanced Timer Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF6A5AE0),
                                const Color(0xFF8B7AED),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6A5AE0).withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _activeTimerIndex == index &&
                                            _isTimerRunning
                                        ? Icons.timer
                                        : Icons.timer_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Timer',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Circular Progress Indicator with Time
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 160,
                                    height: 160,
                                    child: TweenAnimationBuilder<double>(
                                      duration: const Duration(
                                        milliseconds: 1000,
                                      ),
                                      curve: Curves.easeInOut,
                                      tween: Tween<double>(
                                        begin: _activeTimerIndex == index
                                            ? (_remainingSeconds + 1) /
                                                  stretch['timerSeconds']
                                            : 1.0,
                                        end: _activeTimerIndex == index
                                            ? _remainingSeconds /
                                                  stretch['timerSeconds']
                                            : 1.0,
                                      ),
                                      builder: (context, value, child) {
                                        return CircularProgressIndicator(
                                          value: value,
                                          strokeWidth: 12,
                                          backgroundColor: Colors.white
                                              .withOpacity(0.3),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _activeTimerIndex == index
                                                ? _formatTime(_remainingSeconds)
                                                : _formatTime(
                                                    stretch['timerSeconds'],
                                                  ),
                                            style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                          if (_activeTimerIndex == index)
                                            AnimatedOpacity(
                                              opacity: _isTimerRunning
                                                  ? 1.0
                                                  : 0.6,
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              child: Text(
                                                _isTimerRunning
                                                    ? 'In Progress'
                                                    : 'Paused',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),
                              Text(
                                _activeTimerIndex == index
                                    ? '${(100 - (_remainingSeconds / stretch['timerSeconds'] * 100)).toInt()}%'
                                    : 'Ready',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.95),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Control Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_activeTimerIndex == index && _isTimerRunning)
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _pauseTimer();
                                        setModalState(() {});
                                      },
                                      icon: const Icon(Icons.pause, size: 24),
                                      label: const Text(
                                        'Pause',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: const Color(0xFF6A5AE0),
                                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        elevation: 5,
                                      ),
                                    )
                                  else if (_activeTimerIndex == index && !_isTimerRunning)
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _resumeTimer();
                                        setModalState(() {});
                                      },
                                      icon: const Icon(Icons.play_arrow, size: 24),
                                      label: const Text(
                                        'Resume',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: const Color(0xFF6A5AE0),
                                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        elevation: 5,
                                      ),
                                    )
                                  else
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _startTimer(index);
                                        setModalState(() {});
                                      },
                                      icon: const Icon(Icons.play_arrow, size: 28),
                                      label: const Text(
                                        'Start Timer',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: const Color(0xFF6A5AE0),
                                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        elevation: 8,
                                      ),
                                    ),
                                  if (_activeTimerIndex == index)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Colors.white.withOpacity(0.25),
                                        child: IconButton(
                                          onPressed: () {
                                            _stopTimer();
                                            setModalState(() {});
                                          },
                                          icon: const Icon(Icons.stop, size: 28, color: Colors.white),
                                          tooltip: 'Stop Timer',
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          stretch['description'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'How to do it:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(
                          stretch['steps'].length,
                          (stepIndex) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6A5AE0),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${stepIndex + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    stretch['steps'][stepIndex],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[800],
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF4E6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.lightbulb_outline,
                                color: Color(0xFFFF9800),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Benefits',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      stretch['benefits'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stretching Routine", 
        style: TextStyle(color: Colors.white), // White text
          ),
          backgroundColor: const Color(0xFF6A5AE0),
          iconTheme: const IconThemeData(color: Colors.white), // White back arrow
        ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF6A5AE0),
                  const Color(0xFF6A5AE0).withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Gentle Stretches for Relief",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "These stretches help ease cramps and tension",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: stretches.length,
              itemBuilder: (context, index) {
                final stretch = stretches[index];
                final isActiveTimer = _activeTimerIndex == index;
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: isActiveTimer ? 4 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: isActiveTimer
                        ? BorderSide(color: const Color(0xFF6A5AE0), width: 2)
                        : BorderSide.none,
                  ),
                  child: InkWell(
                    onTap: () => _showStretchDetail(context, stretch, index),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6A5AE0).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              stretch['icon'],
                              color: const Color(0xFF6A5AE0),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stretch['title'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isActiveTimer
                                          ? _formatTime(_remainingSeconds)
                                          : stretch['duration'],
                                      style: TextStyle(
                                        color: isActiveTimer
                                            ? const Color(0xFF6A5AE0)
                                            : Colors.grey[600],
                                        fontSize: 14,
                                        fontWeight: isActiveTimer
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        stretch['difficulty'],
                                        style: TextStyle(
                                          color: Colors.green[700],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (isActiveTimer) ...[
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value:
                                        _remainingSeconds /
                                        stretch['timerSeconds'],
                                    backgroundColor: Colors.grey[200],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _isTimerRunning
                                          ? const Color(0xFF6A5AE0)
                                          : Colors.orange,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
