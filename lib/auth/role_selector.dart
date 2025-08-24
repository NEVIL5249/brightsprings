import 'package:flutter/material.dart';
import '../models/user_role.dart';
import 'login.dart';

class RoleSelectorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autism Support App'),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Image.asset(
                    'assets/images/brightsprings.png',
                    width: 150, // adjust size
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Welcome to BrightSprings',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Supporting autism care with love and technology',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 48),
                  Text(
                    'Select Your Role',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 32),
                  RoleButton(
                    role: UserRole.parent,
                    icon: Icons.family_restroom,
                    description: 'Track progress and connect with professionals',
                  ),
                  SizedBox(height: 16),
                  RoleButton(
                    role: UserRole.child,
                    icon: Icons.child_care,
                    description: 'Interactive activities and learning games',
                  ),
                  SizedBox(height: 16),
                  RoleButton(
                    role: UserRole.psychologist,
                    icon: Icons.psychology,
                    description: 'Monitor patients and provide guidance',
                  ),
                  SizedBox(height: 40),
                ],
              ),
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

  RoleButton({
    required this.role,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(role: role),
              ),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: Colors.black,
                ),
                SizedBox(height: 12),
                Text(
                  'Continue as ${role.displayName}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
