import 'package:flutter/material.dart';
import 'auth/role_selector.dart';
import 'modules/parent/dashboard.dart';
import 'modules/child/dashboard.dart';
import 'modules/psychologist/dashboard.dart';

void main() {
  runApp(AutismSupportApp());
}

class AutismSupportApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autism Support App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RoleSelectorScreen(),
      routes: {
        '/parent': (context) => ParentDashboard(),
        '/child': (context) => ChildDashboard(),
        '/psychologist': (context) => PsychologistDashboard(),
      },
    );
  }
}
