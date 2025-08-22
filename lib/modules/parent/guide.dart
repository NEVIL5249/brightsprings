import 'package:flutter/material.dart';

class UsageGuideScreen extends StatefulWidget {
  @override
  _UsageGuideScreenState createState() => _UsageGuideScreenState();
}

class _UsageGuideScreenState extends State<UsageGuideScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> steps = [
    {"title": "Login and Role Selection", "description": "Login and select your role as 'Parent'.", "icon": Icons.login_rounded},
    {"title": "Book Appointments", "description": "Book appointments with psychologists through the dashboard.", "icon": Icons.calendar_today_rounded},
    {"title": "Track Child's Progress", "description": "Track your child's progress in the 'Report' section.", "icon": Icons.analytics_rounded},
    {"title": "Watch Training Videos", "description": "Watch training videos for better support.", "icon": Icons.ondemand_video_rounded},
    {"title": "Connect with Experts", "description": "Use the chat or video call to stay in touch with experts.", "icon": Icons.support_agent_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200), // Total animation duration
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo, // Smooth acceleration and deceleration
    );

    _controller.forward(); // Start the animation when the screen loads
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
              Expanded(child: _buildGuideStepsList()), // List of guide steps
              _buildBottomBar(), // Consistent bottom navigation
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
                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)], // Example: Purple gradient for guide
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8E2DE2).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon( // This can be const
              Icons.book_rounded, // Icon for guide/information
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
                  "Parent Usage Guide", // Updated header text
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text( // Cannot be const due to dynamic opacity
                  "How to navigate and utilize the app", // Updated sub-text
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
              Icons.info_outline_rounded, // Example: info icon
              color: Colors.white.withOpacity(0.8),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideStepsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Calculate delay for staggered animation
              double delay = index * 0.08; // Each item delays by 0.08 of the total duration
              double animationValue = Curves.easeOutExpo.transform(
                ((_controller.value - delay).clamp(0.0, 1.0) / (1.0 - delay))
                    .clamp(0.0, 1.0), // Normalize value for each item's animation
              );

              return Transform.translate(
                offset: Offset(0, 30 * (1 - animationValue)), // Slide in from bottom
                child: Opacity(
                  opacity: animationValue, // Fade in
                  child: _buildGuideStepCard(
                    stepNumber: index + 1,
                    title: step["title"],
                    description: step["description"],
                    icon: step["icon"],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildGuideStepCard({
    required int stepNumber,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)], // Purple accent
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "$stepNumber",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(icon, color: Colors.white.withOpacity(0.7), size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
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
              onTap: () => Navigator.pop(context)), // Back button for guide
          _buildBottomBarItem(Icons.calendar_today_rounded, "Appointments", false,
              onTap: () => _showComingSoonDialog(context, "Appointments")),
          _buildBottomBarItem(Icons.person_rounded, "Profile", false,
              onTap: () => _showComingSoonDialog(context, "Profile")),
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