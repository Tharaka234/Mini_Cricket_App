import 'dart:math';

class CricketGameState {
  int runs = 0;
  int balls = 6;
  String statusMessage = "";
  bool isGameOver = false;

  double dragY = 0.0;
  bool isDragging = false;
  final double maxDragDistance = 120.0;

  void playShot() {
    if (isGameOver) return;

    double power = (dragY.abs() / maxDragDistance).clamp(0.0, 1.0);
    int scored = 0;

    if (power > 0.1) {
      final random = Random();
      if (power > 0.8) {
        scored = random.nextBool() ? 6 : 4;
      } else if (power > 0.4) {
        scored = random.nextInt(4) + 1;
      } else {
        scored = random.nextInt(2);
      }
    } else {
      statusMessage = "Missed!";
      scored = 0;
    }

    if (power > 0.1) {
      runs += scored;
      statusMessage = scored == 0 ? "No Runs" : "$scored Runs";
    }

    balls--;
    dragY = 0;
    isDragging = false;

    if (balls <= 0) {
      isGameOver = true;
      statusMessage = "Game Over!";
    }
  }

  void resetGame() {
    runs = 0;
    balls = 6;
    statusMessage = "";
    isGameOver = false;
    dragY = 0;
    isDragging = false;
  }
}