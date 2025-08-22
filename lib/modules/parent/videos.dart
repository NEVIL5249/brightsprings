import 'package:flutter/material.dart';

// --- NEW: TrainingVideoData for specific video information ---
class TrainingVideoData {
  final String title;
  final String duration;
  final String description; // Added for more detail if needed
  final IconData icon;
  final Color primaryColor;
  final Color accentColor;
  final bool isComingSoon;

  TrainingVideoData({
    required this.title,
    required this.duration,
    this.description = '', // Default empty description
    required this.icon,
    required this.primaryColor,
    required this.accentColor,
    this.isComingSoon = false,
  });
}

class TrainingVideosScreen extends StatefulWidget {
  @override
  _TrainingVideosScreenState createState() => _TrainingVideosScreenState();
}

class _TrainingVideosScreenState extends State<TrainingVideosScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<TrainingVideoData> _trainingVideos = [
    TrainingVideoData(
      title: 'Understanding Emotions',
      duration: '5:30',
      description: 'Learn to identify and manage emotions.',
      icon: Icons.psychology_rounded,
      primaryColor: const Color(0xFF6C5CE7), // Purple
      accentColor: const Color(0xFFA29BFE),
    ),
    TrainingVideoData(
      title: 'Improving Communication',
      duration: '7:20',
      description: 'Tips for effective parent-child communication.',
      icon: Icons.chat_bubble_rounded,
      primaryColor: const Color(0xFF00B894), // Green
      accentColor: const Color(0xFF55EFC4),
    ),
    TrainingVideoData(
      title: 'Routine Building Tips',
      duration: '4:10',
      description: 'Strategies for creating healthy daily routines.',
      icon: Icons.watch_later_rounded,
      primaryColor: const Color(0xFFE17055), // Orange
      accentColor: const Color(0xFFFAB1A0),
    ),
    TrainingVideoData(
      title: 'Positive Reinforcement',
      duration: '6:00',
      description: 'Techniques to encourage positive behavior.',
      icon: Icons.star_rate_rounded,
      primaryColor: const Color(0xFFFDCB6E), // Yellow
      accentColor: const Color(0xFFFFE66D),
    ),
    TrainingVideoData(
      title: 'Stress Management',
      duration: '8:45',
      description: 'Parenting tips for managing stress and anxiety.',
      icon: Icons.spa_rounded,
      primaryColor: const Color(0xFF1ABC9C), // Teal
      accentColor: const Color(0xFF48C9B0),
    ),
    TrainingVideoData(
      title: 'New Videos Coming',
      duration: 'N/A',
      description: 'More expert-led training videos on the way!',
      icon: Icons.upcoming_rounded,
      primaryColor: Colors.grey.shade700,
      accentColor: Colors.grey.shade500,
      isComingSoon: true,
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
  }

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
          child: Column(
            children: [
              _buildModernHeader(),
              Expanded(child: _buildTrainingVideoList()),
              _buildBottomBar(),
            ],
          ),
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
                colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)], // Purple for training videos
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C5CE7).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon( // This can be const
              Icons.ondemand_video_rounded, // Icon specific to training videos
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text( // This can be const
                  "Parent Training Videos 📺", // Updated header text
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text( // Cannot be const due to dynamic opacity
                  "Expert advice for your parenting journey", // Updated sub-text
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
            child: Icon( // Cannot be const due to dynamic opacity
              Icons.search_rounded, // Example: search icon
              color: Colors.white.withOpacity(0.8),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingVideoList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: ListView.builder(
        itemCount: _trainingVideos.length,
        itemBuilder: (context, index) {
          final video = _trainingVideos[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double delay = index * 0.08;
                double animationValue = Curves.easeOutExpo.transform(
                  ((_controller.value - delay).clamp(0.0, 1.0) / (1.0 - delay))
                      .clamp(0.0, 1.0),
                );

                return Transform.translate(
                  offset: Offset(0, 30 * (1 - animationValue)),
                  child: Opacity(
                    opacity: animationValue,
                    child: TrainingVideoCard(
                      video: video,
                      onTap: () => _handleVideoTap(context, video),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBottomBarItem(Icons.home_rounded, "Home", false),
          _buildBottomBarItem(Icons.arrow_back_rounded, "Back", true,
              onTap: () => Navigator.pop(context)),
          _buildBottomBarItem(Icons.category_rounded, "Categories", false,
              onTap: () => _showComingSoonDialog(context, "Categories")),
          _buildBottomBarItem(Icons.bookmark_rounded, "Watchlist", false,
              onTap: () => _showComingSoonDialog(context, "Watchlist")),
        ],
      ),
    );
  }

  Widget _buildBottomBarItem(IconData icon, String label, bool isActive,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon( // Cannot be const due to dynamic `icon` and `isActive`
              icon,
              color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text( // Cannot be const due to dynamic `isActive`
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _handleVideoTap(BuildContext context, TrainingVideoData video) {
    if (video.isComingSoon) {
      _showComingSoonDialog(context, "Video");
    } else {
      _showTrainingVideoPlayerDialog(context, video);
    }
  }

  // Simulated Training Video Player Dialog
  void _showTrainingVideoPlayerDialog(BuildContext context, TrainingVideoData video) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2332), // Dashboard dialog color
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Placeholder for video thumbnail/player
                      Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey.shade800,
                        child: Icon(Icons.play_circle_filled_rounded, color: Colors.white.withOpacity(0.5), size: 50),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: video.primaryColor.withOpacity(0.8),
                          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  video.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Duration: ${video.duration}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                if (video.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    video.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Simulate stopping/pausing the video
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.stop_rounded, size: 20),
                            SizedBox(width: 8),
                            Text("Stop"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Simulate "playing done" or just dismiss
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: video.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done_rounded, size: 20),
                            SizedBox(width: 8),
                            Text("Done"),
                          ],
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

  void _showComingSoonDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2332), // Dashboard dialog color
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
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon( // This can be const
                    Icons.access_time_rounded,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                Text( // Cannot be const due to dynamic type string
                  "🚀 $type Coming Soon!",
                  textAlign: TextAlign.center,
                  style: const TextStyle( // TextStyle itself can be const
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text( // Cannot be const due to dynamic opacity and type string
                  "We're working on more exciting $type for you! Stay tuned! 🌟",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7), // Consistent button color
                    foregroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text( // This can be const
                    "Got it! 👍",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- NEW: TrainingVideoCard Widget for individual video list items ---
class TrainingVideoCard extends StatefulWidget {
  final TrainingVideoData video;
  final VoidCallback onTap;

  const TrainingVideoCard({
    Key? key,
    required this.video,
    required this.onTap,
  }) : super(key: key);

  @override
  _TrainingVideoCardState createState() => _TrainingVideoCardState();
}

class _TrainingVideoCardState extends State<TrainingVideoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98, // Subtle scale effect
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
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _hoverController.forward(),
            onTapUp: (_) {
              _hoverController.reverse();
              widget.onTap(); // Execute the tap action
            },
            onTapCancel: () => _hoverController.reverse(),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05), // Dark transparent background
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Video Icon/Thumbnail Placeholder
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [widget.video.primaryColor, widget.video.accentColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.video.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon( // Cannot be const due to dynamic `widget.video.icon`
                      widget.video.icon,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Video Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text( // Cannot be const due to dynamic `widget.video.title`
                          widget.video.title,
                          style: const TextStyle( // TextStyle itself can be const
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text( // Cannot be const due to dynamic `widget.video.isComingSoon` and `widget.video.duration`
                          widget.video.isComingSoon
                              ? "Coming Soon"
                              : "Duration: ${widget.video.duration}",
                          style: TextStyle( // TextStyle itself can be const
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (widget.video.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text( // Cannot be const due to dynamic `widget.video.description`
                            widget.video.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.6),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (widget.video.isComingSoon) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text( // This can be const
                              "New Content",
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
                  const SizedBox(width: 16),
                  Icon( // Cannot be const due to dynamic opacity
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white.withOpacity(0.6),
                    size: 18,
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