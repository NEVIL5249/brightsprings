// my_appointments_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Define a simple Appointment class
class Appointment {
  final DateTime date;
  final TimeOfDay time;
  final String psychologist;

  Appointment({required this.date, required this.time, required this.psychologist});
}

class MyAppointmentsPage extends StatelessWidget {
  final List<Appointment> appointments;

  const MyAppointmentsPage({Key? key, required this.appointments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1421), // Consistent dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2332),
        title: const Text(
          "My Appointments 🗓️",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Set back button color
      ),
      body: appointments.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note_rounded,
              color: Colors.white.withOpacity(0.5),
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              "No appointments booked yet!",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Book your first session!",
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          final String formattedDate = DateFormat('dd MMM yyyy').format(appointment.date);
          final String formattedTime = appointment.time.format(context);

          return Card(
            color: const Color(0xFF1A2332), // Card background color
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Psychologist: ${appointment.psychologist}",
                        style: const TextStyle(
                          color: Color(0xFFA29BFE), // A subtle highlight color
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.psychology_rounded, color: Color(0xFFA29BFE), size: 24),
                    ],
                  ),
                  const Divider(height: 20, color: Colors.white12),
                  Text(
                    "Date: $formattedDate",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Time: $formattedTime",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00B894).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Confirmed",
                        style: TextStyle(
                          color: Color(0xFF00B894),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}