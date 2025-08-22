import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
// import 'package:brightsprings/widgets/celebrations_overlay.dart'; // No longer used

class AlphabetTapGame extends StatefulWidget {
  @override
  _AlphabetTapGameState createState() => _AlphabetTapGameState();
}

class _AlphabetTapGameState extends State<AlphabetTapGame>
    with TickerProviderStateMixin {
  final List<String> alphabets =
  List.generate(26, (i) => String.fromCharCode(65 + i));

  late String targetAlphabet;
  String feedback = '';
  int score = 0;
  int streak = 0;
  int level = 1;
  bool isAnswered = false;
  String selectedAnswer = '';

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late AnimationController _feedbackController; // Still useful for the dialog's internal animation
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _feedbackAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _generateNewTarget();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shakeAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    _feedbackAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.bounceOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _generateNewTarget() {
    final random = Random();
    setState(() {
      targetAlphabet = alphabets[random.nextInt(alphabets.length)];
      feedback = '';
      isAnswered = false;
      selectedAnswer = '';
    });
    _feedbackController.reset();
  }

  void _checkAnswer(String selected) {
    if (isAnswered) return;

    HapticFeedback.mediumImpact();

    setState(() {
      isAnswered = true;
      selectedAnswer = selected;
    });

    if (selected == targetAlphabet) {
      feedback = _getCorrectFeedback();
      score += (10 * level);
      streak++;

      if (streak % 5 == 0) {
        level++;
      }
      _feedbackController.forward().whenComplete(() {
        _showFeedbackDialog(true);
      });
    } else {
      feedback = _getIncorrectFeedback();
      streak = 0;
      _shakeController.forward().whenComplete(() {
        _shakeController.reset();
        _feedbackController.forward().whenComplete(() {
          _showFeedbackDialog(false);
        });
      });
    }
  }

  String _getCorrectFeedback() {
    final messages = [
      '🌟 Amazing!',
      '🎉 Great job!',
      '✨ Excellent!',
      '🏆 Perfect!',
      '👏 Well done!',
      '🎯 Fantastic!',
    ];
    return messages[Random().nextInt(messages.length)];
  }

  String _getIncorrectFeedback() {
    final messages = [
      '💪 Try again!',
      '🤔 Almost there!',
      '🌈 Keep going!',
      '⭐ You can do it!',
      '🎈 One more try!',
    ];
    return messages[Random().nextInt(messages.length)];
  }

  List<String> _generateOptions() {
    final random = Random();
    Set<String> options = {targetAlphabet};

    Map<String, List<String>> similarLetters = {
      'B': ['D', 'P', 'R'],
      'D': ['B', 'O', 'P'],
      'P': ['B', 'D', 'R'],
      'M': ['N', 'W'],
      'N': ['M', 'H'],
      'C': ['G', 'O'],
      'G': ['C', 'O'],
      'I': ['L', 'T'],
      'L': ['I'],
      'V': ['U'],
      'U': ['V'],
      'Q': ['O'],
    };

    if (level >= 2 && similarLetters.containsKey(targetAlphabet)) {
      for (String similar in similarLetters[targetAlphabet]!) {
        if (options.length < 4) options.add(similar);
      }
    }

    while (options.length < 4) {
      String newLetter = alphabets[random.nextInt(alphabets.length)];
      if (!options.contains(newLetter)) {
        options.add(newLetter);
      }
    }

    return options.toList()..shuffle();
  }

  void _showFeedbackDialog(bool isCorrect) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap continue
      builder: (BuildContext context) {
        return _FeedbackDialog(
          isCorrect: isCorrect,
          targetAlphabet: targetAlphabet,
          feedback: feedback,
          score: score,
          streak: streak,
          onContinue: () {
            Navigator.of(context).pop(); // Dismiss dialog
            _generateNewTarget(); // Generate next target
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = _generateOptions();

    return Scaffold(
      backgroundColor: const Color(0xFF0D1421), // Consistent dark background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildModernHeader(),
              const SizedBox(height: 30),

              // Progress indicator
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('Score', score.toString(), Icons.star_rounded, const Color(0xFFFDCB6E)),
                    _buildStatCard('Streak', streak.toString(), Icons.local_fire_department_rounded, const Color(0xFFE17055)),
                    _buildStatCard('Level', level.toString(), Icons.trending_up_rounded, const Color(0xFF00B894)),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Instruction
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF74B9FF), Color(0xFF0984E3)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0984E3).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Text(
                  "🎯 Find and tap this letter:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Target letter with animation
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shakeAnimation.value, 0),
                        child: Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE17055), Color(0xFFFD79A8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(70),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE17055).withOpacity(0.5),
                                  blurRadius: 25,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                              border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                            ),
                            child: Center(
                              child: Text(
                                targetAlphabet,
                                style: TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.4),
                                      offset: const Offset(3, 3),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 50),

              // Options grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.0,
                children: options.map((letter) {
                  bool isCorrect = letter == targetAlphabet && isAnswered;
                  bool isSelected = letter == selectedAnswer;
                  bool isWrong = isSelected && letter != targetAlphabet && isAnswered;

                  return _buildOptionTile(letter, isCorrect, isWrong, isSelected);
                }).toList(),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 55,
            height: 55,
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
              Icons.gamepad_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Alphabet Tap 🔤",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Match the letter!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile(String letter, bool isCorrect, bool isWrong, bool isSelected) {
    List<Color> gradientColors;
    Color borderColor = Colors.transparent;
    double borderWidth = 0;
    double elevation = 8;

    if (isCorrect) {
      gradientColors = const [Color(0xFF00B894), Color(0xFF00CEC9)];
      borderColor = Colors.white;
      borderWidth = 3;
      elevation = 15;
    } else if (isWrong) {
      gradientColors = const [Color(0xFFE17055), Color(0xFFFD79A8)];
      borderColor = Colors.white;
      borderWidth = 3;
      elevation = 15;
    } else {
      gradientColors = const [Color(0xFFA29BFE), Color(0xFF6C5CE7)];
      if (isSelected) {
        borderColor = Colors.white.withOpacity(0.5);
        borderWidth = 2;
      }
    }

    return GestureDetector(
      onTap: isAnswered ? null : () => _checkAnswer(letter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.4),
              blurRadius: elevation,
              offset: Offset(0, elevation / 1.5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              letter,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.4),
                    offset: const Offset(3, 3),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
            if (isCorrect) ...[
              const SizedBox(height: 10),
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 30),
            ] else if (isWrong) ...[
              const SizedBox(height: 10),
              const Icon(Icons.close_rounded, color: Colors.white, size: 30),
            ],
          ],
        ),
      ),
    );
  }
}

