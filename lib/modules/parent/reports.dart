import 'package:flutter/material.dart';

// --- NEW: ReportData for specific report information ---
class ReportData {
  final String date;
  final String summary;
  final IconData icon;
  final Color primaryColor;
  final Color accentColor;

  ReportData({
    required this.date,
    required this.summary,
    required this.icon,
    required this.primaryColor,
    required this.accentColor,
  });
}

class ChildReportScreen extends StatefulWidget {
  @override
  _ChildReportScreenState createState() => _ChildReportScreenState();
}

class _ChildReportScreenState extends State<ChildReportScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<ReportData> _reports = [
    ReportData(
      date: 'June 10',
      summary: 'Completed 5 tasks in alphabet games. Excellent effort!',
      icon: Icons.assignment_turned_in_rounded,
      primaryColor: const Color(0xFF00B894),
      accentColor: const Color(0xFF55EFC4),
    ),
    ReportData(
      date: 'June 12',
      summary: 'Showed significant improvement in sound recognition activities.',
      icon: Icons.hearing_rounded,
      primaryColor: const Color(0xFFE17055),
      accentColor: const Color(0xFFFAB1A0),
    ),
    ReportData(
      date: 'June 15',
      summary: 'Successfully started a new animated learning module on numbers.',
      icon: Icons.play_circle_filled_rounded,
      primaryColor: const Color(0xFFFDCB6E),
      accentColor: const Color(0xFFFFE66D),
    ),
    ReportData(
      date: 'June 18',
      // FIX: Changed single quotes inside string to escaped single quotes (\')
      summary: 'Engaged well in tracing letters. Needs more practice with \'S\'.',
      icon: Icons.edit_note_rounded,
      primaryColor: const Color(0xFF6C5CE7),
      accentColor: const Color(0xFFA29BFE),
    ),
    ReportData(
      date: 'June 20',
      // FIX: Changed single quotes inside string to escaped single quotes (\')
      summary: 'Achieved a new high score in the \'Tap the Alphabet\' game!',
      icon: Icons.leaderboard_rounded,
      primaryColor: const Color(0xFFFD79A8),
      accentColor: const Color(0xFFE84393),
    ),
    ReportData(
      date: 'June 22',
      summary: 'Successfully identified all primary colors in the video lesson.',
      icon: Icons.color_lens_rounded,
      primaryColor: const Color(0xFF00CEC9),
      accentColor: const Color(0xFF00B894),
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
              Expanded(child: _buildReportList()),
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
                colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3498DB).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.analytics_rounded,
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
                  "Child Progress Report",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Track their learning journey",
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
              Icons.filter_list_rounded,
              color: Colors.white.withOpacity(0.8),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      itemCount: _reports.length,
      itemBuilder: (context, index) {
        final report = _reports[index];
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
                  child: ReportCard(report: report),
                ),
              );
            },
          ),
        );
      },
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
          _buildBottomBarItem(Icons.assessment_rounded, "Insights", false,
              onTap: () => _showComingSoonDialog(context, "Insights")),
          _buildBottomBarItem(Icons.settings_rounded, "Settings", false,
              onTap: () => _showComingSoonDialog(context, "Settings")),
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
              color: const Color(0xFF1A2332),
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

// ReportCard Widget
class ReportCard extends StatelessWidget {
  final ReportData report;

  const ReportCard({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [report.primaryColor, report.accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: report.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              report.icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Report for: ${report.date}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  report.summary,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white.withOpacity(0.6),
            size: 18,
          ),
        ],
      ),
    );
  }
}