import 'package:flutter/material.dart';
import 'dashboard.dart'; // Adjust path for dashboard if needed
import 'patient_list.dart'; // Adjust path if needed

// --- REVISED: Data Models for Patients and Reports ---

// Simple Patient model
class Patient {
  final String id;
  final String name;
  final String avatarUrl; // Optional: for displaying patient avatars
  Patient({required this.id, required this.name, this.avatarUrl = 'https://via.placeholder.com/150'});
}

// Data model for a single metric (reused)
class ReportMetricData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  ReportMetricData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

// Data model for a single trend/insight (reused)
class ReportTrendData {
  final String title;
  final String summary;
  final IconData icon;
  final Color primaryColor;
  final Color accentColor;

  ReportTrendData({
    required this.title,
    required this.summary,
    required this.icon,
    required this.primaryColor,
    required this.accentColor,
  });
}

// Data structure to hold reports for a single patient
class SinglePatientReportData {
  final List<ReportMetricData> metrics;
  final List<ReportTrendData> trends;
  SinglePatientReportData({required this.metrics, required this.trends});
}


class PatientReportsScreen extends StatefulWidget {
  const PatientReportsScreen({Key? key}) : super(key: key);

  @override
  _PatientReportsScreenState createState() => _PatientReportsScreenState();
}

