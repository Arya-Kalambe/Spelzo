import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'find_diff_data.dart';

class FindDifferenceGame extends StatefulWidget {
  const FindDifferenceGame({super.key});

  @override
  State<FindDifferenceGame> createState() => _FindDifferenceGameState();
}

class _FindDifferenceGameState extends State<FindDifferenceGame> {
  int currentLevel = 0;
  int score = 0;
  int timeLeft = 60;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<bool> found = [];

  @override
  void initState() {
    super.initState();
    _startLevel();
  }

  void _startLevel() {
    final level = levels[currentLevel];
    found = List<bool>.filled(level.spots.length, false);
    timeLeft = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
        if (timeLeft == 0) {
          timer.cancel();
          _showGameOver();
        }
      });
    });
  }

  void _handleTap(TapDownDetails details, double imageScale) {
    final tap = details.localPosition / imageScale;
    final spots = levels[currentLevel].spots;

    for (int i = 0; i < spots.length; i++) {
      if (!found[i] && (tap - spots[i]).distance < 20) {
        found[i] = true;
        score++;
        _playSound('assets/sounds/correct.mp3');
        setState(() {});
        break;
      }
    }

    if (found.every((f) => f)) {
      _timer?.cancel();
      _showNextLevelDialog();
    }
  }

  void _hintOne() {
    for (int i = 0; i < found.length; i++) {
      if (!found[i]) {
        setState(() {
          found[i] = true;
          score++;
        });
        _playSound('assets/sounds/correct.mp3');
        break;
      }
    }

    if (found.every((f) => f)) {
      _timer?.cancel();
      _showNextLevelDialog();
    }
  }

  void _showNextLevelDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Level Complete!'),
        content: Text('Great job! Score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _nextLevel();
            },
            child: const Text('Next Level'),
          ),
        ],
      ),
    );
  }

  void _nextLevel() {
    if (currentLevel + 1 < levels.length) {
      setState(() {
        currentLevel++;
      });
      _startLevel();
    } else {
      _showFinalDialog();
    }
  }

  void _showFinalDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('🎉 Game Finished!'),
        content: Text('Total Score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _restartGame() {
    setState(() {
      currentLevel = 0;
      score = 0;
    });
    _startLevel();
  }

  void _showGameOver() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('⏱️ Time Over!'),
        content: Text('Score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartGame();
            },
            child: const Text('Try Again'),
          )
        ],
      ),
    );
  }

  Future<void> _playSound(String assetPath) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(assetPath.replaceFirst('assets/', '')));
    } catch (e) {
      print("Sound error: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final level = levels[currentLevel];
    final imageWidth = MediaQuery.of(context).size.width * 0.95;
    final imageScale = imageWidth / 300;


    return Scaffold(
      appBar: AppBar(
        title: Text("Level ${currentLevel + 1}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            tooltip: "Hint",
            onPressed: _hintOne,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restartGame,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text("Score: $score", style: const TextStyle(fontSize: 20)),
          Text("Time Left: $timeLeft sec", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          GestureDetector(
            onTapDown: (details) => _handleTap(details, imageScale),
            child: Stack(
              children: [
                Image.asset(level.editedImage, width: imageWidth),
                for (int i = 0; i < level.spots.length; i++)
                  if (found[i])
                    Positioned(
                      left: level.spots[i].dx * imageScale - 10,
                      top: level.spots[i].dy * imageScale - 10,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.withOpacity(0.6),
                          border: Border.all(color: Colors.white),
                        ),
                      ),
                    ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Image.asset(level.originalImage, width: imageWidth),
        ],
      ),
    );
  }
}