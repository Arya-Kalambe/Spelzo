// coin_collector_game.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: CoinCollectorGame()));

class CoinCollectorGame extends StatefulWidget {
  const CoinCollectorGame({super.key});

  @override
  State<CoinCollectorGame> createState() => _CoinCollectorGameState();
}

class _CoinCollectorGameState extends State<CoinCollectorGame> {
  double playerX = 0;
  double playerY = 0;
  int score = 0;
  List<Offset> coins = [];
  final Random random = Random();

  int timeLeft = 15;
  late Timer gameTimer;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    spawnCoins();
    startTimer();
  }

  void startTimer() {
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft <= 0) {
        timer.cancel();
        endGame(false); // player loses
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });
  }

  void spawnCoins() {
    coins.clear();
    for (int i = 0; i < 5; i++) {
      coins.add(Offset(
        random.nextDouble() * 300,
        random.nextDouble() * 500,
      ));
    }
  }

  void movePlayer(double dx, double dy) {
    if (isGameOver) return;
    setState(() {
      playerX = (playerX + dx).clamp(0, 300);
      playerY = (playerY + dy).clamp(0, 500);
      checkCollision();
    });
  }

  void checkCollision() {
    coins.removeWhere((coin) {
      final distance = (Offset(playerX, playerY) - coin).distance;
      if (distance < 30) {
        score++;
        return true;
      }
      return false;
    });

    if (coins.isEmpty && !isGameOver) {
      gameTimer.cancel();
      endGame(true); // player wins
    }
  }

  void endGame(bool won) {
    setState(() {
      isGameOver = true;
    });
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(won ? 'You Win!' : 'Game Over'),
        content: Text(won ? 'You collected all coins!' : 'Time ran out!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text("Try Again"),
          )
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      playerX = 150;
      playerY = 250;
      score = 0;
      timeLeft = 15;
      isGameOver = false;
      spawnCoins();
      startTimer();
    });
  }

  @override
  void dispose() {
    gameTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      body: SafeArea(
        child: Stack(
          children: [
            ...coins.map((coin) => Positioned(
              left: coin.dx,
              top: coin.dy,
              child: const Text("🪙", style: TextStyle(fontSize: 28)),
            )),
            Positioned(
              left: playerX,
              top: playerY,
              child: const Text("🙂", style: TextStyle(fontSize: 32)),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Score: $score", style: const TextStyle(fontSize: 22)),
                  Text("Time: $timeLeft", style: const TextStyle(fontSize: 22)),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => movePlayer(-20, 0),
                      child: const Icon(Icons.arrow_left),
                    ),
                    ElevatedButton(
                      onPressed: () => movePlayer(0, -20),
                      child: const Icon(Icons.arrow_upward),
                    ),
                    ElevatedButton(
                      onPressed: () => movePlayer(20, 0),
                      child: const Icon(Icons.arrow_right),
                    ),
                    ElevatedButton(
                      onPressed: () => movePlayer(0, 20),
                      child: const Icon(Icons.arrow_downward),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: resetGame,
                    child: const Text("RESET"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("BACK"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
