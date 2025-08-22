import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/role_selector.dart';
import 'modules/parent/dashboard.dart';
import 'modules/child/dashboard.dart';
import 'modules/psychologist/dashboard.dart';
import 'services/simple_auth_service.dart';
import 'models/app_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp(AutismSupportApp());
}

class AutismSupportApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrightSprings - Autism Support',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: AuthWrapper(),
      routes: {
        '/parent': (context) => ParentDashboard(),
        '/child': (context) => ChildDashboard(),
        '/psychologist': (context) => PsychologistDashboard(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: SimpleAuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          // User is logged in, check their role and navigate accordingly
          return FutureBuilder<AppUser?>(
            future: SimpleAuthService.getCurrentAppUser(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (userSnapshot.hasData) {
                final user = userSnapshot.data!;
                // Navigate to appropriate dashboard based on role
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(context, user.role.route);
                });
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                // User data not found, sign out and show role selector
                SimpleAuthService.signOut();
                return RoleSelectorScreen();
              }
            },
          );
        }

        // User is not logged in, show role selector
        return RoleSelectorScreen();
      },
    );
  }
}
