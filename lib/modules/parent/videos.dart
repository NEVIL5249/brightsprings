import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// --- VideoData Model ---
class VideoData {
  final String title;
  final String duration;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final IconData icon;
  final Color primaryColor;
  final Color accentColor;
  final bool isComingSoon;

  VideoData({
    required this.title,
    required this.duration,
    required this.thumbnailUrl,
    required this.videoUrl,
    this.description = '',
    this.icon = Icons.play_circle_fill,
    this.primaryColor = Colors.blue,
    this.accentColor = Colors.lightBlueAccent,
    this.isComingSoon = false,
  });
}

// --- Screen ---
class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<VideoData> _videos = [
    VideoData(
      title: 'Understanding Emotions',
      duration: '5:30',
      description: 'Learn to identify and manage emotions.',
      thumbnailUrl: "https://img.youtube.com/vi/MIr3RsUWrdo/0.jpg",
      videoUrl:
          "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
      primaryColor: const Color(0xFF6C5CE7),
      accentColor: const Color(0xFFA29BFE),
    ),
    VideoData(
      title: 'Improving Communication',
      duration: '7:20',
      description: 'Tips for effective parent-child communication.',
      thumbnailUrl: "https://img.youtube.com/vi/lnV1g0wTbpE/0.jpg",
      videoUrl:
          "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
      primaryColor: const Color(0xFF00B894),
      accentColor: const Color(0xFF55EFC4),
    ),
    VideoData(
      title: 'Routine Building Tips',
      duration: '4:10',
      description: 'Strategies for creating healthy daily routines.',
      thumbnailUrl: "https://img.youtube.com/vi/X655B4ISakg/0.jpg",
      videoUrl: "https://samplelib.com/lib/preview/mp4/sample-5s.mp4",
      primaryColor: const Color(0xFFE17055),
      accentColor: const Color(0xFFFAB1A0),
    ),
    VideoData(
      title: 'New Videos Coming',
      duration: 'N/A',
      description: 'More expert-led training videos on the way!',
      thumbnailUrl: "",
      videoUrl: "",
      primaryColor: Colors.grey,
      accentColor: Colors.grey,
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
      backgroundColor: const Color(0xFF0D1421),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildVideoList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Row(
        children: const [
          Icon(Icons.ondemand_video_rounded, color: Colors.white, size: 32),
          SizedBox(width: 16),
          Text(
            "Training Videos 📺",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVideoList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final video = _videos[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: VideoCard(
              video: video,
              onTap: () => _handleVideoTap(context, video),
            ),
          );
        },
      ),
    );
  }

  void _handleVideoTap(BuildContext context, VideoData video) {
    if (video.isComingSoon) {
      _showComingSoonDialog(context);
    } else {
      _showVideoPlayerDialog(context, video);
    }
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🚀 Coming Soon"),
        content: const Text("This training video will be available soon."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void _showVideoPlayerDialog(BuildContext context, VideoData video) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: VideoPlayerWidget(videoUrl: video.videoUrl),
        ),
      ),
    );
  }
}

// --- Video Card ---
class VideoCard extends StatelessWidget {
  final VideoData video;
  final VoidCallback onTap;

  const VideoCard({Key? key, required this.video, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: video.primaryColor.withOpacity(0.3),
                image: video.thumbnailUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(video.thumbnailUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: video.thumbnailUrl.isEmpty
                  ? Icon(video.icon, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    video.isComingSoon ? "Coming Soon" : video.duration,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.play_arrow, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// --- Video Player Widget ---
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(_controller),
              VideoProgressIndicator(_controller, allowScrubbing: true),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
