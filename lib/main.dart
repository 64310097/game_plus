import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() => runApp(MyApp());

const maxWidth = 1350.0;
const maxHeight = 400.0;
const shapeSize = 50.0;
const numShapes = 30;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<MyShape> shapes = [];
  int score = 0;
  bool isGameStarted = false;
  Duration gameDuration = Duration.zero;
  Timer? gameTimer;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isGameStarted ? buildGameScreen() : buildStartScreen();
  }

  Widget buildStartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'วิธีเล่น:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('คลิกที่วงกลมสีแดงเพื่อลดคะแนน'),
          Text('คลิกที่วงกลมสีเขียวเพื่อเพิมคะแนน'),
          ElevatedButton(
            onPressed: () {
              startGame();
            },
            child: Text('Start Game'),
          ),
        ],
      ),
    );
  }

  Widget buildShapes() {
    return Container(
      width: maxWidth,
      height: maxHeight,
      child: Stack(
        children: shapes.map((shape) {
          return GestureDetector(
            onTap: () {
              onShapeClick(shape);
            },
            child: shape.isVisible
                ? Container(
                    width: shapeSize,
                    height: shapeSize,
                    margin: EdgeInsets.only(
                      left: shape.x,
                      top: shape.y,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 3.0,
                      ),
                      color: shape.isAdd ? Colors.green : Colors.red,
                    ),
                  )
                : Container(),
          );
        }).toList(),
      ),
    );
  }

  void startGame() {
    setState(() {
      score = 0;
      shapes = List.generate(numShapes, (index) {
        final shape = createRandomShape(shapes);
        shape.isAdd = Random().nextBool();
        return shape;
      });

      gameDuration = Duration.zero;

      if (gameTimer != null) {
        gameTimer?.cancel();
      }
      gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          gameDuration += Duration(seconds: 1);
          if (!shapes.any((shape) => shape.isVisible && shape.isAdd)) {
            timer.cancel();
            isGameOver = true;
          }
        });
      });

      isGameStarted = true;
      isGameOver = false;
    });
  }

  MyShape createRandomShape(List<MyShape> existingShapes) {
    final random = Random();
    double x, y;
    bool isOverlapping;

    do {
      isOverlapping = false;
      x = random.nextDouble() * maxWidth;
      y = random.nextDouble() * maxHeight;

      for (final shape in existingShapes) {
        final dx = shape.x - x;
        final dy = shape.y - y;
        final distance = sqrt(dx * dx + dy * dy);
        if (distance < shapeSize) {
          isOverlapping = true;
          break;
        }
      }
    } while (isOverlapping);

    return MyShape(x: x, y: y);
  }

  Widget buildScoreScreen() {
    String timeLabelScoreScreen =
        '${gameDuration.inMinutes} minute ${gameDuration.inSeconds.remainder(60)} seconds';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Score: $score'),
          Text(
            'Time: $timeLabelScoreScreen',
          ),
          ElevatedButton(
            onPressed: () {
              startGame();
              isGameOver = false;
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }

  Widget buildGameScreen() {
    String timeLabelGameScreen =
        '${gameDuration.inMinutes} minutes ${gameDuration.inSeconds.remainder(60)} seconds';
    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
      ),
      body: Column(
        children: [
          buildShapes(),
          Text('Score: $score'),
          Text(
            'Time: $timeLabelGameScreen',
          ),
          if (isGameOver) buildScoreScreen(),
        ],
      ),
    );
  }

  void onShapeClick(MyShape shape) {
    if (shape.isVisible) {
      setState(() {
        if (shape.isAdd) {
          score++;
        } else {
          score--;
        }
        shape.isVisible = false;

        if (!shapes.any((shape) => shape.isVisible && shape.isAdd)) {
          isGameOver = true;
          gameTimer?.cancel();
        }
      });
    }
  }
}

class MyShape {
  double x;
  double y;
  bool isVisible;
  bool isAdd;

  MyShape({required this.x, required this.y})
      : isVisible = true,
        isAdd = false;
}
