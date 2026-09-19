import 'package:flutter/material.dart';
import '../models/game_state.dart';

class CricketGameScreen extends StatefulWidget {
  const CricketGameScreen({super.key});

  @override
  State<CricketGameScreen> createState() => _CricketGameScreenState();
}

class _CricketGameScreenState extends State<CricketGameScreen> {
  final CricketGameState gameState = CricketGameState();
  final double circleSize = 45.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E88E5),
      appBar: AppBar(
        title: const Text(
          "Mini Cricket",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- Score Board ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIconTile(Icons.sports_cricket, Colors.orange[800]!),
                  Row(
                    children: [
                      _buildStatColumn("Runs", gameState.runs.toString()),
                      const SizedBox(width: 40),
                      _buildStatColumn("Balls", gameState.balls.toString()),
                    ],
                  ),
                  _buildIconTile(Icons.sports_baseball, Colors.red[400]!),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Status Message
            Text(
              gameState.statusMessage,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // --- Drag Control Area ---
            Expanded(
              child: gameState.isGameOver
                  ? Center(child: _buildRestartButton())
                  : _buildVerticalDragControl(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDragControl() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double bottomY = constraints.maxHeight * 0.75;

        return GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              gameState.isDragging = true;
              gameState.dragY = (gameState.dragY + details.delta.dy)
                  .clamp(-gameState.maxDragDistance, 0.0);
            });
          },
          onPanEnd: (details) {
            setState(() {
              gameState.playShot();
            });
          },
          child: Stack(
            children: [
              // 1. Green Line Widget (CustomPaint widget eka)
              Positioned.fill(
                child: CustomPaint(

                  painter: UpwardLinePainter(
                    bottomY: bottomY,
                    dragY: gameState.dragY,
                    isDragging: gameState.isDragging,
                  ),
                ),
              ),

              // 2. Bottom Draggable Circle ("Bat")
              Positioned(
                top: bottomY + gameState.dragY,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: circleSize + 10,
                    height: circleSize + 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF0D47A1),
                      border: Border.all(color: Colors.cyanAccent, width: 2),
                      boxShadow: gameState.isDragging
                          ? [const BoxShadow(color: Colors.black38, blurRadius: 10)]
                          : [],
                    ),
                    child: const Center(
                      child: Text(
                        "Bat",
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRestartButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          gameState.resetGame();
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      child: const Text("Restart", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildIconTile(IconData icon, Color color) {
    return Container(
      width: 75, height: 75,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
      child: Icon(icon, size: 50, color: color),
    );
  }
}


class UpwardLinePainter extends CustomPainter {
  final double bottomY;
  final double dragY;
  final bool isDragging;

  UpwardLinePainter({
    required this.bottomY,
    required this.dragY,
    required this.isDragging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    final startPoint = Offset(centerX, bottomY - 15);
    final endPoint = Offset(centerX, bottomY + dragY + 25);

    final linePaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 2.0;

    canvas.drawLine(startPoint, endPoint, linePaint);
  }

  @override
  bool shouldRepaint(covariant UpwardLinePainter oldDelegate) {
    return oldDelegate.dragY != dragY || oldDelegate.isDragging != isDragging;
  }
}