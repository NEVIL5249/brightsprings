import 'package:flutter/material.dart';
import '../models/user_role.dart';
import 'login.dart';

class RoleSelectorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1421),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Top section: Logo + Text
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // gradient: const LinearGradient(
                        //   // colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        //   begin: Alignment.topLeft,
                        //   end: Alignment.bottomRight,
                        // ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            spreadRadius: 3,
                          )
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/brightsprings.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // App Name + Tagline
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "BrightSprings",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Supporting autism care with love & technology",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // Section Title
                Text(
                  'Select Your Role',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // Role Cards (stacked vertically)
                RoleButton(
                  role: UserRole.parent,
                  icon: Icons.family_restroom,
                  description: 'Track progress & connect with professionals',
  gradient: [Color(0xFFEC407A), Color(0xFFD81B60)], // Vibrant pinks (logo match)
                ),
                const SizedBox(height: 16),

                RoleButton(
                  role: UserRole.child,
                  icon: Icons.child_care,
                  description: 'Fun interactive activities & learning games',
  gradient: [Color(0xFFFF7043), Color(0xFFE64A19)], // Playful orange-red (logo match)
                ),
                const SizedBox(height: 16),

                RoleButton(
                  role: UserRole.psychologist,
                  icon: Icons.psychology,
                  description: 'Monitor patients & provide guidance',
  gradient: [Color(0xFFFFB300), Color(0xFFF57C00)], // Rich amber-orange (slight orange tone so white text pops)
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoleButton extends StatelessWidget {
  final UserRole role;
  final IconData icon;
  final String description;
  final List<Color> gradient;

  const RoleButton({
    required this.role,
    required this.icon,
    required this.description,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(role: role),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 14),
            Text(
              'Continue as ${role.displayName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.85),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
