import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  final int gridSize = 4;
  late List<CardModel> cards;
  CardModel? firstSelected;
  CardModel? secondSelected;
  bool canTap = true;
  int score = 0;

  // Timer
  Timer? _timer;
  int secondsPassed = 0;
  bool isTimerRunning = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initializeCards();
  }

  void _initializeCards() {
    List<String> emojis = [
      '🚗', '🏎️', '🚐', '🚚',
      '🚌', '🛺', '🏍️', '🚕'
    ];
    List<String> cardContent = [...emojis, ...emojis];
    cardContent.shuffle(Random());

    cards = List.generate(cardContent.length, (index) {
      return CardModel(id: index, content: cardContent[index]);
    });

    setState(() {
      score = 0;
      secondsPassed = 0;
      isTimerRunning = false;
      _timer?.cancel();
      firstSelected = null;
      secondSelected = null;
    });
  }

  void _startTimer() {
    isTimerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsPassed++;
      });
    });
  }

  void _onCardTapped(CardModel card) {
    if (!canTap || card.isMatched || card.isFlipped) return;

    if (!isTimerRunning) {
      _startTimer();
    }

    setState(() {
      card.isFlipped = true;
    });

    if (firstSelected == null) {
      firstSelected = card;
    } else {
      secondSelected = card;
      canTap = false;

      if (firstSelected!.content == secondSelected!.content) {
        _playSound('assets/sounds/correct.mp3');
        setState(() {
          firstSelected!.isMatched = true;
          secondSelected!.isMatched = true;
          score += 10;
        });
        _resetTurn();
        _checkGameFinished();
      } else {
        _playSound('assets/sounds/wrong.mp3');
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            firstSelected!.isFlipped = false;
            secondSelected!.isFlipped = false;
          });
          _resetTurn();
        });
      }
    }
  }

  void _checkGameFinished() {
    bool allMatched = cards.every((card) => card.isMatched);
    if (allMatched) {
      _timer?.cancel();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('🎉 Game Over!'),
          content: Text('Score: $score\nTime: ${_formatTime(secondsPassed)}'),
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
  }

  void _resetTurn() {
    setState(() {
      firstSelected = null;
      secondSelected = null;
      canTap = true;
    });
  }

  void _restartGame() {
    _initializeCards();
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _playSound(String assetPath) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(assetPath.replaceFirst('assets/', '')));
    } catch (e) {
      print('Sound error: $e');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: _restartGame,
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text("Score: $score", style: const TextStyle(fontSize: 20)),
          Text("Time: ${_formatTime(secondsPassed)}",
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cards.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                CardModel card = cards[index];
                return GestureDetector(
                  onTap: () => _onCardTapped(card),
                  child: Container(
                    decoration: BoxDecoration(
                      color: card.isMatched || card.isFlipped
                          ? Colors.white
                          : Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.black26,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        card.isMatched || card.isFlipped ? card.content : '',
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardModel {
  final int id;
  final String content;
  bool isFlipped;
  bool isMatched;

  CardModel({
    required this.id,
    required this.content,
    this.isFlipped = false,
    this.isMatched = false,
  });
}