class _PatientReportsScreenState extends State<PatientReportsScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedTimeframe = '7 Days'; // Default selected timeframe

  final List<String> _timeframes = ['7 Days', '30 Days', '90 Days', 'All Time'];

  // --- NEW: Dummy Patient List ---
  final List<Patient> _patients = [
    Patient(id: 'pat001', name: 'Alice Smith'),
    Patient(id: 'pat002', name: 'Bob Johnson'),
    Patient(id: 'pat003', name: 'Charlie Brown'),
    Patient(id: 'pat004', name: 'Diana Prince'),
  ];

  Patient? _selectedPatient; // Currently selected patient

  // --- NEW: Dummy Data for Individual Patient Reports ---
  late final Map<String, SinglePatientReportData> _dummyPatientReports;

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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // Start slightly below
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo,
    ));

    // Initialize dummy reports for each patient
    _dummyPatientReports = {
      'pat001': SinglePatientReportData(
        metrics: [
          ReportMetricData(label: "Avg. Mood Score", value: "4.5/5", icon: Icons.sentiment_very_satisfied_rounded, color: const Color(0xFF2ED573)),
          ReportMetricData(label: "Tasks Completed", value: "98%", icon: Icons.task_alt_rounded, color: const Color(0xFF00D2FF)),
          ReportMetricData(label: "Sessions Attended", value: "8/8", icon: Icons.videocam_rounded, color: const Color(0xFF6C5CE7)),
          ReportMetricData(label: "Engagement", value: "Excellent", icon: Icons.star_rounded, color: const Color(0xFFFDCB6E)),
        ],
        trends: [
          ReportTrendData(
            title: "Mood Trend: Very Positive",
            summary: "Alice has shown consistent improvement in mood over the last month.",
            icon: Icons.ssid_chart_rounded,
            primaryColor: const Color(0xFF2ED573), // Green for positive trends
            accentColor: const Color(0xFF1ABC9C),
          ),
          ReportTrendData(
            title: "Task Consistency: High",
            summary: "Successfully completed almost all assigned tasks.",
            icon: Icons.playlist_add_check_rounded,
            primaryColor: const Color(0xFF00D2FF), // Blue for tasks
            accentColor: const Color(0xFF3A7BD5),
          ),
        ],
      ),
      'pat002': SinglePatientReportData(
        metrics: [
          ReportMetricData(label: "Avg. Mood Score", value: "3.2/5", icon: Icons.sentiment_neutral_rounded, color: const Color(0xFFFFA800)),
          ReportMetricData(label: "Tasks Completed", value: "70%", icon: Icons.pending_actions_rounded, color: const Color(0xFFE17055)),
          ReportMetricData(label: "Sessions Attended", value: "5/8", icon: Icons.missed_video_call_rounded, color: const Color(0xFF6C5CE7)),
          ReportMetricData(label: "Engagement", value: "Moderate", icon: Icons.lightbulb_outline_rounded, color: const Color(0xFFFAB1A0)),
        ],
        trends: [
          ReportTrendData(
            title: "Mood Trend: Stable",
            summary: "Bob's mood has remained stable, but requires more focused interventions.",
            icon: Icons.data_usage_rounded,
            primaryColor: const Color(0xFFFFA800), // Orange for stable/needs attention
            accentColor: const Color(0xFFE17055),
          ),
          ReportTrendData(
            title: "Task Consistency: Needs Boost",
            summary: "Opportunity to improve consistency in daily task completion.",
            icon: Icons.warning_rounded,
            primaryColor: const Color(0xFFFF6B81), // Red for areas of improvement
            accentColor: const Color(0xFFEB3B5A),
          ),
        ],
      ),
      'pat003': SinglePatientReportData(
        metrics: [
          ReportMetricData(label: "Avg. Mood Score", value: "3.9/5", icon: Icons.sentiment_satisfied_alt_rounded, color: const Color(0xFF2ED573)),
          ReportMetricData(label: "Tasks Completed", value: "85%", icon: Icons.task_alt_rounded, color: const Color(0xFF00D2FF)),
          ReportMetricData(label: "Sessions Attended", value: "7/8", icon: Icons.videocam_rounded, color: const Color(0xFF6C5CE7)),
          ReportMetricData(label: "Engagement", value: "Good", icon: Icons.thumb_up_rounded, color: const Color(0xFFFDCB6E)),
        ],
        trends: [
          ReportTrendData(
            title: "Emotional Regulation",
            summary: "Charlie demonstrates improved coping mechanisms.",
            icon: Icons.self_improvement_rounded,
            primaryColor: const Color(0xFF00D2FF),
            accentColor: const Color(0xFF3A7BD5),
          ),
          ReportTrendData(
            title: "Progress in Goals",
            summary: "Steady progress toward short-term therapeutic goals.",
            icon: Icons.track_changes_rounded,
            primaryColor: const Color(0xFF2ED573),
            accentColor: const Color(0xFF1ABC9C),
          ),
        ],
      ),
      'pat004': SinglePatientReportData(
        metrics: [
          ReportMetricData(label: "Avg. Mood Score", value: "4.8/5", icon: Icons.mood_rounded, color: const Color(0xFF2ED573)),
          ReportMetricData(label: "Tasks Completed", value: "100%", icon: Icons.check_circle_rounded, color: const Color(0xFF00D2FF)),
          ReportMetricData(label: "Sessions Attended", value: "10/10", icon: Icons.videocam_rounded, color: const Color(0xFF6C5CE7)),
          ReportMetricData(label: "Engagement", value: "Exceptional", icon: Icons.star_border_rounded, color: const Color(0xFFFDCB6E)),
        ],
        trends: [
          ReportTrendData(
            title: "Overall Well-being",
            summary: "Diana shows exceptional progress and high engagement.",
            icon: Icons.health_and_safety_rounded,
            primaryColor: const Color(0xFF2ED573),
            accentColor: const Color(0xFF1ABC9C),
          ),
          ReportTrendData(
            title: "Therapy Adherence",
            summary: "Excellent adherence to therapy plans and recommendations.",
            icon: Icons.verified_rounded,
            primaryColor: const Color(0xFF00D2FF),
            accentColor: const Color(0xFF3A7BD5),
          ),
        ],
      ),
    };

    // Set initial selected patient to the first one
    if (_patients.isNotEmpty) {
      _selectedPatient = _patients.first;
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper to get current report data based on selected patient
  SinglePatientReportData? _getCurrentPatientReportData() {
    if (_selectedPatient == null) {
      return null;
    }
    return _dummyPatientReports[_selectedPatient!.id];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1421), // Consistent dark background
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                _buildModernHeader(),
                Expanded(child: _buildBodyContent()),
                _buildBottomBar(),
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
                    colors: [Color(0xFFE17055), Color(0xFFFAB1A0)], // Orange gradient for reports
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
                  Icons.analytics_rounded, // Icon specific to reports
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
                      "Patient Reports",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedPatient != null
                          ? "Insights for ${_selectedPatient!.name}" // Show selected patient name
                          : "Select a patient to view reports", // Default text
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
                  Icons.download_rounded, // Example: export icon
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPatientSelector(), // New patient selector
        ],
      ),
    );
  }

  Widget _buildPatientSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<Patient>(
        value: _selectedPatient,
        decoration: InputDecoration(
          labelText: "Select Patient",
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: InputBorder.none, // Remove default border
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          suffixIcon: Icon(Icons.arrow_drop_down_rounded, color: Colors.white.withOpacity(0.8)),
        ),
        dropdownColor: const Color(0xFF1A2332), // Background for the dropdown menu
        style: const TextStyle(color: Colors.white, fontSize: 16),
        isExpanded: true,
        items: _patients.map((patient) {
          return DropdownMenuItem(
            value: patient,
            child: Text(
              patient.name,
              style: const TextStyle(color: Colors.white), // Color for items in the dropdown
            ),
          );
        }).toList(),
        onChanged: (Patient? newValue) {
          setState(() {
            _selectedPatient = newValue;
            // Optionally reset timeframe or other filters when patient changes
            _selectedTimeframe = '7 Days';
            // Re-run animations for new data if desired, though current data changes immediately
            _controller.forward(from: 0.0); // Restart animations
          });
        },
      ),
    );
  }

  Widget _buildBodyContent() {
    SinglePatientReportData? currentReport = _getCurrentPatientReportData();

    if (_selectedPatient == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search_rounded, color: Colors.white.withOpacity(0.5), size: 60),
            const SizedBox(height: 20),
            Text(
              "Please select a patient to view their reports.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7)),
            ),
          ],
        ),
      );
    }

    // Display content only if a patient is selected
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeframeSelector(),
          const SizedBox(height: 20),
          _buildMetricsGrid(currentReport!.metrics), // Pass specific patient's metrics
          const SizedBox(height: 20),
          _buildTrendsSection(currentReport.trends), // Pass specific patient's trends
          const SizedBox(height: 40),
          _buildDetailedReportButton(),
        ],
      ),
    );
  }

  Widget _buildTimeframeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _timeframes.map((timeframe) {
          bool isSelected = _selectedTimeframe == timeframe;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTimeframe = timeframe;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF6C5CE7) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    timeframe,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- MODIFIED: Pass specific metrics list ---
  Widget _buildMetricsGrid(List<ReportMetricData> metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Key Metrics (Last $_selectedTimeframe)",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: metrics.length, // Use passed metrics length
          itemBuilder: (context, index) {
            final metric = metrics[index]; // Use passed metrics
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double delay = index * 0.1;
                double animationValue = Curves.easeOutExpo.transform(
                  ((_controller.value - delay).clamp(0.0, 1.0) / (1.0 - delay))
                      .clamp(0.0, 1.0),
                );
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - animationValue)),
                  child: Opacity(
                    opacity: animationValue,
                    child: MetricCard(metric: metric),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // --- MODIFIED: Pass specific trends list ---
  Widget _buildTrendsSection(List<ReportTrendData> trends) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Trends & Insights (Last $_selectedTimeframe)",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 15),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: trends.length, // Use passed trends length
          itemBuilder: (context, index) {
            final trend = trends[index]; // Use passed trends
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double delay = (index + (_getCurrentPatientReportData()?.metrics.length ?? 0)) * 0.1; // Stagger after metrics
                  double animationValue = Curves.easeOutExpo.transform(
                    ((_controller.value - delay).clamp(0.0, 1.0) / (1.0 - delay))
                        .clamp(0.0, 1.0),
                  );
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - animationValue)),
                    child: Opacity(
                      opacity: animationValue,
                      child: TrendCard(trend: trend),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailedReportButton() {
    String buttonText = _selectedPatient != null
        ? "Generate Detailed Report for ${_selectedPatient!.name}"
        : "Generate Detailed Report";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)], // Purple gradient for action
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _selectedPatient != null
            ? () {
          _showComingSoonDialog(context, "Detailed Patient Reports for ${_selectedPatient!.name}");
        }
            : null, // Disable button if no patient selected
        icon: const Icon(Icons.description_rounded, color: Colors.white, size: 24),
        label: Text(
          buttonText,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  // --- Existing Bottom Bar and Dialogs (unchanged, for completeness) ---
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
          _buildBottomBarItem(Icons.dashboard_rounded, "Dashboard", false, onTap: () {
            // Navigate back to dashboard, ensuring it's the root if needed
            Navigator.popUntil(context, (route) => route.isFirst || route.settings.name == '/psychologistDashboard');
          }),
          _buildBottomBarItem(Icons.people_rounded, "Patients", false, onTap: () {
            // Navigate to patient list, assuming it's a separate route
            Navigator.push(context, MaterialPageRoute(builder: (context) => PsychologistPatientList()));
          }),
          _buildBottomBarItem(Icons.analytics_rounded, "Reports", true), // Active state for current screen
          _buildBottomBarItem(Icons.logout_rounded, "Logout", false, onTap: () => _showLogoutDialog()),
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
}

// --- Metric Card Widget (unchanged) ---
class MetricCard extends StatelessWidget {
  final ReportMetricData metric;

  const MetricCard({Key? key, required this.metric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(metric.icon, color: metric.color, size: 36),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric.value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: metric.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                metric.label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Trend Card Widget (unchanged) ---
class TrendCard extends StatelessWidget {
  final ReportTrendData trend;

  const TrendCard({Key? key, required this.trend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
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
                colors: [trend.primaryColor, trend.accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(trend.icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trend.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  trend.summary,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}