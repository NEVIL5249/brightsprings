import 'package:flutter/material.dart';
import 'dart:developer'; // For debug logging

// Corrected imports for files in the same directory
import 'alphabet_tap_game.dart';
import 'alphabet_match_game.dart';
import 'alphabet_tracing_game.dart';

// Ensure your actual game files are present:
// modules/child/games/alphabet_tap_game.dart
// modules/child/games/alphabet_match_game.dart
// modules/child/games/alphabet_tracing_game.dart

class GamesHomeScreen extends StatefulWidget {
  @override
  _GamesHomeScreenState createState() => _GamesHomeScreenState();
}

class _GamesHomeScreenState extends State<GamesHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // Since you don't need shared preferences, these are not used
  // and have been removed.
  // int _totalGamesPlayed = 0;
  // int _totalCorrectMatches = 0;
  // int _totalAttempts = 0;
  // double _overallAccuracy = 0.0;
  // int _maxStreak = 0;

  // Define consistent keys for SharedPreferences (not used if no shared_preferences)
  // static const String _kTotalGamesPlayed = 'totalGamesPlayed';
  // static const String _kTotalCorrectMatches = 'totalCorrectMatches';
  // static const String _kTotalAttempts = 'totalAttempts';
  // static const String _kMaxStreak = 'maxStreak';

  final List<GameTileData> _tiles = [
    GameTileData(
      icon: Icons.touch_app_rounded,
      title: "Tap the Alphabet",
      description: "Touch and learn letters!",
      color: const Color(0xFF00B894),
      lightColor: const Color(0xFF00CEC9),
      emoji: "👆",
    ),
    GameTileData(
      icon: Icons.compare_arrows_rounded,
      title: "Match Alphabets",
      description: "Find the matching pairs!",
      color: const Color(0xFFE17055),
      lightColor: const Color(0xFFFD79A8),
      emoji: "🔤",
    ),
    GameTileData(
      icon: Icons.brush_rounded,
      title: "Trace Letters",
      description: "Draw letters with your finger!",
      color: const Color(0xFFFDCB6E),
      lightColor: const Color(0xFFE84393),
      emoji: "✏️",
    ),
    GameTileData(
      icon: Icons.star_rounded, // Using a generic star icon for coming soon
      title: "Coming Soon",
      description: "More games on the way!",
      color: const Color(0xFFA29BFE), // A soft purple for coming soon
      lightColor: const Color(0xFF6C5CE7),
      isComingSoon: true,
      emoji: "🚀",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo,
    );

    _controller.forward();

    // No need to load progress data if shared_preferences is not used.
    // _loadProgressData();
  }

  // If you don't need shared preferences, this method is no longer needed.
  // Future<void> _loadProgressData() async {
  //   log('Attempting to load progress data...');
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _totalGamesPlayed = prefs.getInt(_kTotalGamesPlayed) ?? 0;
  //     _totalCorrectMatches = prefs.getInt(_kTotalCorrectMatches) ?? 0;
  //     _totalAttempts = prefs.getInt(_kTotalAttempts) ?? 0;
  //     _maxStreak = prefs.getInt(_kMaxStreak) ?? 0;
  //
  //     if (_totalAttempts > 0) {
  //       _overallAccuracy = (_totalCorrectMatches / _totalAttempts) * 100;
  //     } else {
  //       _overallAccuracy = 0.0;
  //     }
  //     log(
  //         'Loaded: Games: $_totalGamesPlayed, Correct: $_totalCorrectMatches, Attempts: $_totalAttempts, Accuracy: $_overallAccuracy%');
  //   });
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1421), // Consistent dark background
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            // Changed to SingleChildScrollView to handle overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModernHeader(),
                const SizedBox(height: 20), // Spacing between header and banner
                _buildWelcomeBanner(),
                const SizedBox(height: 30),
                _buildGamesGrid(),
                const SizedBox(height: 30),
                // Removed _buildProgressSection() since progress data is not being used
                // _buildProgressSection(),
                const SizedBox(height: 20), // Padding at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  Icons.games_rounded, // Relevant icon for games
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
                      "Fun Learning Games 🎮",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Start your learning adventure!",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.notifications_none_rounded, // Kept for consistency
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24), // Consistent margins
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
          const Text(
            "🌟 Let's Learn Together! 🌟",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700, // Consistent font weight
              color: Colors.white,
              letterSpacing: -0.5, // Consistent letter spacing
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Choose a game to start your learning adventure!",
            style: TextStyle(
              fontSize: 14, // Consistent font size
              color: Colors.white.withOpacity(0.7), // Consistent color opacity
              fontWeight: FontWeight.w500, // Consistent font weight
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGamesGrid() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9, // Consistent aspect ratio
        ),
        itemCount: _tiles.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double delay = index * 0.1;
              double animationValue = Curves.easeOutExpo.transform(
                ((_controller.value - delay).clamp(0.0, 1.0) / (1.0 - delay))
                    .clamp(0.0, 1.0),
              );

              return Transform.translate(
                offset: Offset(0, 50 * (1 - animationValue)),
                child: Opacity(
                  opacity: animationValue,
                  child: GameTile(
                    data: _tiles[index],
                    onTap: () => _handleTileTap(index),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Removed _buildProgressSection() since you don't need shared preferences
  // Widget _buildProgressSection() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 24),
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white.withOpacity(0.05),
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(
  //         color: Colors.white.withOpacity(0.1),
  //         width: 1,
  //       ),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(Icons.bar_chart_rounded,
  //                 color: const Color(0xFFFDCB6E),
  //                 size: 24),
  //             const SizedBox(width: 8),
  //             const Text(
  //               "Your Learning Journey",
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.w700,
  //                 color: Colors.white,
  //                 letterSpacing: -0.5,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 15),
  //         Text(
  //           "Here's how you're doing so far! Keep up the great work!",
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.white.withOpacity(0.7),
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //         const SizedBox(height: 20),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             _buildStatItem(
  //               '$_totalGamesPlayed',
  //               'Games Played',
  //               Icons.games_rounded,
  //               const Color(0xFF00B894),
  //             ),
  //             _buildStatItem(
  //               '$_totalCorrectMatches',
  //               'Correct Matches',
  //               Icons.spellcheck_rounded,
  //               const Color(0xFF74B9FF),
  //             ),
  //             _buildStatItem(
  //               '${_overallAccuracy.toStringAsFixed(1)}%',
  //               'Accuracy',
  //               Icons.track_changes_rounded,
  //               const Color(0xFFFDCB6E),
  //             ),
  //             _buildStatItem(
  //               '$_maxStreak',
  //               'Max Streak',
  //               Icons.local_fire_department_rounded,
  //               const Color(0xFFE17055),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 10),
  //       ],
  //     ),
  //   );
  // }

  // Removed _buildStatItem() since _buildProgressSection() is removed
  // Widget _buildStatItem(String value, String label, IconData icon, Color color) {
  //   return Column(
  //     children: [
  //       Icon(icon, color: color, size: 28),
  //       const SizedBox(height: 6),
  //       Text(
  //         value,
  //         style: const TextStyle(
  //           fontSize: 24,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.white,
  //         ),
  //       ),
  //       Text(
  //         label,
  //         style: TextStyle(
  //           fontSize: 14,
  //           color: Colors.white.withOpacity(0.7),
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  void _handleTileTap(int index) {
    if (_tiles[index].isComingSoon) {
      _showComingSoonDialog(context);
    } else {
      switch (index) {
        case 0:
          _navigateWithAnimation(context, AlphabetTapGame());
          break;
        case 1:
          _navigateWithAnimation(context, AlphabetMatchGame());
          break;
        case 2:
          _navigateWithAnimation(context, AlphabetTracingGame());
          break;
      }
    }
  }

  // Modified to await the push (no need to reload data if shared_preferences not used)
  void _navigateWithAnimation(BuildContext context, Widget destination) async {
    log('Navigating to game.');
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeOutExpo; // Changed to easeOutExpo for consistency

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration:
        const Duration(milliseconds: 400), // Adjusted duration for smooth effect
      ),
    );
    // No need to reload progress data if shared_preferences is not used.
    // log('Returned from game. Reloading progress data...');
    // _loadProgressData();
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2332), // Consistent dialog background
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA29BFE)
                        .withOpacity(0.2), // Light purple for coming soon
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.rocket_launch_rounded, // Rocket icon for coming soon
                    color: Color(0xFFA29BFE),
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "🚀 Coming Soon!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "We're working on more exciting games for you! Stay tuned! 🌟",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF667EEA), // Consistent button color
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Got it! 👍",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GameTileData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color lightColor;
  final bool isComingSoon;
  final String emoji; // Kept for potential use, though primary is IconData

  GameTileData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.lightColor,
    this.isComingSoon = false,
    this.emoji = "",
  });
}

