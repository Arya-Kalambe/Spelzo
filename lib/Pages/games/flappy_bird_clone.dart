// flappy_bird_clone.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(const MaterialApp(home: FlappyBird()));

class FlappyBird extends StatefulWidget {
  const FlappyBird({super.key});

  @override
  State<FlappyBird> createState() => _FlappyBirdState();
}

class _FlappyBirdState extends State<FlappyBird> with SingleTickerProviderStateMixin {
  double birdY = 0;
  double time = 0;
  double height = 0;
  double initialHeight = 0;
  bool gameStarted = false;

  double barrierX1 = 1.5;
  double barrierX2 = 3;
  double barrierHeight1 = 0.4;
  double barrierHeight2 = 0.3;

  int score = 0;
  int timeLeft = 30;
  Timer? gameTimer;
  Timer? countdownTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
  }

  void _playBackgroundMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('audio/bg_music.mp3'));
  }

  void startGame() {
    gameStarted = true;
    time = 0;
    initialHeight = birdY;
    timeLeft = 30;
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft <= 0) {
        t.cancel();
        gameTimer?.cancel();
        gameOver();
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });
    gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      time += 0.05;
      height = -2.5 * time * time + 2 * time;
      setState(() {
        birdY = initialHeight - height;
        barrierX1 -= 0.05;
        barrierX2 -= 0.05;
      });

      if (barrierX1 < -2) {
        barrierX1 += 3.5;
        barrierHeight1 = (0.2 + 0.5 * (1 + time) % 1);
        score++;
      }
      if (barrierX2 < -2) {
        barrierX2 += 3.5;
        barrierHeight2 = (0.2 + 0.5 * (1 + time / 2) % 1);
        score++;
      }

      if (birdY > 1.1 || birdY < -1.1 || _isColliding()) {
        gameTimer?.cancel();
        countdownTimer?.cancel();
        gameOver();
      }
    });
  }

  bool _isColliding() {
    const gap = 0.4;
    if ((barrierX1 < 0.2 && barrierX1 > -0.2) && (birdY < -barrierHeight1 || birdY > (gap - barrierHeight1))) {
      return true;
    }
    if ((barrierX2 < 0.2 && barrierX2 > -0.2) && (birdY < -barrierHeight2 || birdY > (gap - barrierHeight2))) {
      return true;
    }
    return false;
  }

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdY;
    });
  }

  void resetGame() {
    setState(() {
      birdY = 0;
      gameStarted = false;
      barrierX1 = 1.5;
      barrierX2 = 3;
      barrierHeight1 = 0.4;
      barrierHeight2 = 0.3;
      score = 0;
      timeLeft = 30;
    });
  }

  void gameOver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    countdownTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameStarted ? jump : startGame,
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 0),
              alignment: Alignment(0, birdY),
              color: Colors.transparent,
              child: const Text("🐤", style: TextStyle(fontSize: 40)),
            ),
            Container(
              alignment: Alignment(barrierX1, -1),
              child: Container(
                width: 60,
                height: MediaQuery.of(context).size.height * barrierHeight1,
                color: Colors.green,
              ),
            ),
            Container(
              alignment: Alignment(barrierX1, 1),
              child: Container(
                width: 60,
                height: MediaQuery.of(context).size.height * (1 - barrierHeight1 - 0.4),
                color: Colors.green,
              ),
            ),
            Container(
              alignment: Alignment(barrierX2, -1),
              child: Container(
                width: 60,
                height: MediaQuery.of(context).size.height * barrierHeight2,
                color: Colors.green,
              ),
            ),
            Container(
              alignment: Alignment(barrierX2, 1),
              child: Container(
                width: 60,
                height: MediaQuery.of(context).size.height * (1 - barrierHeight2 - 0.4),
                color: Colors.green,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Score: $score", style: const TextStyle(color: Colors.white, fontSize: 22)),
                    const SizedBox(height: 8),
                    Text("Time Left: $timeLeft", style: const TextStyle(color: Colors.white, fontSize: 22)),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("BACK"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
