import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../../widgets/bottom_nav_bar.dart';

class RelaxationSound {
  final String name;
  final String description;
  final IconData icon;
  final String category;
  final String asset;

  const RelaxationSound({
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.asset,
  });
}

class RelaxationPage extends StatefulWidget {
  const RelaxationPage({super.key});

  @override
  State<RelaxationPage> createState() => _RelaxationPageState();
}

class _RelaxationPageState extends State<RelaxationPage>
    with TickerProviderStateMixin {
  // ── Session State ───────────────────────────────
  Timer? _sessionTimer;
  int _sessionMinutes = 10;
  int _remainingSeconds = 0;
  bool _isPlaying = false;
  bool _isPaused = false;

  // ── Audio ───────────────────────────────
  late final AudioPlayer _audioPlayer;
  double _volume = 0.5;
  double _currentVolume = 0.0;
  Timer? _fadeTimer;

  // ── Visuals ───────────────────────────────
  late final AnimationController _bgController;
  late final Animation<double> _bgCurve;
  double _fadeLevel = 0.0;

  // ── Selection ───────────────────────────────
  String _selectedCategory = 'All';
  RelaxationSound? _selectedSound;

  // ── Sound Data ───────────────────────────────
  final List<RelaxationSound> _sounds = const [
    RelaxationSound(
      name: "Ocean Waves",
      description: "Gentle ocean waves for deep relaxation",
      icon: Icons.waves,
      category: "Nature",
      asset: "assets/sounds/ocean_waves.mp3",
    ),
    RelaxationSound(
      name: "Rain Forest",
      description: "Peaceful rain in a tropical forest",
      icon: Icons.cloud,
      category: "Nature",
      asset: "assets/sounds/rain_forest.mp3",
    ),
    RelaxationSound(
      name: "White Noise",
      description: "Consistent white noise for focus",
      icon: Icons.graphic_eq,
      category: "Ambient",
      asset: "assets/sounds/white_noise.mp3",
    ),
    RelaxationSound(
      name: "Tibetan Bowls",
      description: "Healing sound bowls for deep meditation",
      icon: Icons.music_note,
      category: "Meditation",
      asset: "assets/sounds/tibetan_bowls.mp3",
    ),
  ];

  // ── Helpers ───────────────────────────────
  List<String> get _categories {
    final cats = _sounds.map((e) => e.category).toSet().toList()..sort();
    cats.insert(0, 'All');
    return cats;
  }

  List<RelaxationSound> get _filteredSounds =>
      _selectedCategory == 'All'
          ? _sounds
          : _sounds.where((e) => e.category == _selectedCategory).toList();

  double get _progress =>
      _isPlaying && _sessionMinutes > 0
          ? 1 - (_remainingSeconds / (_sessionMinutes * 60)).clamp(0.0, 1.0)
          : 0.0;

  // ── Lifecycle ───────────────────────────────
  @override
  void initState() {
    super.initState();
    _bgController =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat(reverse: true);
    _bgCurve = CurvedAnimation(parent: _bgController, curve: Curves.easeInOut);

    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _fadeTimer?.cancel();
    _bgController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // ── Session Controls ───────────────────────────────
  Future<void> _startSession() async {
    if (_selectedSound == null) {
      _toast("Select a sound to begin");
      return;
    }

    // ▶️ Resume
    if (_isPaused && _isPlaying) {
      _resumeCountdown();
      _bgController.repeat(reverse: true);
      await _resumeAudioWithFade();
      setState(() => _isPaused = false);
      _toast("Resumed");
      return;
    }

    // ▶️ Fresh start
    _sessionTimer?.cancel();
    _fadeTimer?.cancel();

    setState(() {
      _isPlaying = true;
      _isPaused = false;
      _remainingSeconds = _sessionMinutes * 60;
    });

    try {
      await _audioPlayer.stop();
      _currentVolume = 0.0;
      await _audioPlayer.setVolume(0.0);
      final src = _selectedSound!.asset.replaceFirst('assets/', '');
      await _audioPlayer.play(AssetSource(src));
      await _fadeAudio(to: _volume, duration: const Duration(seconds: 3));
    } catch (e) {
      _toast("Audio error. Check asset path.");
      debugPrint('Audio play error: $e');
      return;
    }

    _bgController.repeat(reverse: true);
    _startCountdown();
    _toast("Session started");
    HapticFeedback.selectionClick();
  }

  Future<void> _pauseSession() async {
    if (!_isPlaying || _isPaused) return;
    _sessionTimer?.cancel();
    await _fadeAudio(to: 0.0, duration: const Duration(milliseconds: 800));
    await _audioPlayer.pause();
    _bgController.stop();
    setState(() => _isPaused = true);
    _toast("Paused");
    HapticFeedback.selectionClick();
  }

  Future<void> _stopSession() async {
    if (!_isPlaying) return;
    _sessionTimer?.cancel();
    await _fadeAudio(to: 0.0, duration: const Duration(milliseconds: 600));
    await _audioPlayer.stop();
    _bgController.stop();

    setState(() {
      _isPlaying = false;
      _isPaused = false;
      _remainingSeconds = 0;
      _fadeLevel = 0.0;
    });

    _toast("Session stopped");
    HapticFeedback.selectionClick();
  }

  void _startCountdown() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
        _onComplete();
      }
    });
  }

  void _resumeCountdown() => _startCountdown();

  Future<void> _onComplete() async {
    await _stopSession();
    if (!mounted) return;
    _showSessionCompleteDialog();
  }

  // ── Fade Audio ───────────────────────────────
  Future<void> _fadeAudio({
    required double to,
    Duration duration = const Duration(seconds: 2),
  }) async {
    _fadeTimer?.cancel();

    final steps = 20;
    final stepDuration = duration ~/ steps;
    final delta = (to - _currentVolume) / steps;

    _fadeTimer = Timer.periodic(stepDuration, (t) async {
      _currentVolume += delta;
      _currentVolume = _currentVolume.clamp(0.0, 1.0);
      await _audioPlayer.setVolume(_currentVolume);
      setState(() {
        final target = _volume == 0 ? 1.0 : _volume;
        _fadeLevel = (_currentVolume / target).clamp(0.0, 1.0);
      });

      final doneIncreasing = delta >= 0 && _currentVolume >= to - 0.001;
      final doneDecreasing = delta < 0 && _currentVolume <= to + 0.001;
      if (doneIncreasing || doneDecreasing) {
        t.cancel();
        _currentVolume = to;
        await _audioPlayer.setVolume(_currentVolume);
      }
    });
  }

  Future<void> _resumeAudioWithFade() async {
    try {
      await _audioPlayer.resume();
      await _fadeAudio(to: _volume, duration: const Duration(seconds: 1));
    } catch (e) {
      debugPrint('Resume error: $e');
    }
  }

  // ── UI Helpers ───────────────────────────────
  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSessionCompleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Session Complete"),
        content: const Text("Your relaxation session is complete."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  Color _glowColorForCategory(String category) {
    switch (category) {
      case 'Nature':
        return const Color(0xFF4FC3F7);
      case 'Ambient':
        return const Color(0xFF80CBC4);
      case 'Meditation':
        return const Color(0xFFB388FF);
      default:
        return const Color(0xFF6A5AE0);
    }
  }

  // ── Build ───────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isLocked = _isPlaying || _isPaused;

    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Relaxation Sounds",
            style: TextStyle(color: Colors.white), // White text
          ),
          backgroundColor: const Color(0xFF6A5AE0),
          iconTheme: const IconThemeData(color: Colors.white), // White back arrow
        ),
      body: AnimatedBuilder(
        animation: _bgCurve,
        builder: (context, _) {
          final color1 = Color.lerp(
            const Color(0xFF6A5AE0).withOpacity(0.1 + 0.3 * _fadeLevel),
            const Color(0xFF9C27B0).withOpacity(0.3 + 0.3 * _fadeLevel),
            _bgCurve.value,
          );
          final color2 = Color.lerp(
            Colors.white.withOpacity(0.9 - 0.4 * _fadeLevel),
            const Color(0xFFE1BEE7).withOpacity(0.4 + 0.4 * _fadeLevel),
            _bgCurve.value,
          );

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color1 ?? Colors.purple, color2 ?? Colors.white],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (_isPlaying)
                      _HeaderGlow(
                        curveValue: _bgCurve.value,
                        fadeLevel: _fadeLevel,
                        category: _selectedSound?.category ?? 'Nature',
                        title: _selectedSound?.name ?? "",
                        timeText: _formatTime(_remainingSeconds),
                        progress: _progress,
                        colorForCategory: _glowColorForCategory,
                      ),
                    const SizedBox(height: 16),
                    _CategoryChips(
                      categories: _categories,
                      selected: _selectedCategory,
                      onSelected: (c) => setState(() => _selectedCategory = c),
                      isLocked: isLocked,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: _SoundList(
                        sounds: _filteredSounds,
                        selected: _selectedSound,
                        isPlaying: _isPlaying,
                        isPaused: _isPaused,
                        onSelect: (s) => setState(() => _selectedSound = s),
                      ),
                    ),
                    if (_selectedSound != null) ...[
                      const SizedBox(height: 6),
                      _VolumeControl(
                        volume: _volume,
                        onChanged: (v) async {
                          setState(() => _volume = v);
                          if (_isPlaying && !_isPaused) {
                            _currentVolume = v.clamp(0.0, 1.0);
                            await _audioPlayer.setVolume(_currentVolume);
                          }
                        },
                      ),
                    ],
                    const SizedBox(height: 10),
                    if (!_isPlaying)
                      _DurationSelector(
                        values: const [5, 10, 15, 30],
                        selected: _sessionMinutes,
                        onSelect: (m) => setState(() => _sessionMinutes = m),
                      ),
                    const SizedBox(height: 18),
                    _buildControlButtons(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildControlButtons() {
    if (!_isPlaying) {
      return ElevatedButton.icon(
        onPressed: _selectedSound != null ? _startSession : null,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Start Session'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: _isPaused ? _startSession : _pauseSession,
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            label: Text(_isPaused ? 'Resume' : 'Pause'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9800),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: _stopSession,
            icon: const Icon(Icons.stop),
            label: const Text('Stop'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ],
      );
    }
  }
}

// ── Extracted Widgets ───────────────────────────────

class _CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;
  final bool isLocked;

  const _CategoryChips({
    required this.categories,
    required this.selected,
    required this.onSelected,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isLocked ? 0.5 : 1.0,
      child: IgnorePointer(
        ignoring: isLocked,
        child: SizedBox(
          height: 45,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final c = categories[i];
              final isSel = c == selected;
              return ChoiceChip(
                label: Text(c),
                selected: isSel,
                selectedColor: const Color(0xFF6A5AE0),
                backgroundColor: Colors.white,
                onSelected: (_) => onSelected(c),
                labelStyle:
                    TextStyle(color: isSel ? Colors.white : const Color(0xFF6A5AE0)),
                side: const BorderSide(color: Color(0xFF6A5AE0)),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SoundList extends StatelessWidget {
  final List<RelaxationSound> sounds;
  final RelaxationSound? selected;
  final bool isPlaying;
  final bool isPaused;
  final ValueChanged<RelaxationSound> onSelect;

  const _SoundList({
    required this.sounds,
    required this.selected,
    required this.isPlaying,
    required this.isPaused,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = isPlaying || isPaused;

    return ListView.builder(
      itemCount: sounds.length,
      itemBuilder: (_, i) {
        final s = sounds[i];
        final isSel = selected == s;
        final playingThis = isPlaying && isSel;

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isLocked && !isSel ? 0.5 : 1.0,
          child: IgnorePointer(
            ignoring: isLocked && !isSel,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isSel
                    ? const Color(0xFF6A5AE0).withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: isSel
                    ? Border.all(color: const Color(0xFF6A5AE0), width: 2)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(s.icon, color: const Color(0xFF6A5AE0)),
                title: Text(s.name),
                subtitle: Text(s.description),
                trailing: playingThis
                    ? const Icon(Icons.equalizer, color: Color(0xFF4CAF50))
                    : Icon(Icons.play_circle_outline, color: Colors.grey[400]),
                onTap: () => onSelect(s),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VolumeControl extends StatelessWidget {
  final double volume;
  final ValueChanged<double> onChanged;

  const _VolumeControl({required this.volume, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.volume_down, color: Color(0xFF6A5AE0)),
            Expanded(
              child: Slider(
                value: volume,
                onChanged: onChanged,
                activeColor: const Color(0xFF6A5AE0),
                inactiveColor: const Color(0xFF6A5AE0).withOpacity(0.3),
              ),
            ),
            const Icon(Icons.volume_up, color: Color(0xFF6A5AE0)),
          ],
        ),
        Text('Volume: ${(volume * 100).round()}%',
            style: const TextStyle(color: Color(0xFF666666))),
      ],
    );
  }
}

class _DurationSelector extends StatelessWidget {
  final List<int> values;
  final int selected;
  final ValueChanged<int> onSelect;

  const _DurationSelector({
    required this.values,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: values.map((min) {
        final isSel = selected == min;
        return GestureDetector(
          onTap: () => onSelect(min),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: isSel ? const Color(0xFF6A5AE0) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF6A5AE0), width: 2),
            ),
            child: Text(
              '${min}m',
              style: TextStyle(
                color: isSel ? Colors.white : const Color(0xFF6A5AE0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _HeaderGlow extends StatelessWidget {
  final double curveValue;
  final double fadeLevel;
  final String category;
  final String title;
  final String timeText;
  final double progress;
  final Color Function(String) colorForCategory;

  const _HeaderGlow({
    required this.curveValue,
    required this.fadeLevel,
    required this.category,
    required this.title,
    required this.timeText,
    required this.progress,
    required this.colorForCategory,
  });

  @override
  Widget build(BuildContext context) {
    final glowSize = 150 + 50 * curveValue * (0.5 + fadeLevel);
    final glowColor = colorForCategory(category);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: glowSize,
          height: glowSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                glowColor.withOpacity(0.45 + 0.3 * fadeLevel),
                Colors.transparent,
              ],
            ),
          ),
        ),
        SizedBox(
          width: 140,
          height: 140,
          child: CircularProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            strokeWidth: 6,
          ),
        ),
        Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A5AE0),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              timeText,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