class GameTile extends StatefulWidget {
  final GameTileData data;
  final VoidCallback onTap;

  const GameTile({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  @override
  _GameTileState createState() => _GameTileState();
}

class _GameTileState extends State<GameTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _hoverController.forward(),
            onTapUp: (_) {
              _hoverController.reverse();
              Future.delayed(const Duration(milliseconds: 100), widget.onTap);
            },
            onTapCancel: () => _hoverController.reverse(),
            child: Container(
              decoration: BoxDecoration(
                gradient: widget.data.isComingSoon
                    ? LinearGradient(
                  colors: [
                    Colors.grey.shade700,
                    Colors.grey.shade800
                  ], // Darker grey for dark theme
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.data.color,
                    widget.data.lightColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(24), // Consistent border radius
                boxShadow: [
                  BoxShadow(
                    color: widget.data.isComingSoon
                        ? Colors.black.withOpacity(0.3 + (_glowAnimation.value * 0.1))
                        : widget.data.color
                        .withOpacity(0.3 + (_glowAnimation.value * 0.2)),
                    blurRadius: 20 + (_glowAnimation.value * 10),
                    offset: Offset(0, 8 + (_glowAnimation.value * 4)),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2), // Consistent inner border
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
                  children: [
                    Container(
                      width: 50, // Consistent size
                      height: 50, // Consistent size
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.2), // Consistent background
                        borderRadius:
                        BorderRadius.circular(16), // Consistent border radius
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3), // Consistent border
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        widget.data.icon,
                        color: Colors.white,
                        size: 24, // Consistent icon size
                      ),
                    ),
                    const Spacer(), // Pushes content to the bottom
                    Text(
                      widget.data.title,
                      style: const TextStyle(
                        fontSize: 16, // Consistent font size
                        fontWeight: FontWeight.w700, // Consistent font weight
                        color: Colors.white,
                        letterSpacing: -0.5, // Consistent letter spacing
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.data.description,
                      style: TextStyle(
                        fontSize: 12, // Consistent font size
                        color: Colors.white.withOpacity(0.8), // Consistent color opacity
                        fontWeight: FontWeight.w500, // Consistent font weight
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.data.isComingSoon) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Soon",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}