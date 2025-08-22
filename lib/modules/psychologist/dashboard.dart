import 'package:flutter/material.dart';
import 'patient_list.dart';
import 'connect.dart';
import 'assign_task.dart';
import 'research_articles.dart';
import 'patient_reports.dart'; // <--- ADD THIS IMPORT

class PsychologistDashboard extends StatefulWidget {
  @override
  _PsychologistDashboardState createState() => _PsychologistDashboardState();
}

class _PsychologistDashboardState extends State<PsychologistDashboard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<PsychologistTileData> _tiles = [
    PsychologistTileData(
      icon: Icons.people_alt_rounded,
      title: "My Patients",
      description: "Manage & track progress",
      color: const Color(0xFF667EEA), // A vibrant blue-purple
      lightColor: const Color(0xFF764BA2),
    ),
    PsychologistTileData(
      icon: Icons.video_camera_front_rounded,
      title: "Video Sessions",
      description: "Connect with patients",
      color: const Color(0xFF00D2FF), // A bright sky blue
      lightColor: const Color(0xFF3A7BD5),
    ),
    // NEW TILE: Assign Task
    PsychologistTileData(
      icon: Icons.assignment_rounded, // Task icon
      title: "Assign Tasks",
      description: "Set activities & goals",
      color: const Color(0xFFFDCB6E), // A warm yellow/orange
      lightColor: const Color(0xFFFFE66D),
    ),
    PsychologistTileData(
      icon: Icons.analytics_rounded,
      title: "Patient Reports",
      description: "Analyze development",
      color: const Color(0xFFE17055), // A deep red-orange
      lightColor: const Color(0xFFFAB1A0),
    ),
    PsychologistTileData(
      icon: Icons.article_rounded,
      title: "Research Articles",
      description: "Access latest studies",
      color: const Color(0xFF2ED573), // A lively green
      lightColor: const Color(0xFF1ABC9C),
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
              _buildModernHeader(),
              Expanded(child: _buildPsychologistGrid()),
              _buildBottomSection(),
            ],
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
                ),
                child: const Icon(
                  Icons.psychology_alt_rounded,
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
                      "Psychologist Dashboard 🧠",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Supporting your patient's journey",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
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
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildQuickStats(),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatItem("Today's Sessions", "3", Colors.green)),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.1)),
          Expanded(child: _buildStatItem("Active Patients", "12", Colors.blue)),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.1)),
          Expanded(child: _buildStatItem("Next Appointment", "10 AM", Colors.orange)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.6)),
        ),
      ],
    );
  }

  Widget _buildPsychologistGrid() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: _tiles.length, // Automatically adjusts to the new tile count
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double delay = index * 0.1;
              double animationValue = Curves.easeOutExpo.transform(
                ((_controller.value - delay).clamp(0.0, 1.0) / (1.0 - delay)).clamp(0.0, 1.0),
              );

              return Transform.translate(
                offset: Offset(0, 50 * (1 - animationValue)),
                child: Opacity(
                  opacity: animationValue,
                  child: PsychologistTile(
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

  void _handleTileTap(int index) {
    // Note: The indices have shifted due to the new tile.
    switch (index) {
      case 0: // My Patients
        Navigator.push(context, MaterialPageRoute(builder: (_) => PsychologistPatientList()));
        break;
      case 1: // Video Sessions
        Navigator.push(context, MaterialPageRoute(
            builder: (_) => ConnectCounselScreen(patientName: "John Doe"))); // Example patient name
        break;
      case 2: // Assign Tasks (NEW POSITION)
      // Pass a patient name or navigate to a screen to select a patient first
        Navigator.push(context, MaterialPageRoute(
            builder: (_) => AssignTaskScreen(patientName: "John Doe"))); // Example patient name
        break;
      case 3: // Patient Reports (shifted from index 2 to 3)
      // Navigate to the PatientReportsScreen
        Navigator.push(context, MaterialPageRoute(builder: (_) => PatientReportsScreen())); // <--- CHANGE IS HERE
        break;
      case 4: // Research Articles (shifted from index 3 to 4)
        Navigator.push(context, MaterialPageRoute(builder: (_) => ResearchArticlesScreen()));
        break;
    }
  }


  Widget _buildBottomSection() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBottomBarItem(Icons.dashboard_rounded, "Dashboard", true),
          _buildBottomBarItem(Icons.people_rounded, "Patients", false, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PsychologistPatientList()))), // Added onTap
          _buildBottomBarItem(Icons.videocam_rounded, "Connect", false, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConnectCounselScreen(patientName: "John Doe")))), // Added onTap
          GestureDetector(
            onTap: () => _showLogoutDialog(),
            child: _buildBottomBarItem(Icons.logout_rounded, "Logout", false),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBarItem(IconData icon, String label, bool isActive, {VoidCallback? onTap}) {
    return GestureDetector( // Added GestureDetector to bottom bar items
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2332),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.logout_rounded, color: Colors.red, size: 30),
                ),
                const SizedBox(height: 16),
                const Text(
                  "End Session?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  "Are you sure you want to logout from the psychologist dashboard?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7)),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Logout"),
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

  // Generic Coming Soon Dialog (reused from previous screens)
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
                    backgroundColor: const Color(0xFF6C5CE7),
                    foregroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
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

class PsychologistTileData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color lightColor;

  PsychologistTileData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.lightColor,
  });
}

class PsychologistTile extends StatelessWidget {
  final PsychologistTileData data;
  final VoidCallback onTap;

  const PsychologistTile({Key? key, required this.data, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [data.color, data.lightColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(data.icon, color: Colors.white, size: 30),
            const Spacer(),
            Text(
              data.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              data.description,
              style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9)),
            ),
          ],
        ),
      ),
    );
  }
}