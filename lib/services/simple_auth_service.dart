import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';
import '../models/user_role.dart';

class SimpleAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Simple registration without problematic methods
  static Future<AppUser?> registerUser({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    print('Starting registration for email: $email, role: ${role.name}');
    
    try {
      // Create user with email and password only
      print('Creating Firebase Auth user...');
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        final user = result.user!;
        print('Firebase Auth user created successfully: ${user.uid}');
        
        // Create app user object
        final appUser = AppUser(
          uid: user.uid,
          email: email,
          name: name,
          role: role,
          createdAt: DateTime.now(),
        );

        // Save to Firestore in a separate try-catch
        try {
          print('Saving user data to Firestore...');
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'email': email,
            'name': name,
            'role': role.name,
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          });
          print('User data saved to Firestore successfully');
        } catch (e) {
          print('Firestore error (non-critical): $e');
        }

        print('Registration completed successfully');
        return appUser;
      } else {
        print('Firebase Auth result.user is null');
        throw 'Failed to create user account';
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          message = 'An account already exists for this email.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'network-request-failed':
          message = 'Network error. Please check your internet connection.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;
        default:
          message = 'Registration failed: ${e.message ?? e.code}';
      }
      throw message;
    } catch (e) {
      print('General exception during registration: $e');
      throw 'Registration failed: ${e.toString()}';
    }
  }

  // Simple login
  static Future<AppUser?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        return await getCurrentAppUser();
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for this email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = 'Login failed: ${e.message}';
      }
      throw message;
    } catch (e) {
      throw 'Login failed. Please try again.';
    }
    return null;
  }

  // Get current app user
  static Future<AppUser?> getCurrentAppUser() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return AppUser(
          uid: data['uid'] ?? user.uid,
          email: data['email'] ?? user.email ?? '',
          name: data['name'] ?? '',
          role: UserRole.fromString(data['role'] ?? 'parent'),
          createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] ?? 0),
        );
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
    return null;
  }

  // Sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw 'Failed to send reset email: ${e.message}';
    }
  }
}
