import 'package:flutter/material.dart';

class RoleSelectorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Your Role')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoleButton(role: 'Parent', route: '/parent'),
            RoleButton(role: 'Child', route: '/child'),
            RoleButton(role: 'Psychologist', route: '/psychologist'),
          ],
        ),
      ),
    );
  }
}

class RoleButton extends StatelessWidget {
  final String role;
  final String route;

  RoleButton({required this.role, required this.route});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Text('Continue as $role'),
      ),
    );
  }
}
