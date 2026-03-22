import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetrism3/main.dart';
import 'tetromino.dart';
import 'pixel.dart';

// 2D board list with occupied spaces
List<List<Shape?>> board = List.generate(
  colLenght,
  (i) => List.generate(rowLenght,
    (j) => null,
  ),
);


class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {

  Tetromino currentTetromino = Tetromino(type: Shape.Z);

  int score = 0;
  bool gameOver = false;
  Duration frameRate = const Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();

    startGame();
  }

  void startGame() {
    createPiece();
    currentTetromino.initPiece();
    game(frameRate);
  }

  void game(Duration frameRate) {
    Timer.periodic(
      frameRate,
      (timer) {
        setState(() {
          clearLines();
          checkLanded();
          if(gameOver) {
            timer.cancel();

            showDialog(context: context, barrierDismissible: false, builder: (context) => AlertDialog(
              title: Text("Game Over"),
              content: Text("Score: $score"),
              actions: [
                TextButton(
                  onPressed: () {
                    restartGame();
                    Navigator.pop(context);
                  },
                  child: Text("Play again"),
                )
              ],
            ),);

          }
          currentTetromino.movePiece(Direction.down);
        });
      }
    );
  }

  void restartGame() {
    board = List.generate(
      colLenght,
      (i) => List.generate(rowLenght,
        (j) => null,
      ),
    );

    gameOver = false;
    score = 0;
    frameRate = const Duration(milliseconds: 400);
    createPiece();
    startGame();
  }

  bool collision(Direction direction) {
    for (int i = 0; i < currentTetromino.pos.length; i++) {
      int row = (currentTetromino.pos[i] / rowLenght).floor();
      int col = currentTetromino.pos[i] % rowLenght;

      // adjust current row/col based on direction
      switch (direction) {
        case Direction.left: col--; break;
        case Direction.right: col++; break;
        case Direction.down: row++; break;
      }

      // out of bounds
      if (row >= colLenght || col < 0 || col >= rowLenght) {
        return true;
      }

      // on top of other piece
      if (row >= 0 && board[row][col] != null) {
        return true;
      }
    }
    return false;
  }

  bool checkLanded() {
    if (collision(Direction.down)) {
      // mark position as occupied
      for (int i = 0; i < currentTetromino.pos.length; i++) {
        int row = (currentTetromino.pos[i] / rowLenght).floor();
        int col = currentTetromino.pos[i] % rowLenght;

        if (row >= 0 && col >= 0) {
          board[row][col] = currentTetromino.type;
        }
      }
      createPiece();
      score += 2;
      return true;
    }
    return false;
  }

  void createPiece() {
    Random rand = Random();
    Shape randomShape = Shape.values[rand.nextInt(Shape.values.length)];
    currentTetromino = Tetromino(type: randomShape);
    currentTetromino.initPiece();
    if(isGameOver()) {
      gameOver = true;
    }
  }

  void moveLeft() {
    if (!collision(Direction.left)) {
      setState(() {
        currentTetromino.movePiece(Direction.left);
      });
      HapticFeedback.lightImpact();
    }
    else {HapticFeedback.errorNotification();}
  }

  void moveRight() {
    if (!collision(Direction.right)) {
      setState(() {
        currentTetromino.movePiece(Direction.right);
      });
      HapticFeedback.lightImpact();
    }
    else {HapticFeedback.errorNotification();}
  }

  void rotate() {
    HapticFeedback.lightImpact();
    setState(() {
      currentTetromino.rotatePiece();
    });
  }

  void drop() {
    if (!collision(Direction.down)) {
      do {
        currentTetromino.movePiece(Direction.down);
      } while (checkLanded() == false);
      setState(() {
        score += 2;
      });
      HapticFeedback.errorNotification();
    }
  }

  void clearLines() {
    for (int row = colLenght - 1; row >= 0; row--) {
      bool rowFull = true;

      for (int col = 0; col < rowLenght; col++) {
        if (board[row][col] == null) {
          rowFull = false;
          break;
        }
      }

      if (rowFull) {
        for (int r = row; r > 0; r--) {
          board[r] = List.from(board[r-1]);
        }

        board[0] = List.generate(row, (index) => null);

        score += 100;
        frameRate = Duration(milliseconds: frameRate.inMilliseconds-20);
      }
    }
  }

  bool isGameOver() {
    for (int col = 0; col < rowLenght; col++) {
      if (board[0][col] != null) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      score.toString(),
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        nothingOScolorscheme.value = !nothingOScolorscheme.value;
                      },
                      icon: const Icon(Icons.brush_rounded),
                    ),
                  )
                ]
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final boardAspect = rowLenght / colLenght;

                  double boardW = constraints.maxWidth * .9;
                  double boardH = boardW / boardAspect;

                  if (boardH > constraints.maxHeight) {
                    boardH = constraints.maxHeight;
                    boardW = boardH * boardAspect;
                  }

                  return Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Container(
                        width: boardW + 16, // padding
                        height: boardH + 16,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: GridView.builder(
                          itemCount: rowLenght * colLenght,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: rowLenght,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            int row = (index / rowLenght).floor();
                            int col = index % rowLenght;

                            // moving piece
                            if (currentTetromino.pos.contains(index)) {
                              return Pixel(color: Theme.of(context).colorScheme.onSecondaryContainer);

                            // landed piece
                            } else if (board[row][col] != null) {
                              return Pixel(color: Theme.of(context).colorScheme.primary);

                            // empty piece                            
                            } else {
                              return Pixel(color: Theme.of(context).colorScheme.secondaryContainer);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 64),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(elevation: 0, onPressed: moveLeft, child: Icon(Icons.keyboard_arrow_left_rounded)),
                  FloatingActionButton(elevation: 0, onPressed: moveRight, child: Icon(Icons.keyboard_arrow_right_rounded)),
                  FloatingActionButton(elevation: 0, onPressed: drop, child: Icon(Icons.keyboard_arrow_down_rounded)),
                  FloatingActionButton(elevation: 0, onPressed: rotate, child: Icon(Icons.rotate_left_rounded)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}