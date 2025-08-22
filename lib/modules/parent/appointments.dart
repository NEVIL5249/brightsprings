import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Required for date and time formatting
import 'my_appointments_page.dart'; // Import the new page

// Ensure this Appointment class is also available in appointments.dart
// Or, if you prefer, you can just define it once in my_appointments_page.dart
// and import it. For simplicity, let's keep it defined in my_appointments_page.dart
// and import it here.

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedPsychologist;

  // List to store booked appointments
  final List<Appointment> _bookedAppointments = [];

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

  // Helper function to pick date and time
  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)), // Allow selection for next 1 year
      builder: (context, child) {
        return Theme(
          // Apply a dark theme to the date picker itself for consistency
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: const Color(0xFF6C5CE7), // Your primary accent color
              onPrimary: Colors.white, // Text color on accent color
              surface: const Color(0xFF1A2332), // Background of date picker calendar
              onSurface: Colors.white, // Text color on calendar background
            ),
            dialogBackgroundColor: const Color(0xFF0D1421), // Overall dialog background
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime ?? TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            // Apply a dark theme to the time picker itself
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: const Color(0xFF6C5CE7), // Your primary accent color
                onPrimary: Colors.white,
                surface: const Color(0xFF1A2332), // Background of time picker clock
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: const Color(0xFF0D1421), // Overall dialog background
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
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
              Expanded(child: _buildAppointmentForm()), // Main form content
              _buildBottomBar(), // Consistent bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  // Reusable modern header (adapted from your other screens)
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
                colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)], // Purple gradient for appointments
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C5CE7).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon( // This can be const
              Icons.calendar_month_rounded, // Icon specific to appointments
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
                  "Book Your Appointment! 📅", // Updated header text
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text( // Cannot be const due to dynamic opacity
                  "Schedule a session with a specialist", // Updated sub-text
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
              Icons.notifications_none_rounded, // Example: notifications icon
              color: Colors.white.withOpacity(0.8),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // The main form content for appointment booking
  Widget _buildAppointmentForm() {
    String dateText = _selectedDate == null
        ? "Choose Date & Time"
        : "${DateFormat('dd MMM yyyy').format(_selectedDate!)} at ${_selectedTime!.format(context)}";

    return SingleChildScrollView( // Use SingleChildScrollView to prevent overflow on smaller screens
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text( // Can be const
            'Select Date & Time',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          _buildStyledButton(
            onPressed: () => _pickDateTime(context),
            icon: Icons.calendar_today_rounded,
            label: dateText,
            color: const Color(0xFF6C5CE7), // Primary button color for date/time
          ),
          const SizedBox(height: 40),
          const Text( // Can be const
            'Select Psychologist',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _selectedPsychologist,
            items: ['Dr. Ayesha', 'Dr. Khan', 'Dr. Patel']
                .map((name) => DropdownMenuItem(value: name, child: Text(name, style: const TextStyle(color: Colors.white)))) // Text in dropdown items needs style
                .toList(),
            onChanged: (val) {
              setState(() {
                _selectedPsychologist = val;
              });
            },
            dropdownColor: const Color(0xFF1A2332), // Background of the dropdown menu
            style: const TextStyle(color: Colors.white), // Text style for the selected item in the field
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.05), // Input field background
              hintText: 'Choose a psychologist',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: const Color(0xFF6C5CE7), width: 2), // Focused border
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.white.withOpacity(0.8)), // Dropdown icon
          ),
          const SizedBox(height: 40),
          _buildStyledButton(
            onPressed: () {
              // Submit appointment logic
              _confirmAppointment();
            },
            icon: Icons.check_circle_outline_rounded,
            label: 'Confirm Appointment',
            color: const Color(0xFF00B894), // Green for confirmation button
          ),
        ],
      ),
    );
  }

  // Reusable styled button with gradient and shadow
  Widget _buildStyledButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 24),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Make button background transparent to show gradient
          shadowColor: Colors.transparent, // Remove default shadow
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  // Dialog for confirming the appointment
  void _confirmAppointment() {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a date and time!", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_selectedPsychologist == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a psychologist!", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String dateTime = "${DateFormat('dd MMM yyyy').format(_selectedDate!)} at ${_selectedTime!.format(context)}";

    // Create a new Appointment object
    final newAppointment = Appointment(
      date: _selectedDate!,
      time: _selectedTime!,
      psychologist: _selectedPsychologist!,
    );

    // Add the new appointment to the list
    setState(() {
      _bookedAppointments.add(newAppointment);
    });

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
                    color: const Color(0xFF00B894).withOpacity(0.1), // Green for success
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon( // This can be const
                    Icons.check_circle_outline_rounded,
                    color: Color(0xFF00B894), // Green icon
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                const Text( // This can be const
                  "Appointment Confirmed! 🎉",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text( // Cannot be const due to dynamic content
                  "You have booked an appointment with $_selectedPsychologist on $dateTime.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                    // Navigate to the My Appointments page, passing the list of appointments
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyAppointmentsPage(appointments: _bookedAppointments),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7), // Consistent button color
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text( // This can be const
                    "View Appointments ✅",
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

  // Reusable bottom bar (adapted from your other screens)
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
          // Assuming Home and Back buttons are working as intended
          _buildBottomBarItem(Icons.home_rounded, "Home", false, onTap: () {
            // Implement navigation to your Home screen if you have one
            // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            // Or if this is the root, do nothing.
          }),
          _buildBottomBarItem(Icons.arrow_back_rounded, "Back", false, // 'true' for active was misleading
              onTap: () => Navigator.pop(context)),
          _buildBottomBarItem(Icons.calendar_today_rounded, "My Appointments", true, // Make this active visually for the current screen, or based on actual route
              onTap: () {
                // Navigate to My Appointments page when this item is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyAppointmentsPage(appointments: _bookedAppointments),
                  ),
                );
              }),
          _buildBottomBarItem(Icons.person_rounded, "Profile", false,
              onTap: () => _showComingSoonDialog(context, "Profile")),
        ],
      ),
    );
  }

  // Helper for bottom bar items
  Widget _buildBottomBarItem(IconData icon, String label, bool isActive,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap, // onTap is now directly used
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

  // Reusable coming soon dialog (adapted from your other screens)
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