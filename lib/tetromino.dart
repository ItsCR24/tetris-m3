import 'package:tetrism3/board.dart';

int rowLenght = 10;
int colLenght = 20;

enum Shape {
  I,
  O,
  T,
  J,
  L,
  S,
  Z,
}

enum Direction {
  left,
  right,
  down
}

class Tetromino {
  Shape type;
  Tetromino({required this.type});

  List<int> pos = [];

  //generate ints for position
  void initPiece() {
    switch (type) {
      case Shape.L:
        pos = [-26, -16, -6, -5];
        break;
      case Shape.J:
        pos = [-25, -15, -5, -6];
        break;
      case Shape.I:
        pos = [-7, -6, -5, -4];
        break;
      case Shape.O:
        pos = [-16, -15, -6, -5];
        break;
      case Shape.S:
        pos = [-7, -6, -16, -15];
        break;
      case Shape.Z:
        pos = [-17, -16, -6, -5];
        break;
      case Shape.T:
        pos = [-17, -16, -15, -6];
        break;
    }
  }

  //move piece
  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < pos.length; i++) { pos[i] += rowLenght; }
        break;
      case Direction.left:
        for (int i = 0; i < pos.length; i++) { pos[i] -= 1; }
        break;
      case Direction.right:
        for (int i = 0; i < pos.length; i++) { pos[i] += 1; }
        break;
    }
  }

  int rotationState = 0;

  void rotatePiece() {

    List<int> newPos = [];

    switch (type) {
      case Shape.I:
        switch (rotationState) {
          case 0:
            newPos = [
              pos[1] - rowLenght,
              pos[1],
              pos[1] + rowLenght,
              pos[1] + rowLenght*2
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPos = [
              pos[1] - 1,
              pos[1],
              pos[1] + 1,
              pos[1] + 2
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPos = [
              pos[1] - rowLenght,
              pos[1],
              pos[1] + rowLenght,
              pos[1] + rowLenght*2
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPos = [
              pos[1] - 1,
              pos[1],
              pos[1] + 1,
              pos[1] + 2
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;
        
      case Shape.O:
        break;
        
      case Shape.T:
        switch(rotationState) {
          case 0:
            newPos = [
              pos[1] - rowLenght,
              pos[1],
              pos[1] + rowLenght,
              pos[1] - 1
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPos = [
              pos[1] - 1,
              pos[1],
              pos[1] + 1,
              pos[1] - rowLenght
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPos = [
              pos[1] - rowLenght,
              pos[1],
              pos[1] + rowLenght,
              pos[1] + 1
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPos = [
              pos[1] - 1,
              pos[1],
              pos[1] + 1,
              pos[1] + rowLenght
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }

      case Shape.J:
        switch(rotationState) {
          case 0:
            newPos = [
              pos[1] - 1,
              pos[1],
              pos[1] + 1,
              pos[1] + 1 + rowLenght
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPos = [
              pos[1] + rowLenght,
              pos[1],
              pos[1] - rowLenght,
              pos[1] - rowLenght + 1
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPos = [
              pos[1] - rowLenght - 1,
              pos[1],
              pos[1] - 1,
              pos[1] + 1
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPos = [
              pos[1] - rowLenght,
              pos[1],
              pos[1] + rowLenght,
              pos[1] + rowLenght - 1
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }

      case Shape.L:
        switch(rotationState) {
          case 0:
            newPos = [
              pos[1] - 1,
              pos[1],
              pos[1] + 1,
              pos[1] + 1 - rowLenght
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPos = [
              pos[1] + rowLenght,
              pos[1],
              pos[1] - rowLenght,
              pos[1] - rowLenght - 1
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPos = [
              pos[1] + rowLenght - 1,
              pos[1],
              pos[1] - 1,
              pos[1] + 1
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPos = [
              pos[1] - rowLenght,
              pos[1],
              pos[1] + rowLenght,
              pos[1] + rowLenght + 1
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }

      case Shape.S:
        switch(rotationState) {
          case 0:
            newPos = [
              pos[2] + rowLenght,
              pos[2] - 1,
              pos[2],
              pos[2] - rowLenght - 1
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPos = [
              pos[2] + 1,
              pos[2] + rowLenght,
              pos[2],
              pos[2] + rowLenght - 1
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPos = [
              pos[2] + rowLenght,
              pos[2] - 1,
              pos[2],
              pos[2] - rowLenght - 1
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPos = [
              pos[2] + 1,
              pos[2] + rowLenght,
              pos[2],
              pos[2] + rowLenght - 1
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }

      case Shape.Z:
        switch(rotationState) {
          case 0:
            newPos = [
              pos[1] - rowLenght,
              pos[1],
              pos[1] - 1,
              pos[1] - 1 + rowLenght
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPos = [
              pos[1] - 1,
              pos[1],
              pos[1] + rowLenght,
              pos[1] + rowLenght + 1
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPos = [
              pos[1] - rowLenght,
              pos[1],
              pos[1] - 1,
              pos[1] - 1 + rowLenght
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPos = [
              pos[1] - 1,
              pos[1],
              pos[1] + rowLenght,
              pos[1] + rowLenght + 1
            ];
            if (piecePositionIsValid(newPos)) {
              pos = newPos;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
    }
  }

  bool validPosition(int position) {
    int row = (position / rowLenght).floor();
    int col = position % rowLenght;
    return (!(row < 0 || col < 0 || board[row][col] != null));
  }

  bool piecePositionIsValid(List<int> piecePos) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;
    
    for (int position in piecePos) {
      if (!validPosition(position)) {
        return false;
      }

      int col = position % rowLenght;

      // if both true, piece is going through a wall
      if (col == 0) firstColOccupied = true;
      if (col == rowLenght-1) lastColOccupied = true;
    }
    return !(firstColOccupied && lastColOccupied);
  }
}