// New StatefulWidget for the animated feedback dialog
class _FeedbackDialog extends StatefulWidget {
  final bool isCorrect;
  final String targetAlphabet;
  final String feedback;
  final int score;
  final int streak;
  final VoidCallback onContinue;

  const _FeedbackDialog({
    Key? key,
    required this.isCorrect,
    required this.targetAlphabet,
    required this.feedback,
    required this.score,
    required this.streak,
    required this.onContinue,
  }) : super(key: key);

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<_FeedbackDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Pop duration
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack, // A nice "pop" curve
    );
    _animationController.forward(); // Start the animation when the dialog appears
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition( // This creates the 'pop' effect
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent, // Transparent background for the dialog itself
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            // Consistent dark gradient for the dialog background
            gradient: const LinearGradient(
              colors: [Color(0xFF2D3436), Color(0xFF1B262C)],
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
              // Title: Correct! / Oops!
              Text(
                widget.isCorrect ? "Correct!" : "Oops!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  // Color changes based on correctness
                  color: widget.isCorrect ? const Color(0xFF00B894) : const Color(0xFFE17055),
                  shadows: const [
                    Shadow(
                      blurRadius: 8.0,
                      color: Colors.black38, // Consistent shadow for text
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // The target letter
              Text(
                widget.targetAlphabet,
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Montserrat', // If you have this font imported, it will apply
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
              // Feedback message (e.g., "🌟 Amazing!" or "💪 Try again!")
              Text(
                widget.feedback,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 15),
              // Current Score and Streak for context
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_rounded, color: Colors.yellowAccent.withOpacity(0.9), size: 20),
                  const SizedBox(width: 5),
                  Text(
                    '${widget.score} pts',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Icon(Icons.local_fire_department_rounded, color: const Color(0xFFE17055).withOpacity(0.9), size: 20),
                  const SizedBox(width: 5),
                  Text(
                    '${widget.streak} streak',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Continue Button
              ElevatedButton(
                onPressed: widget.onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7), // Theme accent color for button
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
      ),
    );
  }
}