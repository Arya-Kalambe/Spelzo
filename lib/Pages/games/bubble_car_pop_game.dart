import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BubbleCarPopGame extends StatefulWidget {
  @override
  _BubbleCarPopGameState createState() => _BubbleCarPopGameState();
}

class _BubbleCarPopGameState extends State<BubbleCarPopGame> {
  double carX = 0;
  Color carColor = Colors.red;
  int mistakes = 0;
  int score = 0;
  int topScore = 0;
  bool gameOver = false;

  double roadOffset = 0;

  final player = AudioPlayer();
  AudioPlayer? bgMusicPlayer;

  List<Color> bubbleColors = [Colors.red, Colors.green, Colors.blue, Colors.yellow];
  List<Bubble> bubbles = [];
  Random random = Random();
  Timer? gameTimer;
  Timer? carColorTimer;

  @override
  void initState() {
    super.initState();
    spawnBubbles();
    startGameLoop();
    startCarColorChange();
    loadTopScore();

    bgMusicPlayer = AudioPlayer();
    bgMusicPlayer!.setReleaseMode(ReleaseMode.loop);
    bgMusicPlayer!.play(AssetSource('sounds/bg_music.mp3'));
  }

  void loadTopScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      topScore = prefs.getInt('topScore') ?? 0;
    });
  }

  void saveTopScore() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('topScore', topScore);
  }

  void startGameLoop() {
    gameTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      updateBubbles();
      setState(() {
        roadOffset += 4;
        if (roadOffset >= MediaQuery.of(context).size.height) {
          roadOffset = 0;
        }
      });
    });
  }

  void startCarColorChange() {
    carColorTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      setState(() {
        carColor = bubbleColors[random.nextInt(bubbleColors.length)];
      });
    });
  }

  void spawnBubbles() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!gameOver) {
        setState(() {
          bubbles.add(Bubble(
            x: random.nextDouble() * 2 - 1,
            y: -1,
            color: bubbleColors[random.nextInt(bubbleColors.length)],
          ));
        });
      }
    });
  }

  void updateBubbles() {
    if (gameOver) return;

    setState(() {
      for (var bubble in bubbles) {
        bubble.y += 0.02;
      }

      bubbles.removeWhere((bubble) {
        if (bubble.y >= 1) return true;

        if ((bubble.y >= 0.9 && (bubble.x - carX).abs() < 0.2)) {
          if (bubble.color != carColor) {
            mistakes++;
            player.play(AssetSource('sounds/wrong.mp3'));
            if (mistakes > 3) {
              gameOver = true;
              gameTimer?.cancel();
              carColorTimer?.cancel();
              player.play(AssetSource('sounds/game_over.mp3'));
              if (score > topScore) {
                topScore = score;
                saveTopScore();
              }
            }
          } else {
            score++;
            player.play(AssetSource('sounds/pop.mp3'));
          }
          return true;
        }
        return false;
      });
    });
  }

  void moveCar(double delta) {
    if (gameOver) return;

    setState(() {
      carX += delta;
      carX = carX.clamp(-1.0, 1.0);
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    carColorTimer?.cancel();
    player.dispose();
    bgMusicPlayer?.stop();
    bgMusicPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ROAD LAYER (Looping vertically)
          Positioned.fill(
            child: Stack(
              children: [
                Positioned(
                  top: roadOffset - MediaQuery.of(context).size.height,
                  left: 0,
                  right: 0,
                  child: Image.asset('assets/images/road.png', fit: BoxFit.cover),
                ),
                Positioned(
                  top: roadOffset,
                  left: 0,
                  right: 0,
                  child: Image.asset('assets/images/road.png', fit: BoxFit.cover),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                moveCar(details.delta.dx * 0.01);
              },
              child: CustomPaint(
                painter: BubblePainter(bubbles),
              ),
            ),
          ),
          Align(
            alignment: Alignment(carX, 0.9),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: carColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 16,
            child: Text('Score: $score', style: TextStyle(color: Colors.white, fontSize: 22)),
          ),
          Positioned(
            top: 30,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Mistakes: $mistakes/3', style: TextStyle(color: Colors.redAccent, fontSize: 22)),
                SizedBox(height: 8),
                Text('Top Score: $topScore', style: TextStyle(color: Colors.orange, fontSize: 18)),
              ],
            ),
          ),
          if (gameOver)
            Center(
              child: Container(
                color: Colors.black,
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Game Over", style: TextStyle(color: Colors.red, fontSize: 36)),
                    SizedBox(height: 10),
                    Text("Final Score: $score", style: TextStyle(color: Colors.white)),
                    Text("Top Score: $topScore", style: TextStyle(color: Colors.orangeAccent)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        bgMusicPlayer!.play(AssetSource('sounds/bg_music.mp3'));
                        setState(() {
                          bubbles.clear();
                          carX = 0;
                          carColor = Colors.red;
                          mistakes = 0;
                          score = 0;
                          gameOver = false;
                          startGameLoop();
                          startCarColorChange();
                        });
                      },
                      child: Text("Play Again"),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Bubble {
  double x, y;
  Color color;

  Bubble({required this.x, required this.y, required this.color});
}

class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;

  BubblePainter(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var bubble in bubbles) {
      paint.color = bubble.color;
      double dx = (bubble.x + 1) / 2 * size.width;
      double dy = bubble.y * size.height;
      canvas.drawCircle(Offset(dx, dy), 20, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}