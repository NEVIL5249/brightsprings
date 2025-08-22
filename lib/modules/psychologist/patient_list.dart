import 'package:flutter/material.dart';
import 'connect.dart'; // Adjust path
import 'dashboard.dart'; // Adjust path for bottom bar
import 'patient_reports.dart'; // Adjust path for bottom bar

// Define a Patient model for better type safety and organization
class Patient {
  final String name;
  final String status;
  final String avatarUrl; // Optional: for actual images
  final Color statusColor; // For visual indication of status

  Patient({
    required this.name,
    required this.status,
    this.avatarUrl = 'https://via.placeholder.com/150', // Default placeholder
    required this.statusColor,
  });
}

class PsychologistPatientList extends StatefulWidget {
  @override
  _PsychologistPatientListState createState() => _PsychologistPatientListState();
}

class _PsychologistPatientListState extends State<PsychologistPatientList>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Patient> patients = [
    Patient(name: 'Hitesh Soni', status: 'Active', statusColor: Colors.greenAccent),
    Patient(name: 'Purvi Mehta', status: 'Needs Review', statusColor: Colors.orangeAccent),
    Patient(name: 'Sameer Gupta', status: 'Progressing', statusColor: Colors.blueAccent),
    Patient(name: 'Aisha Sharma', status: 'On Break', statusColor: Colors.grey),
    Patient(name: 'Rohan Patel', status: 'New Patient', statusColor: Colors.purpleAccent),
    Patient(name: 'Priya Singh', status: 'Active', statusColor: Colors.greenAccent),
    Patient(name: 'Amit Kumar', status: 'Needs Review', statusColor: Colors.orangeAccent),
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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // Start slightly below
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo,
    ));

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
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                _buildModernHeader(),
                Expanded(child: _buildPatientListView()),
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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)], // Consistent blue-purple gradient
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
              Icons.people_alt_rounded, // Icon specific to patients
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
                  "My Patients 🧑‍🤝‍🧑",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Manage your patient list",
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
              Icons.search_rounded, // Search icon
              color: Colors.white.withOpacity(0.8),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double delay = index * 0.08; // Stagger animation for each list item
              double animationValue = Curves.easeOutExpo.transform(
                ((_controller.value - delay).clamp(0.0, 1.0) / (1.0 - delay))
                    .clamp(0.0, 1.0),
              );
              return Transform.translate(
                offset: Offset(0, 30 * (1 - animationValue)),
                child: Opacity(
                  opacity: animationValue,
                  child: PatientListItem(patient: patient, onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ConnectCounselScreen(patientName: patient.name)
                    ));
                  }),
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
          _buildBottomBarItem(Icons.dashboard_rounded, "Dashboard", false, onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst || route.settings.name == '/psychologistDashboard');
          }),
          _buildBottomBarItem(Icons.people_rounded, "Patients", true), // Active state for current screen
          _buildBottomBarItem(Icons.analytics_rounded, "Reports", false, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PatientReportsScreen()));
          }),
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


// --- Custom Patient List Item Widget ---
class PatientListItem extends StatelessWidget {
  final Patient patient;
  final VoidCallback onTap;

  const PatientListItem({
    Key? key,
    required this.patient,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08), // Slightly transparent background
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
          children: [
            // Patient Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: patient.statusColor.withOpacity(0.2), // Use status color for avatar background
              backgroundImage: NetworkImage(patient.avatarUrl), // Use NetworkImage for placeholder or actual images
              child: patient.avatarUrl.isEmpty || patient.avatarUrl == 'https://via.placeholder.com/150'
                  ? Text(
                patient.name[0].toUpperCase(),
                style: TextStyle(
                  color: patient.statusColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : null,
            ),
            const SizedBox(width: 16),
            // Patient Name and Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: patient.statusColor),
                      const SizedBox(width: 8),
                      Text(
                        patient.status,
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
            ),
            // Action Icon (e.g., connect, view profile)
            Icon(
              Icons.arrow_forward_ios_rounded, // Modern arrow icon
              color: Colors.white.withOpacity(0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}