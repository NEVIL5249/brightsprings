import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:brightsprings/widgets/celebrations_overlay.dart'; // No longer used

class AlphabetTracingGame extends StatefulWidget {
  @override
  _AlphabetTracingGameState createState() => _AlphabetTracingGameState();
}

class _AlphabetTracingGameState extends State<AlphabetTracingGame>
    with TickerProviderStateMixin {
  final List<String> alphabets =
  List.generate(26, (i) => String.fromCharCode(65 + i));

  late String currentLetter;
  List<Offset?> points = [];
  int score = 0;
  int completedLetters = 0;
  double tracingProgress = 0.0;
  bool isLetterCompleted = false;

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late AnimationController _completionController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _completionAnimation;

  // Tracing quality tracking
  List<double> tracingAccuracy = [];
  double currentAccuracy = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _generateNewLetter();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _completionController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );

    _completionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _completionController, curve: Curves.bounceOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    _completionController.dispose();
    super.dispose();
  }

  void _generateNewLetter() {
    final random = Random();
    setState(() {
      currentLetter = alphabets[random.nextInt(alphabets.length)];
      points.clear();
      tracingProgress = 0.0;
      isLetterCompleted = false;
      tracingAccuracy.clear();
      currentAccuracy = 0.0;
    });
    _progressController.reset();
    _completionController.reset();
  }

  void _checkIfCompleted() {
    final validPoints = points.where((p) => p != null).length;
    final newProgress = (validPoints / 100).clamp(0.0, 1.0);

    setState(() {
      tracingProgress = newProgress;
    });

    _progressController.animateTo(newProgress);

    if (validPoints > 80 && !isLetterCompleted) {
      _completeCurrentLetter();
    }
  }

  void _completeCurrentLetter() {
    setState(() {
      isLetterCompleted = true;
      completedLetters++;
      score += _calculateScore();
    });

    HapticFeedback.heavyImpact();
    // After the completion animation finishes, show the dialog
    _completionController.forward().whenComplete(() {
      _showCompletionDialog();
    });
  }

  int _calculateScore() {
    // Base score of 50, bonus for accuracy and speed
    int baseScore = 50;
    int accuracyBonus = (currentAccuracy * 30).round();
    int speedBonus = tracingProgress > 0.9 ? 20 : 10;
    return baseScore + accuracyBonus + speedBonus;
  }

  void _updateTracingAccuracy(Offset point) {
    // Simple accuracy calculation based on distance from center
    // In a real implementation, you'd compare against the actual letter path
    final center = const Offset(200, 200); // Approximate center
    final distance = (point - center).distance;
    final accuracy = (1.0 - (distance / 200)).clamp(0.0, 1.0);

    tracingAccuracy.add(accuracy);
    if (tracingAccuracy.length > 10) {
      tracingAccuracy.removeAt(0);
    }

    currentAccuracy = tracingAccuracy.isEmpty
        ? 0.0
        : tracingAccuracy.reduce((a, b) => a + b) / tracingAccuracy.length;
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap continue
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Make the background transparent
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2D3436), Color(0xFF1B262C)], // Dark gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                const Text(
                  "Great Job!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00B894), // Green for success
                    shadows: [
                      Shadow(
                        blurRadius: 8.0,
                        color: Color(0xFF00B894),
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Completed Letter
                Text(
                  currentLetter,
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat', // A modern font, if available
                    shadows: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Score & Accuracy
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_rounded, color: Colors.yellowAccent.withOpacity(0.9), size: 24),
                    const SizedBox(width: 8),
                    Text(
                      '$score points',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline_rounded, color: const Color(0xFF00CEC9).withOpacity(0.9), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Accuracy: ${(currentAccuracy * 100).round()}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Continue Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss dialog
                    _generateNewLetter(); // Generate next letter
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7), // Theme accent color
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    elevation: 8,
                    shadowColor: const Color(0xFF6C5CE7).withOpacity(0.4),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1421), // Consistent dark background
      body: SafeArea(
        child: Column(
          children: [
            _buildModernHeader(),
            const SizedBox(height: 20),
            _buildTracingStats(),
            Expanded(child: _buildTracingArea()),
            _buildControlButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.brush_rounded, // Relevant icon for tracing
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Letter Tracing ✏️",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Practice writing your alphabets!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Score/Letters traced display
          Container(
            width: 80, // Adjusted width for consistent sizing
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$completedLetters',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Letters',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 80, // Adjusted width for consistent sizing
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Points',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTracingStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05), // Consistent with quick stats
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "🎯 Trace this letter: ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF74B9FF), Color(0xFF0984E3)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  currentLetter,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tracing Progress",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    "${(tracingProgress * 100).round()}%",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Changed to white for consistency
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Container(
                    width: double.infinity,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1), // Consistent background
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _progressAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00B894), Color(0xFF00CEC9)],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          if (currentAccuracy > 0) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.tablet, color: const Color(0xFFFDCB6E).withOpacity(0.8), size: 16), // Adjusted color for dark theme
                const SizedBox(width: 4),
                Text(
                  "Accuracy: ${(currentAccuracy * 100).round()}%",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.7), // Adjusted color for dark theme
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTracingArea() {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05), // Consistent with tile backgrounds
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: isLetterCompleted ? 1.0 : _pulseAnimation.value,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      if (!isLetterCompleted) {
                        RenderBox box = context.findRenderObject() as RenderBox;
                        final localPosition = box.globalToLocal(details.globalPosition);
                        setState(() => points.add(localPosition));
                        _updateTracingAccuracy(localPosition);
                        _checkIfCompleted();
                      }
                    },
                    onPanEnd: (_) {
                      if (!isLetterCompleted) {
                        points.add(null);
                      }
                    },
                    child: CustomPaint(
                      painter: EnhancedGhostLetterPainter(
                        letter: currentLetter,
                        points: points,
                        isCompleted: isLetterCompleted,
                        progress: tracingProgress,
                      ),
                      size: Size.infinite,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24), // Adjust padding
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => setState(() {
                points.clear();
                tracingProgress = 0.0;
                tracingAccuracy.clear();
                currentAccuracy = 0.0;
                _progressController.reset();
              }),
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: const Text(
                "Clear",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600, // Consistent font weight
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE17055), // Theme color
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Consistent border radius
                ),
                padding: const EdgeInsets.symmetric(vertical: 16), // Consistent padding
                elevation: 0, // Consistent elevation
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // Ensure dialog is not showing before generating next letter
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
                _generateNewLetter();
              },
              icon: const Icon(Icons.skip_next_rounded, color: Colors.white),
              label: const Text(
                "Next Letter",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600, // Consistent font weight
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B894), // Theme color
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Consistent border radius
                ),
                padding: const EdgeInsets.symmetric(vertical: 16), // Consistent padding
                elevation: 0, // Consistent elevation
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EnhancedGhostLetterPainter extends CustomPainter {
  final String letter;
  final List<Offset?> points;
  final bool isCompleted;
  final double progress;

  EnhancedGhostLetterPainter({
    required this.letter,
    required this.points,
    required this.isCompleted,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background pattern
    _drawBackgroundPattern(canvas, size);

    // Draw ghost letter with enhanced styling
    _drawGhostLetter(canvas, size);

    // Draw user's tracing with gradient and effects
    _drawUserTracing(canvas, size);

    // Draw completion effects
    if (isCompleted) {
      _drawCompletionEffects(canvas, size);
    }
  }

  void _drawBackgroundPattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05) // Subtle pattern color
      ..strokeWidth = 1.0;

    // Draw subtle grid pattern
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  void _drawGhostLetter(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          fontSize: size.height * 0.4,
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4.0
            ..color = isCompleted
                ? const Color(0xFF00B894).withOpacity(0.5) // Green when completed
                : Colors.white.withOpacity(0.2), // Soft white outline
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    // Draw filled version first (very faint)
    final filledTextPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          fontSize: size.height * 0.4,
          fontWeight: FontWeight.bold,
          color: isCompleted
              ? const Color(0xFF00B894).withOpacity(0.05) // Faint green fill
              : Colors.white.withOpacity(0.02), // Very faint white fill
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    filledTextPainter.layout();
    filledTextPainter.paint(canvas, offset);

    // Draw outline version
    textPainter.paint(canvas, offset);
  }

  void _drawUserTracing(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = 10.0 // Thicker for better visibility
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final glowPaint = Paint()
      ..strokeWidth = 20.0 // Thicker glow
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5.0); // More blur

    // Colors consistent with the theme
    final List<Color> tracingColors = [const Color(0xFF74B9FF), const Color(0xFF0984E3)];

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        final double segmentProgress = i / (points.length - 1);
        final Color currentColor = Color.lerp(tracingColors[0], tracingColors[1], segmentProgress)!;

        // Draw glow first
        glowPaint.color = currentColor.withOpacity(0.5);
        canvas.drawLine(points[i]!, points[i + 1]!, glowPaint);

        // Draw solid line
        paint.color = currentColor;
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }

    // Draw sparkle effects along the trace
    _drawSparkleEffects(canvas, size);
  }

  void _drawSparkleEffects(Canvas canvas, Size size) {
    final sparklePoints = points.where((p) => p != null).toList();
    if (sparklePoints.isEmpty) return;

    final paint = Paint()
      ..color = Colors.yellowAccent.withOpacity(0.8) // Brighter yellow
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill; // Fill sparkles

    final random = Random();

    // Draw sparkles at random intervals
    for (int i = 0; i < sparklePoints.length; i += (random.nextInt(10) + 5)) { // More random spacing
      if (i < sparklePoints.length) {
        final point = sparklePoints[i]!;
        _drawSparkle(canvas, point, paint);
      }
    }
  }

  void _drawSparkle(Canvas canvas, Offset center, Paint paint) {
    const sparkleSize = 6.0; // Smaller sparkles
    // Draw a star shape
    Path starPath = Path();
    starPath.moveTo(center.dx, center.dy - sparkleSize);
    starPath.lineTo(center.dx + sparkleSize * 0.3, center.dy - sparkleSize * 0.3);
    starPath.lineTo(center.dx + sparkleSize, center.dy);
    starPath.lineTo(center.dx + sparkleSize * 0.3, center.dy + sparkleSize * 0.3);
    starPath.lineTo(center.dx, center.dy + sparkleSize);
    starPath.lineTo(center.dx - sparkleSize * 0.3, center.dy + sparkleSize * 0.3);
    starPath.lineTo(center.dx - sparkleSize, center.dy);
    starPath.lineTo(center.dx - sparkleSize * 0.3, center.dy - sparkleSize * 0.3);
    starPath.close();
    canvas.drawPath(starPath, paint);
  }

  void _drawCompletionEffects(Canvas canvas, Size size) {
    // Draw completion border
    final borderPaint = Paint()
      ..color = const Color(0xFF00B894)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(10, 10, size.width - 20, size.height - 20),
        const Radius.circular(15),
      ),
      borderPaint,
    );

    // Draw checkmark
    final checkPaint = Paint()
      ..color = const Color(0xFF00B894)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final checkPath = Path();
    checkPath.moveTo(size.width * 0.8, size.height * 0.15);
    checkPath.lineTo(size.width * 0.85, size.height * 0.2);
    checkPath.lineTo(size.width * 0.95, size.height * 0.1);

    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant EnhancedGhostLetterPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.isCompleted != isCompleted ||
        oldDelegate.progress != progress;
  }
}