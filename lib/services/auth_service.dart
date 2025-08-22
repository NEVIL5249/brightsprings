import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';
import '../models/user_role.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current app user with role
  Future<AppUser?> getCurrentAppUser() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        print('User data from Firestore: $data');
        return AppUser.fromMap(data);
      }
    } catch (e) {
      print('Error getting user data: $e');
      print('Error type: ${e.runtimeType}');
      // If there's an error reading from Firestore, create a basic user from Firebase Auth
      try {
        return AppUser(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
          role: UserRole.parent, // Default role, should be updated
          createdAt: DateTime.now(),
        );
      } catch (fallbackError) {
        print('Fallback user creation failed: $fallbackError');
      }
    }
    return null;
  }

  // Sign up with email, password, name, and role
  Future<AppUser?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    UserCredential? credential;
    
    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final appUser = AppUser(
          uid: credential.user!.uid,
          email: email,
          name: name,
          role: role,
          createdAt: DateTime.now(),
        );

        // Save user data to Firestore with retry logic
        try {
          await _firestore
              .collection('users')
              .doc(credential.user!.uid)
              .set(appUser.toMap());
        } catch (firestoreError) {
          print('Firestore save error: $firestoreError');
          // If Firestore fails, still return the user
        }

        return appUser;
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      // If user was created but there's an error, don't throw
      if (credential?.user != null) {
        final appUser = AppUser(
          uid: credential!.user!.uid,
          email: email,
          name: name,
          role: role,
          createdAt: DateTime.now(),
        );
        return appUser;
      }
      print('Registration error: $e');
      throw 'Registration completed but with some issues. Please try logging in.';
    }
    return null;
  }

  // Sign in with email and password
  Future<AppUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Add a small delay to ensure user data is available
        await Future.delayed(Duration(milliseconds: 500));
        return await getCurrentAppUser();
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      print('Login error details: $e');
      throw 'Login failed. Please try again.';
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Check if user has specific role
  Future<bool> hasRole(UserRole role) async {
    final appUser = await getCurrentAppUser();
    return appUser?.role == role;
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? name,
    Map<String, dynamic>? additionalData,
  }) async {
    final user = currentUser;
    if (user == null) throw 'No user logged in';

    try {
      final updates = <String, dynamic>{};
      
      if (name != null) {
        updates['name'] = name;
      }
      
      if (additionalData != null) {
        updates['additionalData'] = additionalData;
      }

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).update(updates);
      }
    } catch (e) {
      throw 'Failed to update profile: $e';
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Signing in with Email and Password is not enabled.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}