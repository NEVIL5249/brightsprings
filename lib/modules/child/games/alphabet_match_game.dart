import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'dart:math' as math; // For math.max
import 'dart:async'; // For Timer
import 'dart:developer'; // For debug logging: log()

// Models
class GameSession {
  final String id;
  final DateTime startTime;
  final int totalAttempts;
  final int correctMatches;
  final Duration timeSpent;
  final List<MatchAttempt> attempts;

  GameSession({
    required this.id,
    required this.startTime,
    required this.totalAttempts,
    required this.correctMatches,
    required this.timeSpent,
    required this.attempts,
  });

  double get accuracy => totalAttempts > 0 ? (correctMatches / totalAttempts) : 0.0;
}

class MatchAttempt {
  final String letter;
  final bool isCorrect;
  final DateTime timestamp;
  final Duration responseTime;

  MatchAttempt({
    required this.letter,
    required this.isCorrect,
    required this.timestamp,
    required this.responseTime,
  });
}

class DifficultyLevel {
  final String name;
  final List<String> letters;
  final int timeLimit;
  final Color color; // This color will be used for UI elements related to this difficulty

  const DifficultyLevel({
    required this.name,
    required this.letters,
    required this.timeLimit,
    required this.color,
  });
}

// Constants
class GameConstants {
  // Using the consistent dark theme colors
  static const Color backgroundColor = Color(0xFF0D1421);
  static const Color surfaceColor = Color(0xFF1A2332);
  static const Color primaryColor = Color(0xFF667EEA); // Purple gradient start
  static const Color primaryLightColor = Color(0xFF764BA2); // Purple gradient end
  static const Color successColor = Color(0xFF00B894); // Green gradient start
  static const Color successLightColor = Color(0xFF00CEC9); // Green gradient end
  static const Color errorColor = Color(0xFFE17055); // Red gradient start
  static const Color errorLightColor = Color(0xFFFD79A8); // Red gradient end
  static const Color infoColor = Color(0xFF74B9FF); // Blue gradient start
  static const Color infoLightColor = Color(0xFF0984E3); // Blue gradient end
  static const Color textColor = Colors.white;
  static const Color textFadedColor = Colors.white70;

  static const List<DifficultyLevel> difficulties = [
    DifficultyLevel(
      name: 'Beginner',
      letters: ['A', 'B', 'C'],
      timeLimit: 180,
      color: successColor, // Using success color for Beginner
    ),
    DifficultyLevel(
      name: 'Intermediate',
      letters: ['A', 'B', 'C', 'D', 'E', 'F'],
      timeLimit: 120,
      color: primaryColor, // Using primary color for Intermediate
    ),
    DifficultyLevel(
      name: 'Advanced',
      letters: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'],
      timeLimit: 90,
      color: errorColor, // Using error color for Advanced
    ),
  ];

// Removed SharedPreferences keys as they are no longer used here.
// static const String kTotalGamesPlayed = 'totalGamesPlayed';
// static const String kTotalCorrectMatches = 'totalCorrectMatches';
// static const String kTotalAttempts = 'totalAttempts';
// static const String kMaxGlobalStreak = 'maxGlobalStreak';
}

// Game State Management
enum GameState { setup, playing, paused, completed }

class GameStats {
  int totalAttempts = 0;
  int correctMatches = 0;
  int streak = 0; // Current game streak
  int maxStreak = 0; // Max streak achieved in this game session
  Duration totalTime = Duration.zero;
  List<MatchAttempt> attempts = [];

  void recordAttempt(String letter, bool isCorrect, Duration responseTime) {
    totalAttempts++;
    if (isCorrect) {
      correctMatches++;
      streak++;
      maxStreak = math.max(maxStreak, streak); // Update max streak for THIS game
    } else {
      streak = 0; // Reset streak on incorrect
    }

    attempts.add(MatchAttempt(
      letter: letter,
      isCorrect: isCorrect,
      timestamp: DateTime.now(),
      responseTime: responseTime,
    ));
  }

  void reset() {
    totalAttempts = 0;
    correctMatches = 0;
    streak = 0;
    maxStreak = 0;
    totalTime = Duration.zero;
    attempts.clear();
  }

  double get accuracy => totalAttempts > 0 ? (correctMatches / totalAttempts) : 0.0;

  Duration get averageResponseTime {
    if (attempts.isEmpty) return Duration.zero;
    final total = attempts.fold<int>(0, (sum, attempt) => sum + attempt.responseTime.inMilliseconds);
    return Duration(milliseconds: total ~/ attempts.length);
  }
}

