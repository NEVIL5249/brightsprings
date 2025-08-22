import 'package:flutter/material.dart';

// --- Reusable ModernTileData for consistency, though VideoData is new ---
// You should ideally move ModernTileData (and ModernTile if used elsewhere)
// to a common file like 'lib/widgets/common_models.dart' or 'lib/widgets/modern_widgets.dart'
// to avoid duplication across dashboard.dart, games.dart, and learning_videos.dart.
class ModernTileData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color lightColor;

  ModernTileData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.lightColor,
  });
}

// --- NEW: VideoData for specific video information ---
class VideoData {
  final String title;
  final String duration;
  final String thumbnailUrl; // Placeholder for actual thumbnail URL
  final IconData icon; // Fallback icon if no thumbnail
  final Color primaryColor;
  final Color accentColor;
  final bool isComingSoon;

  VideoData({
    required this.title,
    required this.duration,
    required this.thumbnailUrl,
    required this.icon,
    required this.primaryColor,
    required this.accentColor,
    this.isComingSoon = false,
  });
}

class ChildLearningVideos extends StatefulWidget {
  @override
  _ChildLearningVideosState createState() => _ChildLearningVideosState();
}

class _ChildLearningVideosState extends State<ChildLearningVideos>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<VideoData> _videos = [
    VideoData(
      title: "Happy and Sad",
      duration: "2:30",
      thumbnailUrl: "https://via.placeholder.com/150/FF6347/FFFFFF?text=Happy", // Example thumbnail
      icon: Icons.emoji_emotions_rounded,
      primaryColor: const Color(0xFF00B894),
      accentColor: const Color(0xFF55EFC4),
    ),
    VideoData(
      title: "Colors and Shapes",
      duration: "3:15",
      thumbnailUrl: "https://via.placeholder.com/150/8A2BE2/FFFFFF?text=Colors",
      icon: Icons.color_lens_rounded,
      primaryColor: const Color(0xFFE17055),
      accentColor: const Color(0xFFFAB1A0),
    ),
    VideoData(
      title: "Animal Sounds",
      duration: "4:00",
      thumbnailUrl: "https://via.placeholder.com/150/32CD32/FFFFFF?text=Animals",
      icon: Icons.pets_rounded,
      primaryColor: const Color(0xFFFDCB6E),
      accentColor: const Color(0xFFFFE66D),
    ),
    VideoData(
      title: "Counting Fun",
      duration: "2:50",
      thumbnailUrl: "https://via.placeholder.com/150/4169E1/FFFFFF?text=Counting",
      icon: Icons.format_list_numbered_rounded,
      primaryColor: const Color(0xFF6C5CE7),
      accentColor: const Color(0xFFA29BFE),
    ),
    VideoData(
      title: "My ABCs",
      duration: "3:45",
      thumbnailUrl: "https://via.placeholder.com/150/FF1493/FFFFFF?text=ABCs",
      icon: Icons.abc_rounded,
      primaryColor: const Color(0xFFFD79A8),
      accentColor: const Color(0xFFE84393),
    ),
    VideoData(
      title: "Coming Soon",
      duration: "N/A",
      thumbnailUrl: "https://via.placeholder.com/150/6C5CE7/FFFFFF?text=New!",
      icon: Icons.hourglass_empty_rounded,
      primaryColor: Colors.grey.shade700, // Use a duller color for coming soon
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
      backgroundColor: const Color(0xFF0D1421), // Dashboard background color
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildModernHeader(),
              Expanded(child: _buildVideoList()), // Changed to build the list
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
                colors: [Color(0xFF00B894), Color(0xFF00CEC9)], // Video theme colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00B894).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.play_circle_filled_rounded, // Icon specific to videos
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
                  "Explore & Watch Videos! ", // Updated header text
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Discover amazing learning adventures", // Updated sub-text
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
              Icons.search_rounded, // Example: search videos
              color: Colors.white.withOpacity(0.8),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // --- NEW: Widget to build the list of videos ---
  Widget _buildVideoList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final video = _videos[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double delay = index * 0.08; // Slightly less delay for list items
                double animationValue = Curves.easeOutExpo.transform(
                  ((_controller.value - delay).clamp(0.0, 1.0) / (1.0 - delay))
                      .clamp(0.0, 1.0),
                );

                return Transform.translate(
                  offset: Offset(0, 30 * (1 - animationValue)), // Less vertical offset
                  child: Opacity(
                    opacity: animationValue,
                    child: VideoCard(
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
          _buildBottomBarItem(Icons.arrow_back_rounded, "Back", true, onTap: () => Navigator.pop(context)),
          _buildBottomBarItem(Icons.category_rounded, "Categories", false, onTap: () => _showComingSoonDialog(context, "Categories")),
          _buildBottomBarItem(Icons.favorite_rounded, "Favorites", false, onTap: () => _showComingSoonDialog(context, "Favorites")),
        ],
      ),
    );
  }

  Widget _buildBottomBarItem(IconData icon, String label, bool isActive, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
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

  void _handleVideoTap(BuildContext context, VideoData video) {
    if (video.isComingSoon) {
      _showComingSoonDialog(context, "Video");
    } else {
      _showVideoPlayerDialog(context, video);
    }
  }

  // --- IMPROVED: Simulated Video Player Dialog ---
  void _showVideoPlayerDialog(BuildContext context, VideoData video) {
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
                      Image.network(
                        video.thumbnailUrl,
                        fit: BoxFit.cover,
                        height: 150,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey.shade800,
                          child: Icon(Icons.videocam_off_rounded, color: Colors.white.withOpacity(0.5), size: 50),
                        ),
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
                          backgroundColor: Colors.red.shade600, // Stop button
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
                          backgroundColor: video.primaryColor, // Video-specific primary color
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
                  child: const Icon(
                    Icons.access_time_rounded,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "🚀 $type Coming Soon!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
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
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
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
              ],
            ),
          ),
        );
      },
    );
  }
}


// --- NEW: VideoCard Widget for individual video list items ---
class VideoCard extends StatefulWidget {
  final VideoData video;
  final VoidCallback onTap;

  const VideoCard({
    Key? key,
    required this.video,
    required this.onTap,
  }) : super(key: key);

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard>
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
      animation: _hoverAnimation,
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
                  // Video Thumbnail/Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: widget.video.primaryColor.withOpacity(0.3),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(widget.video.thumbnailUrl),
                        fit: BoxFit.cover,
                        onError: (exception, stacktrace) {
                          // Fallback to icon if image fails
                          return; // The image network builder handles error, so we just return.
                        },
                      ),
                    ),
                    child: widget.video.thumbnailUrl.isEmpty || widget.video.thumbnailUrl.contains("placeholder")
                        ? Icon(
                      widget.video.icon,
                      color: Colors.white.withOpacity(0.7),
                      size: 36,
                    )
                        : null, // If there's a valid image, no icon needed.
                  ),
                  const SizedBox(width: 16),
                  // Video Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.video.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.video.isComingSoon
                              ? "Stay tuned!"
                              : "Duration: ${widget.video.duration}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (widget.video.isComingSoon) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "Coming Soon",
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
                  Icon(
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

  // Helper getter for consistency with your existing code
  Animation<double> get _hoverAnimation => _hoverController;
}
