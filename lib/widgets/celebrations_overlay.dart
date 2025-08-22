// In brightsprings/widgets/celebrations_overlay.dart
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart'; // You might need to add this to pubspec.yaml

class CelebrationOverlay extends StatefulWidget {
  final VoidCallback onDone;

  const CelebrationOverlay({Key? key, required this.onDone}) : super(key: key);

  @override
  _CelebrationOverlayState createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    _confettiController.play();
    _fadeController.forward().then((_) {
      Future.delayed(const Duration(seconds: 2), () {
        _fadeController.reverse().then((_) {
          widget.onDone();
        });
      });
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Stack(
        children: [
          // Confetti particle system
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive, // All directions
              shouldLoop: false,
              colors: const [
                Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple
              ],
              // emissionFrequency: 0.05,
              numberOfParticles: 50,
              maxBlastForce: 100,
              minBlastForce: 80,
            ),
          ),
          // Optional: Add a subtle overlay to dim the background
          Container(
            color: Colors.black.withOpacity(0.3 * _fadeAnimation.value),
          ),
          // Optional: You can add celebratory text here
          Center(
            child: ScaleTransition(
              scale: _fadeAnimation,
              child: Text(
                "Great Job!",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}