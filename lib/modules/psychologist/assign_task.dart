import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class AssignTaskScreen extends StatefulWidget {
  final String patientName;

  const AssignTaskScreen({Key? key, required this.patientName}) : super(key: key);

  @override
  _AssignTaskScreenState createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _tasks = [
    'Play Color Match Game',
    'Watch Emotion Video',
    'Practice Sound Naming',
    'Complete Daily Routine Checklist',
    'Mindfulness Breathing Exercise',
    'Journaling for Emotions'
  ];

  String? _selectedTask;
  DateTime? _selectedDueDate;
  final TextEditingController _notesController = TextEditingController();

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
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6C5CE7), // Your primary accent color
              onPrimary: Colors.white,
              surface: Color(0xFF1A2332), // Dialog background
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1A2332), // Dialog background
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  void _assignTask() {
    if (_selectedTask == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a task!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simulate task assignment
    print("Assigning task: $_selectedTask to ${widget.patientName}");
    print("Due Date: ${_selectedDueDate?.toIso8601String() ?? 'Not set'}");
    print("Notes: ${_notesController.text}");

    _showTaskAssignedDialog(context);
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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFDCB6E), Color(0xFFFFE66D)], // Yellow gradient for tasks
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFDCB6E).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon( // This can be const
              Icons.assignment_rounded, // Icon specific to tasks
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( // Cannot be const due to dynamic widget.patientName
                  "Assign Task to ${widget.patientName} ✍️", // Updated header text
                  style: const TextStyle( // TextStyle itself can be const
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text( // Cannot be const due to dynamic opacity
                  "Set activities for patient progress", // Updated sub-text
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
              Icons.history_rounded, // Example: task history icon
              color: Colors.white.withOpacity(0.8),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStyledDropdown(),
          const SizedBox(height: 20),
          _buildDatePickerField(),
          const SizedBox(height: 20),
          _buildNotesField(),
          const SizedBox(height: 40),
          _buildAssignButton(),
        ],
      ),
    );
  }

  Widget _buildStyledDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedTask,
        decoration: InputDecoration(
          labelText: "Select Task",
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
        items: _tasks.map((task) {
          return DropdownMenuItem(
            value: task,
            child: Text(
              task,
              style: const TextStyle(color: Colors.white), // Color for items in the dropdown
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedTask = newValue;
          });
        },
      ),
    );
  }

  Widget _buildDatePickerField() {
    return GestureDetector(
      onTap: () => _selectDueDate(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded, color: Colors.white.withOpacity(0.7)),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                _selectedDueDate == null
                    ? "Select Due Date (Optional)"
                    : DateFormat('MMM dd, yyyy').format(_selectedDueDate!),
                style: TextStyle(
                  color: Colors.white.withOpacity(_selectedDueDate == null ? 0.8 : 1.0),
                  fontSize: 16,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withOpacity(0.5), size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _notesController,
        maxLines: 4,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: "Notes (Optional)",
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: InputBorder.none, // Remove default border
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          alignLabelWithHint: true,
        ),
        cursorColor: const Color(0xFF6C5CE7), // Accent color for cursor
      ),
    );
  }

  Widget _buildAssignButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)], // Purple gradient for assign button
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
        onPressed: _assignTask,
        icon: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 24), // This can be const
        label: const Text( // This can be const
          "Assign Task",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Make button background transparent
          shadowColor: Colors.transparent, // No shadow from ElevatedButton itself
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
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
          _buildBottomBarItem(Icons.dashboard_rounded, "Dashboard", false),
          _buildBottomBarItem(Icons.arrow_back_rounded, "Back", true,
              onTap: () => Navigator.pop(context)),
          _buildBottomBarItem(Icons.people_alt_rounded, "Patients", false,
              onTap: () => _showComingSoonDialog(context, "Patient List")),
          _buildBottomBarItem(Icons.analytics_rounded, "Reports", false,
              onTap: () => _showComingSoonDialog(context, "Task Reports")),
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

  void _showTaskAssignedDialog(BuildContext context) {
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
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon( // This can be const
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                const Text( // This can be const
                  "Task Assigned Successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text( // Cannot be const due to dynamic widget.patientName
                  "The task '$_selectedTask' has been assigned to ${widget.patientName}.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss dialog
                    Navigator.of(context).pop(); // Go back to previous screen (e.g., dashboard)
                  },
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
                    "Great! 🎉",
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
                Text( // Cannot be const due to dynamic type string
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