class AlphabetMatchGame extends StatefulWidget {
  final String? childId;
  final Function(GameSession)? onGameComplete;

  const AlphabetMatchGame({
    Key? key,
    this.childId,
    this.onGameComplete,
  }) : super(key: key);

  @override
  _AlphabetMatchGameState createState() => _AlphabetMatchGameState();
}

class _AlphabetMatchGameState extends State<AlphabetMatchGame>
    with TickerProviderStateMixin {
  // Game Configuration
  late DifficultyLevel currentDifficulty;
  GameState gameState = GameState.setup;
  GameStats stats = GameStats();

  // Game Data
  Map<String, bool> matched = {};
  String? draggedLetter; // Track the letter being dragged (lowercase, then converted to uppercase for target)
  List<String> _shuffledDraggableLetters = []; // Stores the order of draggable letters
  DateTime? gameStartTime;
  DateTime? lastInteractionTime;
  Timer? gameTimer;
  int remainingTime = 0;

  // Removed SharedPreferences instance
  // late SharedPreferences _prefs;

  // Animation Controllers
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late AnimationController _progressController; // For linear progress bar

  // Animations
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    currentDifficulty = GameConstants.difficulties[0]; // Default to Beginner
    _initializeAnimations();
    // Removed _initSharedPreferences();
    _initializeGame(); // Initialize game data
  }

  // Removed Initialize SharedPreferences method
  // Future<void> _initSharedPreferences() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   log('AlphabetMatchGame: SharedPreferences initialized.');
  // }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shakeAnimation = Tween<double>(begin: -10.0, end: 10.0).animate( // Increased shake intensity
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );
  }

  void _initializeGame() {
    matched.clear();
    for (var letter in currentDifficulty.letters) {
      matched[letter] = false;
    }
    // Shuffle draggable letters once at initialization
    _shuffledDraggableLetters = List.from(currentDifficulty.letters)..shuffle();
    remainingTime = currentDifficulty.timeLimit;
    stats.reset(); // Reset game stats
    gameTimer?.cancel(); // Ensure any existing timer is cancelled
    lastInteractionTime = null; // Reset last interaction time
    log('AlphabetMatchGame: Game initialized for ${currentDifficulty.name}. Letters: ${currentDifficulty.letters.join(', ')}');
  }

  void _startGame() {
    setState(() {
      gameState = GameState.playing;
      gameStartTime = DateTime.now();
      lastInteractionTime = DateTime.now(); // Initialize here for first interaction
    });

    _startTimer();
    _progressController.forward(); // Animate progress bar (if used for game progress)
    log('AlphabetMatchGame: Game started.');
  }

  void _startTimer() {
    gameTimer?.cancel(); // Cancel any existing timer before starting a new one
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          remainingTime--;
          if (remainingTime <= 0) {
            _endGame(true); // Game ended due to time out
          }
        });
      } else {
        timer.cancel(); // Cancel timer if widget is no longer mounted
      }
    });
  }

  void _pauseGame() {
    setState(() {
      gameState = GameState.paused;
    });
    gameTimer?.cancel();
    log('AlphabetMatchGame: Game paused.');
  }

  void _resumeGame() {
    setState(() {
      gameState = GameState.playing;
    });
    _startTimer();
    log('AlphabetMatchGame: Game resumed.');
  }

  // Removed _saveGameStats method entirely.
  // Future<void> _saveGameStats() async {
  //   log('AlphabetMatchGame: --- Attempting to save game stats ---');
  //   log('AlphabetMatchGame: Current in-game stats: Attempts: ${stats.totalAttempts}, Correct: ${stats.correctMatches}, Max Streak: ${stats.maxStreak}');

  //   int currentTotalGamesPlayed = _prefs.getInt(GameConstants.kTotalGamesPlayed) ?? 0;
  //   int currentTotalCorrectMatches = _prefs.getInt(GameConstants.kTotalCorrectMatches) ?? 0;
  //   int currentTotalAttempts = _prefs.getInt(GameConstants.kTotalAttempts) ?? 0;
  //   int currentMaxGlobalStreak = _prefs.getInt(GameConstants.kMaxGlobalStreak) ?? 0;

  //   log('AlphabetMatchGame: Previously saved: Games: $currentTotalGamesPlayed, Correct: $currentTotalCorrectMatches, Attempts: $currentTotalAttempts, Global Max Streak: $currentMaxGlobalStreak');

  //   currentTotalGamesPlayed++;
  //   currentTotalCorrectMatches += stats.correctMatches;
  //   currentTotalAttempts += stats.totalAttempts;
  //   currentMaxGlobalStreak = math.max(currentMaxGlobalStreak, stats.maxStreak);

  //   await _prefs.setInt(GameConstants.kTotalGamesPlayed, currentTotalGamesPlayed);
  //   await _prefs.setInt(GameConstants.kTotalCorrectMatches, currentTotalCorrectMatches);
  //   await _prefs.setInt(GameConstants.kTotalAttempts, currentTotalAttempts);
  //   await _prefs.setInt(GameConstants.kMaxGlobalStreak, currentMaxGlobalStreak);

  //   log('AlphabetMatchGame: Successfully saved! New totals: Games: $currentTotalGamesPlayed, Correct: $currentTotalCorrectMatches, Attempts: $currentTotalAttempts, Global Max Streak: $currentMaxGlobalStreak');
  //   log('AlphabetMatchGame: --- End of save game stats ---');
  // }


  void _endGame(bool timedOut) async { // _endGame is still async but no longer awaits SharedPreferences
    log('AlphabetMatchGame: _endGame called. Timed out: $timedOut');
    gameTimer?.cancel();
    setState(() {
      gameState = GameState.completed;
      stats.totalTime = DateTime.now().difference(gameStartTime!);
    });

    // Removed the call to _saveGameStats()
    // await _saveGameStats();

    // Optionally call onGameComplete callback with session data
    final session = GameSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: gameStartTime!,
      totalAttempts: stats.totalAttempts,
      correctMatches: stats.correctMatches,
      timeSpent: stats.totalTime,
      attempts: stats.attempts,
    );
    widget.onGameComplete?.call(session);

    // Use _showMatchGameFeedbackDialog for consistency
    // It will automatically transition to the completion screen due to gameState change
    _showMatchGameFeedbackDialog(
      isCorrectMatch: true, // This param is ignored for completion state
      feedbackMessage: timedOut ? "Time's Up!" : "Game Completed!",
      isGameComplete: true,
      targetLetter: null, // No specific target letter for game completion
    );
    log('AlphabetMatchGame: Game ended.'); // Removed "and stats saved."
  }

  void _onMatchAttempt(String letter, bool isCorrect) {
    // Ensure lastInteractionTime is not null before using it, especially for the very first interaction
    lastInteractionTime ??= DateTime.now();

    final responseTime = DateTime.now().difference(lastInteractionTime!);
    stats.recordAttempt(letter, isCorrect, responseTime);
    log('AlphabetMatchGame: Attempt for ${letter.toUpperCase()}. Correct: $isCorrect. Stats: Total Attempts: ${stats.totalAttempts}, Correct Matches: ${stats.correctMatches}, Streak: ${stats.streak}');


    // Track the letter dragged for feedback dialog (its uppercase form for consistency)
    draggedLetter = letter.toUpperCase();

    if (isCorrect) {
      setState(() {
        matched[letter.toUpperCase()] = true; // Ensure uppercase for map key
      });
      _showMatchGameFeedbackDialog(
        isCorrectMatch: true,
        feedbackMessage: "Excellent! 🌟",
        targetLetter: letter.toUpperCase(),
      );
    } else {
      _shakeController.forward().then((_) => _shakeController.reset());
      _showMatchGameFeedbackDialog(
        isCorrectMatch: false,
        feedbackMessage: "Try again! 💪",
        targetLetter: letter.toUpperCase(), // Pass the attempted letter for feedback
      );
    }

    HapticFeedback.lightImpact();
    lastInteractionTime = DateTime.now(); // Update last interaction time for next attempt

    // Check for game completion after feedback dialog is handled
    if (matched.values.every((isMatched) => isMatched)) {
      log('AlphabetMatchGame: All letters matched. Ending game.');
      Future.delayed(const Duration(milliseconds: 500), () { // Short delay before showing completion
        _endGame(false); // Game completed by matching all letters
      });
    }
  }

  void _changeDifficulty(DifficultyLevel difficulty) {
    log('AlphabetMatchGame: Changing difficulty to ${difficulty.name}');
    setState(() {
      currentDifficulty = difficulty;
      gameState = GameState.setup;
    });
    _initializeGame(); // Re-initialize game data for new difficulty
  }

  void _resetGame() {
    log('AlphabetMatchGame: Resetting game.');
    gameTimer?.cancel();
    setState(() {
      gameState = GameState.setup;
    });
    _initializeGame();
    _progressController.reset();
  }

  @override
  void dispose() {
    log('AlphabetMatchGame: Disposing controllers and timer.');
    gameTimer?.cancel();
    _pulseController.dispose();
    _shakeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  // --- UI Building Methods ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameConstants.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Game Content based on state
            if (gameState == GameState.setup) _buildSetupScreen(),
            if (gameState == GameState.playing) _buildGameScreen(),
            if (gameState == GameState.paused) _buildPauseScreen(),
            if (gameState == GameState.completed) _buildCompletionScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [GameConstants.primaryColor, GameConstants.primaryLightColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: GameConstants.primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              gameState == GameState.setup ? Icons.settings_rounded : Icons.gamepad_rounded, // Icon changes based on state
              color: GameConstants.textColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: GameConstants.textColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  gameState == GameState.setup
                      ? "Get ready to match!"
                      : "Drag and match the letters!",
                  style: TextStyle(
                    fontSize: 14,
                    color: GameConstants.textFadedColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Options button for settings/pause
          if (gameState == GameState.playing)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: GameConstants.textColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: GameConstants.textColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: Icon(Icons.pause_rounded, color: GameConstants.textColor.withOpacity(0.8), size: 20),
                onPressed: _pauseGame,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          if (gameState == GameState.setup)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: GameConstants.textColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: GameConstants.textColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: Icon(Icons.info_outline_rounded, color: GameConstants.textColor.withOpacity(0.8), size: 20),
                onPressed: () {
                  // Show game info/rules
                  _showInfoDialog();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSetupScreen() {
    return Column(
      children: [
        _buildModernHeader("Alphabet Match 🔤"),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: GameConstants.surfaceColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(color: GameConstants.textColor.withOpacity(0.1), width: 1),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.school_rounded,
                        size: 80,
                        color: GameConstants.primaryColor,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Alphabet Match",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: GameConstants.textColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Drag the lowercase letter to its matching uppercase letter!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: GameConstants.textFadedColor,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildDifficultySelector(),
                      const SizedBox(height: 32),
                      _buildStartButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameScreen() {
    return Column(
      children: [
        _buildModernHeader("Game In Progress"),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildProgressBar(),
                const SizedBox(height: 24),
                _buildUppercaseTargets(),
                const SizedBox(height: 40),
                _buildLowercaseDraggables(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameStatCard(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: GameConstants.textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: GameConstants.textFadedColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    final progress = matched.values.where((m) => m).length / currentDifficulty.letters.length;
    final timeProgress = remainingTime / currentDifficulty.timeLimit;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GameConstants.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: GameConstants.textColor.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Progress",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: GameConstants.textColor,
                ),
              ),
              Text(
                "${matched.values.where((m) => m).length}/${currentDifficulty.letters.length}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: GameConstants.successColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress, // Only show letter matching progress
            backgroundColor: GameConstants.primaryColor.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(GameConstants.successColor),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Time Left",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: GameConstants.textColor,
                ),
              ),
              Text(
                "${remainingTime}s",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: remainingTime <= 10 ? GameConstants.errorColor : GameConstants.infoColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: timeProgress,
            backgroundColor: GameConstants.errorColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
                remainingTime <= 10 ? GameConstants.errorColor : GameConstants.infoColor),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildUppercaseTargets() {
    return Column(
      children: [
        Text(
          "Match Zone",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: GameConstants.textColor,
          ),
        ),
        const SizedBox(height: 16),
        // Applying shake animation to individual children if needed, not the whole Wrap
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: currentDifficulty.letters.map((letter) {
            return _buildDropTarget(letter);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDropTarget(String letter) {
    final isMatched = matched[letter]!;

    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            gradient: isMatched
                ? const LinearGradient(colors: [GameConstants.successColor, GameConstants.successLightColor])
                : isHovering
                ? const LinearGradient(colors: [GameConstants.primaryColor, GameConstants.primaryLightColor])
                : null, // No gradient if not matched and not hovering
            color: isMatched || isHovering ? null : GameConstants.surfaceColor.withOpacity(0.5), // Faded background for targets
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isMatched
                  ? GameConstants.successColor
                  : isHovering
                  ? GameConstants.primaryColor
                  : GameConstants.textColor.withOpacity(0.2), // Subtle border
              width: isHovering ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isMatched
                    ? GameConstants.successColor.withOpacity(0.3)
                    : isHovering
                    ? GameConstants.primaryColor.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
                blurRadius: isMatched || isHovering ? 15 : 8,
                offset: Offset(0, isMatched || isHovering ? 6 : 4),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  letter,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isMatched
                        ? GameConstants.textColor
                        : isHovering
                        ? GameConstants.textColor
                        : GameConstants.textColor.withOpacity(0.8), // Faded text for targets
                  ),
                ),
                if (isMatched)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: GameConstants.textColor,
                    size: 18,
                  ),
              ],
            ),
          ),
        );
      },
      onWillAccept: (data) {
        // Data from Draggable is lowercase, target is uppercase. Compare accordingly.
        return data?.toUpperCase() == letter && !matched[letter]!;
      },
      onAccept: (received) {
        // When dropped, use the lowercase 'received' for _onMatchAttempt
        _onMatchAttempt(received, received.toUpperCase() == letter);
      },
      onLeave: (data) {
        // Reset draggedLetter if it leaves a target without being dropped
        draggedLetter = null;
      },
    );
  }

  // --- Draggable Letter Widget ---
  Widget _buildDraggableLetter(String letter) {
    // If the letter is already matched, it should not be draggable or visible.
    // Ensure `matched` map uses uppercase keys for consistency with target letters.
    if (matched[letter.toUpperCase()] == true) {
      return const SizedBox.shrink(); // Hide the letter if it's already matched
    }

    return Draggable<String>(
      data: letter.toLowerCase(), // The data associated with this draggable (e.g., 'a', 'b')
      feedback: Material( // This is what the user sees while dragging
        color: Colors.transparent, // Important for custom visuals, prevents default gray background
        child: Container(
          height: 70, // Slightly smaller than original for feedback
          width: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: GameConstants.primaryColor.withOpacity(0.7), // Semi-transparent for drag feedback
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [ // Consistent BoxShadow
              BoxShadow(
                color: Colors.black38,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            letter.toLowerCase(),
            style: const TextStyle(
              fontSize: 32, // Smaller font size for feedback
              fontWeight: FontWeight.bold,
              color: GameConstants.textColor,
              decoration: TextDecoration.none, // Ensure no default text decoration
            ),
          ),
        ),
      ),
      childWhenDragging: Container( // What remains in the original spot when dragging
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: GameConstants.surfaceColor.withOpacity(0.3), // Faded placeholder
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: GameConstants.textColor.withOpacity(0.1), width: 1.5),
        ),
        child: Center(
          child: Text(
            letter.toLowerCase(),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: GameConstants.textColor.withOpacity(0.4), // Faded text
            ),
          ),
        ),
      ),
      child: Container( // The original visual of the draggable item
        height: 80,
        width: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [GameConstants.primaryColor, GameConstants.primaryLightColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: GameConstants.primaryColor.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ScaleTransition(
          scale: _pulseAnimation,
          child: Text(
            letter.toLowerCase(), // Display lowercase letter
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: GameConstants.textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLowercaseDraggables() {
    return Column(
      children: [
        Text(
          "Drag these!",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: GameConstants.textColor,
          ),
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _shakeController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value * (_shakeController.status == AnimationStatus.forward ? 1 : -1), 0),
              child: child,
            );
          },
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: _shuffledDraggableLetters.map((letter) {
              // Pass uppercase letter to _buildDraggableLetter to handle matched state
              return _buildDraggableLetter(letter);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return ElevatedButton(
      onPressed: _startGame,
      style: ElevatedButton.styleFrom(
        backgroundColor: GameConstants.primaryColor,
        foregroundColor: GameConstants.textColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: GameConstants.primaryLightColor.withOpacity(0.5), width: 1),
        ),
        elevation: 10,
        shadowColor: GameConstants.primaryColor.withOpacity(0.4),
      ),
      child: const Text(
        "Start Game",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Difficulty:",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: GameConstants.textColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: GameConstants.difficulties.map((level) {
            final isSelected = currentDifficulty.name == level.name;
            return ChoiceChip(
              label: Text(level.name),
              selected: isSelected,
              selectedColor: level.color,
              backgroundColor: GameConstants.surfaceColor,
              labelStyle: TextStyle(
                color: isSelected ? GameConstants.textColor : GameConstants.textFadedColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? level.color : GameConstants.textColor.withOpacity(0.2),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (selected) {
                if (selected) {
                  _changeDifficulty(level);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: GameConstants.surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: GameConstants.textColor.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: GameConstants.infoColor,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  "How to Play",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: GameConstants.textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Drag the lowercase letters from the bottom to their matching uppercase letters at the top. Match all letters before time runs out!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: GameConstants.textFadedColor,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GameConstants.primaryColor,
                    foregroundColor: GameConstants.textColor,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Got it!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPauseScreen() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: GameConstants.surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: GameConstants.textColor.withOpacity(0.1), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pause_circle_filled_rounded, size: 80, color: GameConstants.infoColor),
            const SizedBox(height: 24),
            const Text(
              "Game Paused",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: GameConstants.textColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "You're doing great! Take a short break.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: GameConstants.textFadedColor,
              ),
            ),
            const SizedBox(height: 32),
            _buildPauseButton("Resume Game", Icons.play_arrow_rounded, _resumeGame, GameConstants.successColor),
            const SizedBox(height: 16),
            _buildPauseButton("End Game", Icons.stop_rounded, () => _endGame(false), GameConstants.errorColor),
          ],
        ),
      ),
    );
  }

  Widget _buildPauseButton(String text, IconData icon, VoidCallback onPressed, Color color) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: GameConstants.textColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
      ),
      icon: Icon(icon, size: 24),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCompletionScreen() {
    final accuracy = stats.accuracy * 100;
    final totalTimeFormatted = '${stats.totalTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${stats.totalTime.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: GameConstants.surfaceColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: GameConstants.textColor.withOpacity(0.1), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    stats.correctMatches == currentDifficulty.letters.length ? Icons.celebration_rounded : Icons.emoji_events_rounded,
                    size: 80,
                    color: stats.correctMatches == currentDifficulty.letters.length ? GameConstants.successColor : GameConstants.infoColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    stats.correctMatches == currentDifficulty.letters.length ? "Congratulations!" : "Game Over!",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: GameConstants.textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    stats.correctMatches == currentDifficulty.letters.length
                        ? "You matched all the letters!"
                        : "Better luck next time!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: GameConstants.textFadedColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildGameStatCard("Attempts", stats.totalAttempts.toString(), Icons.touch_app_rounded, GameConstants.primaryColor),
                      _buildGameStatCard("Correct", stats.correctMatches.toString(), Icons.check_circle_rounded, GameConstants.successColor),
                      _buildGameStatCard("Accuracy", '${accuracy.toStringAsFixed(0)}%', Icons.pie_chart_rounded, GameConstants.infoColor),
                      _buildGameStatCard("Time", totalTimeFormatted, Icons.timer_rounded, GameConstants.errorColor),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildCompletionButton("Play Again", Icons.refresh_rounded, _resetGame, GameConstants.primaryColor),
                  const SizedBox(height: 16),
                  _buildCompletionButton("Go to Home", Icons.home_rounded, () => Navigator.of(context).pop(), GameConstants.infoColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionButton(String text, IconData icon, VoidCallback onPressed, Color color) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: GameConstants.textColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
      ),
      icon: Icon(icon, size: 24),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showMatchGameFeedbackDialog({
    required bool isCorrectMatch,
    required String feedbackMessage,
    bool isGameComplete = false,
    String? targetLetter, // The letter that was matched/attempted
  }) {
    // Only show feedback for incorrect attempts or game completion,
    // not for every correct match if it's too frequent.
    // However, if the design calls for it, you can remove this condition.
    if (isCorrectMatch && !isGameComplete) {
      // For correct matches, we might just want haptic feedback and instant update
      // without a full dialog, or a small, non-blocking toast/snackbar.
      // For now, we'll allow it for demonstration, but consider UI/UX.
    }

    if (isGameComplete) {
      // The completion screen will handle this. No need for a separate dialog here.
      return;
    }

    final Color dialogColor = isCorrectMatch ? GameConstants.successColor : GameConstants.errorColor;
    final IconData dialogIcon = isCorrectMatch ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final String emoji = isCorrectMatch ? "🥳" : "🤔";

    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissal by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOutBack)),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: GameConstants.surfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: dialogColor.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: dialogColor.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    dialogIcon,
                    color: dialogColor,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "$feedbackMessage $emoji",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: GameConstants.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (targetLetter != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      isCorrectMatch
                          ? "'${targetLetter}' matched!"
                          : "That was not '${draggedLetter?.toUpperCase()}'", // Display attempted letter
                      style: TextStyle(
                        fontSize: 16,
                        color: GameConstants.textFadedColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dialogColor,
                      foregroundColor: GameConstants.textColor,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}