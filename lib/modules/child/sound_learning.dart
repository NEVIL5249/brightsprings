import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart'; // Uncomment if you add audioplayers to pubspec.yaml

// --- NEW: SoundData for specific sound information ---
class SoundData {
  final String title;
  final String description; // e.g., "Letter A sound" or "Animal sound"
  final String audioAssetPath; // Path to audio file in assets
  final IconData icon;
  final Color primaryColor;
  final Color accentColor;
  final bool isComingSoon;

  SoundData({
    required this.title,
    this.description = "",
    required this.audioAssetPath,
    required this.icon,
    required this.primaryColor,
    required this.accentColor,
    this.isComingSoon = false,
  });
}

class SoundLearningScreen extends StatefulWidget {
  @override
  _SoundLearningScreenState createState() => _SoundLearningScreenState();
}

class _SoundLearningScreenState extends State<SoundLearningScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  // late AudioPlayer _audioPlayer; // Uncomment if using audioplayers

  final List<SoundData> _sounds = [
    SoundData(
      title: "A",
      description: "Letter A sound",
      audioAssetPath: "assets/audio/letter_a.mp3", // YOUR AUDIO PATH
      icon: Icons.abc_rounded,
      primaryColor: const Color(0xFF53A8B6),
      accentColor: const Color(0xFF76C4D2),
    ),
    SoundData(
      title: "B",
      description: "Letter B sound",
      audioAssetPath: "assets/audio/letter_b.mp3", // YOUR AUDIO PATH
      icon: Icons.abc_rounded,
      primaryColor: const Color(0xFFC70039),
      accentColor: const Color(0xFFE84393),
    ),
    SoundData(
      title: "C",
      description: "Letter C sound",
      audioAssetPath: "assets/audio/letter_c.mp3", // YOUR AUDIO PATH
      icon: Icons.abc_rounded,
      primaryColor: const Color(0xFFFFA500),
      accentColor: const Color(0xFFFFC14D),
    ),
    SoundData(
      title: "Cat",
      description: "Sound of a Cat",
      audioAssetPath: "assets/audio/cat_meow.mp3", // YOUR AUDIO PATH
      icon: Icons.pets_rounded,
      primaryColor: const Color(0xFF28B463),
      accentColor: const Color(0xFF58D683),
    ),
    SoundData(
      title: "Dog",
      description: "Sound of a Dog",
      audioAssetPath: "assets/audio/dog_bark.mp3", // YOUR AUDIO PATH
      icon: Icons.pets_rounded,
      primaryColor: const Color(0xFF8E44AD),
      accentColor: const Color(0xFFBB8FCE),
    ),
    SoundData(
      title: "Apple",
      description: "Sound of the word Apple",
      audioAssetPath: "assets/audio/apple_word.mp3", // YOUR AUDIO PATH
      icon: Icons.apple_rounded,
      primaryColor: const Color(0xFFE74C3C),
      accentColor: const Color(0xFFEC7063),
    ),
    SoundData(
      title: "New Sounds",
      description: "More sounds coming soon!",
      audioAssetPath: "", // No audio for coming soon
      icon: Icons.hourglass_empty_rounded,
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

    // Initialize audio player if using audioplayers
    // _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    // Dispose audio player if using audioplayers
    // _audioPlayer.dispose();
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
              Expanded(child: _buildSoundList()),
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
                colors: [Color(0xFF0F9D58), Color(0xFF34A853)], // Green gradient for sound/audio
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F9D58).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon( // This can be const
              Icons.volume_up_rounded, // Icon specific to sound
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
                  "Hear & Learn Sounds!", // Updated header text
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text( // Cannot be const due to dynamic opacity
                  "Practice words, letters & more!", // Updated sub-text
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
              Icons.search_rounded, // Example: search sounds
              color: Colors.white.withOpacity(0.8),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoundList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: ListView.builder(
        itemCount: _sounds.length,
        itemBuilder: (context, index) {
          final sound = _sounds[index];
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
                    child: SoundCard(
                      sound: sound,
                      onTap: () => _handleSoundTap(context, sound),
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
          _buildBottomBarItem(Icons.favorite_rounded, "Favorites", false,
              onTap: () => _showComingSoonDialog(context, "Favorites")),
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

  void _handleSoundTap(BuildContext context, SoundData sound) {
    if (sound.isComingSoon || sound.audioAssetPath.isEmpty) {
      _showComingSoonDialog(context, "Sound");
    } else {
      // Logic to play sound
      _playAudio(sound.audioAssetPath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Playing: ${sound.title}", style: const TextStyle(color: Colors.white)),
          backgroundColor: sound.primaryColor,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  // Function to play audio (placeholder)
  void _playAudio(String assetPath) async {
    // If you uncommented audioplayers, you can use:
    // await _audioPlayer.play(AssetSource(assetPath));
    print("Attempting to play audio from: $assetPath");
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
                Text( // Cannot be const because of dynamic type string
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

// --- NEW: SoundCard Widget for individual sound list items ---
class SoundCard extends StatefulWidget {
  final SoundData sound;
  final VoidCallback onTap;

  const SoundCard({
    Key? key,
    required this.sound,
    required this.onTap,
  }) : super(key: key);

  @override
  _SoundCardState createState() => _SoundCardState();
}

class _SoundCardState extends State<SoundCard>
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
                  // Sound Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [widget.sound.primaryColor, widget.sound.accentColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.sound.primaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon( // Cannot be const due to dynamic widget.sound.icon
                      widget.sound.icon,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Sound Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text( // Cannot be const due to dynamic widget.sound.title
                          widget.sound.title,
                          style: const TextStyle( // TextStyle itself can be const
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text( // Cannot be const due to dynamic widget.sound.description and widget.sound.isComingSoon
                          widget.sound.isComingSoon
                              ? "Stay tuned for more!"
                              : widget.sound.description,
                          style: TextStyle( // TextStyle itself can be const
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (widget.sound.isComingSoon) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text( // This can be const
                              "New Sound Coming",
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
                    Icons.play_arrow_rounded, // Play icon
                    color: Colors.white.withOpacity(0.8),
                    size: 24,
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