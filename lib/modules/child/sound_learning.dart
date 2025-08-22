import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// --- MODEL ---
class SoundData {
  final String title;
  final String description;
  final String audioAssetPath;
  final bool isLocal; // true for local assets, false for URLs
  final IconData icon;
  final Color primaryColor;
  final Color accentColor;

  SoundData({
    required this.title,
    required this.description,
    required this.audioAssetPath,
    this.isLocal = false,
    required this.icon,
    required this.primaryColor,
    Color? accentColor, // make optional
  }) : accentColor = accentColor ?? primaryColor.withOpacity(0.7);
}

/// --- MAIN WIDGET ---
class LearningSoundsScreen extends StatefulWidget {
  const LearningSoundsScreen({Key? key}) : super(key: key);

  @override
  State<LearningSoundsScreen> createState() => _LearningSoundsScreenState();
}

class _LearningSoundsScreenState extends State<LearningSoundsScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _currentlyPlaying = '';
  bool _isLoading = false;

  // --- List of sounds with local assets option ---
  final List<SoundData> _sounds = [
    SoundData(
      title: "Cat",
      description: "Meow sound",
      audioAssetPath: "sounds/cat_meow.mp3", // Put MP3 file in assets/sounds/
      isLocal: true,
      icon: Icons.pets_rounded,
      primaryColor: const Color(0xFFE17055), // Coordinated with Games screen
      accentColor: const Color(0xFFFD79A8), // Coordinated with Games screen
    ),
    SoundData(
      title: "Dog",
      description: "Barking sound",
      audioAssetPath: "sounds/dog_bark.mp3",
      isLocal: true,
      icon: Icons.pets,
      primaryColor: const Color(0xFF00B894), // Coordinated with Games screen
      accentColor: const Color(0xFF00CEC9), // Coordinated with Games screen
    ),
    SoundData(
      title: "Bird",
      description: "Chirping sound",
      audioAssetPath: "sounds/bird_chirp.mp3",
      isLocal: true,
      icon: Icons.flutter_dash,
      primaryColor: const Color(0xFFFDCB6E), // Coordinated with Games screen
      accentColor: const Color(0xFFE84393), // Coordinated with Games screen
    ),
  ];

  // Alternative with online URLs
  final List<SoundData> _onlineSounds = [
    SoundData(
      title: "Test Sound 1",
      description: "Sample audio",
      audioAssetPath: "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      isLocal: false,
      icon: Icons.music_note,
      primaryColor: const Color(0xFF667EEA), // Coordinated with Games screen
      accentColor: const Color(0xFF764BA2), // Coordinated with Games screen
    ),
    SoundData(
      title: "Test Sound 2",
      description: "Sample music",
      audioAssetPath: "https://file-examples.com/storage/fe86c86bb6c92b1c59b4dd5/2017/11/file_example_MP3_700KB.mp3",
      isLocal: false,
      icon: Icons.audiotrack,
      primaryColor: const Color(0xFFF39C12),
      accentColor: const Color(0xFF2E86C1),
    ),
  ];

  bool _useLocalAssets = true; // Toggle between local and online

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          if (state != PlayerState.playing) {
            _currentlyPlaying = '';
            _isLoading = false;
          }
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _currentlyPlaying = '';
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String path, String title, bool isLocal) async {
    try {
      setState(() {
        _isLoading = true;
        _currentlyPlaying = title;
      });

      await _audioPlayer.stop();

      if (isLocal) {
        await _audioPlayer.play(AssetSource(path));
        debugPrint("Playing local asset: $path");
      } else {
        await _audioPlayer.play(UrlSource(path));
        debugPrint("Playing online audio: $path");
      }
    } catch (e) {
      debugPrint("Audio error: $e");
      setState(() {
        _isLoading = false;
        _currentlyPlaying = '';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isLocal
                ? "Audio file not found: $title\nMake sure to add MP3 files to assets/sounds/"
                : "Failed to load online audio: $title"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    }
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
                colors: [Color(0xFFE17055), Color(0xFFFD79A8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE17055).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.volume_up_rounded, // Relevant icon for sounds
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
                  "Learning Sounds 🎶",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Tap to hear the sounds!",
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
            child: IconButton(
              icon: Icon(
                _useLocalAssets ? Icons.cloud_upload_rounded : Icons.folder_rounded,
                color: Colors.white.withOpacity(0.8),
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _useLocalAssets = !_useLocalAssets;
                  _audioPlayer.stop();
                  _currentlyPlaying = '';
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildInfoBanner() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 24),
  //     padding: const EdgeInsets.all(20),
      
  //   );
  // }

  Widget _buildSoundCard(SoundData sound, int index) {
    final isPlaying = _currentlyPlaying == sound.title;
    final isThisLoading = _isLoading && _currentlyPlaying == sound.title;

    return GestureDetector(
      onTap: () => _playAudio(sound.audioAssetPath, sound.title, sound.isLocal),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isPlaying ? sound.primaryColor.withOpacity(0.9) : sound.primaryColor,
              isPlaying ? sound.accentColor.withOpacity(0.9) : sound.accentColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20), // Consistent border radius
          boxShadow: [
            BoxShadow(
              color: sound.primaryColor.withOpacity(isPlaying ? 0.4 : 0.2),
              blurRadius: isPlaying ? 20 : 10,
              offset: Offset(0, isPlaying ? 10 : 5),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                sound.icon,
                color: Colors.white,
                size: isPlaying ? 36 : 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sound.title,
                    style: TextStyle(
                      fontSize: isPlaying ? 22 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sound.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  if (sound.isLocal) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.folder, color: Colors.white60, size: 12),
                        SizedBox(width: 4),
                        Text(
                          "Local asset",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white60,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (isPlaying) ...[
                    const SizedBox(height: 8),
                    Text(
                      "Now playing...",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isThisLoading
                  ? const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Icon(
                      isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentSounds = _useLocalAssets ? _sounds : _onlineSounds;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1421),
      body: SafeArea(
        child: Column(
          children: [
            _buildModernHeader(),
            const SizedBox(height: 20),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: currentSounds.length,
                itemBuilder: (context, index) {
                  return _buildSoundCard(currentSounds[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}