import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/bottom_nav_bar.dart';
import 'package:flutter/services.dart'; // For haptic feedback

enum BreathingPhase { inhale, hold, exhale }

class BreathingPage extends StatefulWidget {
  const BreathingPage({super.key});

  @override
  State<BreathingPage> createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  Timer? _timer;

  BreathingPhase _phase = BreathingPhase.inhale;
  bool _isRunning = false;
  int _cycleCount = 0;
  int _secondsRemaining = 4;

  // Durations
  int inhaleDuration = 4;
  int holdDuration = 2;
  int exhaleDuration = 4;

  // Mode selection
  String _selectedMode = 'Relax';

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: inhaleDuration),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _selectMode(String mode) {
    setState(() {
      _selectedMode = mode;

      switch (mode) {
        case 'Relax':
          inhaleDuration = 4;
          holdDuration = 2;
          exhaleDuration = 4;
          break;
        case 'Focus':
          inhaleDuration = 4;
          holdDuration = 4;
          exhaleDuration = 4;
          break;
        case 'Sleep':
          inhaleDuration = 4;
          holdDuration = 7;
          exhaleDuration = 8;
          break;
      }

      _secondsRemaining = inhaleDuration;
      _phase = BreathingPhase.inhale;
      _animationController.duration = Duration(seconds: inhaleDuration);
    });
  }

  void _startBreathing() {
    setState(() {
      _isRunning = true;
      _phase = BreathingPhase.inhale;
      _secondsRemaining = inhaleDuration;
      _cycleCount = 0;
    });
    _startPhase();
  }

  void _stopBreathing() {
    _timer?.cancel();
    _animationController.reset();
    setState(() {
      _isRunning = false;
      _phase = BreathingPhase.inhale;
      _secondsRemaining = inhaleDuration;
      _cycleCount = 0;
    });
  }

  void _startPhase() {
    _timer?.cancel();
    HapticFeedback.lightImpact();

    Duration phaseDuration = _getPhaseDuration(_phase);
    _secondsRemaining = phaseDuration.inSeconds;

    if (_phase == BreathingPhase.inhale) {
      _animationController.duration = Duration(seconds: inhaleDuration);
      _animationController.forward();
    } else if (_phase == BreathingPhase.exhale) {
      _animationController.duration = Duration(seconds: exhaleDuration);
      _animationController.reverse();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _secondsRemaining--);
      if (_secondsRemaining <= 0) {
        timer.cancel();
        _advancePhase();
      }
    });
  }

  Duration _getPhaseDuration(BreathingPhase phase) {
    switch (phase) {
      case BreathingPhase.inhale:
        return Duration(seconds: inhaleDuration);
      case BreathingPhase.hold:
        return Duration(seconds: holdDuration);
      case BreathingPhase.exhale:
        return Duration(seconds: exhaleDuration);
    }
  }

  void _advancePhase() {
    switch (_phase) {
      case BreathingPhase.inhale:
        _switchPhase(BreathingPhase.hold);
        break;
      case BreathingPhase.hold:
        final bool justInhaled = _animationController.value >= 0.99;
        _switchPhase(justInhaled ? BreathingPhase.exhale : BreathingPhase.inhale);
        break;
      case BreathingPhase.exhale:
        setState(() => _cycleCount++);
        _switchPhase(BreathingPhase.hold);
        break;
    }
  }

  void _switchPhase(BreathingPhase next) {
    if (!_isRunning) return;
    setState(() {
      _phase = next;
    });
    _startPhase();
  }

  String get _instructionText {
    switch (_phase) {
      case BreathingPhase.inhale:
        return "Inhale slowly...";
      case BreathingPhase.hold:
        return "Hold your breath...";
      case BreathingPhase.exhale:
        return "Exhale gently...";
    }
  }

  Color get _circleColor {
    switch (_phase) {
      case BreathingPhase.inhale:
        return const Color(0xFF4CAF50).withOpacity(0.7);
      case BreathingPhase.hold:
        return const Color(0xFF9C27B0).withOpacity(0.7);
      case BreathingPhase.exhale:
        return const Color(0xFF2196F3).withOpacity(0.7);
    }
  }

  List<Color> get _backgroundGradient {
    switch (_phase) {
      case BreathingPhase.inhale:
        return [Colors.greenAccent.withOpacity(0.2), Colors.white];
      case BreathingPhase.hold:
        return [Colors.purpleAccent.withOpacity(0.2), Colors.white];
      case BreathingPhase.exhale:
        return [Colors.blueAccent.withOpacity(0.2), Colors.white];
    }
  }

  @override
  Widget build(BuildContext context) {
    final double circleSize = MediaQuery.of(context).size.width * 0.55;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Breathing Exercises",
        style: TextStyle(color: Colors.white), // White text
          ),
          backgroundColor: const Color(0xFF6A5AE0),
          iconTheme: const IconThemeData(color: Colors.white), // White back arrow
        ),
      body: AnimatedContainer(
        duration: const Duration(seconds: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Instruction box
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    key: ValueKey(_instructionText),
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      !_isRunning
                          ? "Tap Start to begin your breathing exercise"
                          : _instructionText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                // Breathing circle + progress
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        final totalTime =
                            _getPhaseDuration(_phase).inSeconds.toDouble();
                        final progress = _secondsRemaining / totalTime;

                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: circleSize + 30,
                              height: circleSize + 30,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 6,
                                color: _circleColor,
                                backgroundColor: _circleColor.withOpacity(0.1),
                              ),
                            ),
                            Transform.scale(
                              scale: _scaleAnimation.value,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 800),
                                width: circleSize,
                                height: circleSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isRunning
                                      ? _circleColor
                                      : const Color(0xFF6A5AE0).withOpacity(0.3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _circleColor.withOpacity(0.5),
                                      blurRadius: 40,
                                      spreadRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    _isRunning ? '$_secondsRemaining' : '•',
                                    style: TextStyle(
                                      fontSize: _isRunning ? 48 : 80,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Cycle counter
                if (_isRunning)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6A5AE0).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Cycle: $_cycleCount',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6A5AE0),
                      ),
                    ),
                  ),

                const SizedBox(height: 40),

                // Mode selection (shown when not running)
                if (!_isRunning) _buildModeSelection(),

                const SizedBox(height: 20),

                // Control buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!_isRunning)
                      ElevatedButton.icon(
                        onPressed: _startBreathing,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: _stopBreathing,
                        icon: const Icon(Icons.stop),
                        label: const Text('Stop'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF44336),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildModeSelection() {
    final modes = ['Relax', 'Focus', 'Sleep'];
    return Column(
      children: [
        const Text(
          "Select a Breathing Mode",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6A5AE0),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          children: modes.map((mode) {
            final bool selected = _selectedMode == mode;
            return ChoiceChip(
              label: Text(
                mode,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF6A5AE0),
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: selected,
              selectedColor: const Color(0xFF6A5AE0),
              backgroundColor: Colors.white,
              onSelected: (_) => _selectMode(mode),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Text(
          _selectedMode == 'Relax'
              ? "Inhale 4s • Hold 2s • Exhale 4s"
              : _selectedMode == 'Focus'
                  ? "Inhale 4s • Hold 4s • Exhale 4s"
                  : "Inhale 4s • Hold 7s • Exhale 8s",
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}
