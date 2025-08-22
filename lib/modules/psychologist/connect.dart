import 'package:flutter/material.dart';
import 'assign_task.dart'; // Adjust import path if necessary
import 'dashboard.dart'; // Adjust path for bottom bar
import 'patient_reports.dart'; // Adjust path for bottom bar
import 'patient_list.dart'; // Adjust path for patient list

// --- ConnectOptionData for defining connection options ---
class ConnectOptionData {
  final String title;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color accentColor;

  ConnectOptionData({
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.accentColor,
  });
}

class ConnectCounselScreen extends StatefulWidget {
  final String patientName;

  const ConnectCounselScreen({Key? key, required this.patientName}) : super(key: key);

  @override
  _ConnectCounselScreenState createState() => _ConnectCounselScreenState();
}

class _ConnectCounselScreenState extends State<ConnectCounselScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<ConnectOptionData> _options = [
    ConnectOptionData(
      title: "Send Message",
      description: "Chat with your patient securely",
      icon: Icons.chat_bubble_outline_rounded,
      primaryColor: const Color(0xFF00B894), // Green for chat
      accentColor: const Color(0xFF55EFC4),
    ),
    ConnectOptionData(
      title: "Start Video Call",
      description: "Connect face-to-face instantly",
      icon: Icons.video_call_rounded,
      primaryColor: const Color(0xFF6C5CE7), // Purple for video call
      accentColor: const Color(0xFFA29BFE),
    ),
    // The 'Assign Task' tile was moved to the Dashboard.
    // If you need a quick "Assign Task" from *this* screen for the current patient,
    // we can add a specific button or list item here.
    // For now, I'll ensure the bottom bar's "Tasks" button correctly navigates.
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
              Expanded(child: _buildConnectOptionsList()),
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
                colors: [Color(0xFFE17055), Color(0xFFFAB1A0)], // Orange gradient for connect
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
              Icons.connect_without_contact_rounded, // Icon for connection
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Connect with ${widget.patientName} 👋", // Updated header text
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Choose how you want to interact", // Updated sub-text
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
              Icons.more_vert_rounded, // Example: more options
              color: Colors.white.withOpacity(0.8),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectOptionsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: ListView.builder(
        itemCount: _options.length,
        itemBuilder: (context, index) {
          final option = _options[index];
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
                    child: ConnectOptionCard(
                      option: option,
                      onTap: () => _handleOptionTap(context, index),
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
          _buildBottomBarItem(Icons.dashboard_rounded, "Dashboard", false, onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst || route.settings.name == '/psychologistDashboard');
          }),
          _buildBottomBarItem(Icons.arrow_back_rounded, "Back", true,
              onTap: () => Navigator.pop(context)),
          // Now, if 'Tasks' is needed for the current patient from here,
          // it explicitly navigates to AssignTaskScreen for the specific patient.
          _buildBottomBarItem(Icons.assignment_turned_in_rounded, "Assign Task", false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssignTaskScreen(patientName: widget.patientName),
                  ),
                );
              }),
          _buildBottomBarItem(Icons.analytics_rounded, "Reports", false,
              onTap: () => _showComingSoonDialog(context, "Patient Reports")),
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

  void _handleOptionTap(BuildContext context, int index) {
    switch (index) {
      case 0: // Send Message
        _showComingSoonDialog(context, "Chat Messaging");
        break;
      case 1: // Start Video Call
        _showComingSoonDialog(context, "Live Video Calls");
        break;
    // Assign Task option is now handled via the bottom bar
    }
  }

  void _showComingSoonDialog(BuildContext context, String featureName) {
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
                  "🚀 $featureName Coming Soon!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "We're working on integrating $featureName for you! Stay tuned! 🌟",
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

// --- NEW: ConnectOptionCard Widget for individual option items ---
class ConnectOptionCard extends StatefulWidget {
  final ConnectOptionData option;
  final VoidCallback onTap;

  const ConnectOptionCard({
    Key? key,
    required this.option,
    required this.onTap,
  }) : super(key: key);

  @override
  _ConnectOptionCardState createState() => _ConnectOptionCardState();
}

class _ConnectOptionCardState extends State<ConnectOptionCard>
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
                  // Option Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [widget.option.primaryColor, widget.option.accentColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.option.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon( // Cannot be const due to dynamic widget.option.icon
                      widget.option.icon,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Option Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text( // Cannot be const due to dynamic widget.option.title
                          widget.option.title,
                          style: const TextStyle( // TextStyle itself can be const
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text( // Cannot be const due to dynamic widget.option.description
                          widget.option.description,
                          style: TextStyle( // TextStyle itself can be const
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
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