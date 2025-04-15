import 'package:dbapp/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A service class to handle authentication operations with Supabase.
class SupaAuthService {
  final SupabaseClient _client;

  /// Creates a new [SupaAuthService] instance.
  SupaAuthService(this._client);

  /// Signs up a new user with email and password.
  ///
  /// Returns the [AuthResponse] if successful, null otherwise.
  Future<AuthResponse?> signUp({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.session == null) {
        // Email verification is required
        showSnackBar(context, 'Check your email to verify your account!');
      } else {
        // Auto-sign in (email verification may be disabled in Supabase settings)
        showSnackBar(context, 'Sign up successful!');
      }

      return response;
    } on AuthException catch (e) {
      // Handle specific auth errors with more useful messages
      String errorMessage = e.message;
      if (e.message.contains('already registered')) {
        errorMessage = 'This email is already registered';
      }
      showSnackBar(context, 'Sign up failed: $errorMessage');
      return null;
    } catch (e) {
      // Handle any other errors
      showSnackBar(context, 'An unexpected error occurred: $e');
      return null;
    }
  }

  /// Signs in an existing user with email and password.
  ///
  /// Returns the [AuthResponse] if successful, null otherwise.
  Future<AuthResponse?> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      showSnackBar(context, 'Sign in successful!');
      return response;
    } on AuthException catch (e) {
      // Handle specific auth errors
      String errorMessage = e.message;
      if (e.message.contains('Invalid login credentials')) {
        errorMessage = 'Invalid email or password';
      } else if (e.message.contains('Email not confirmed')) {
        errorMessage = 'Please verify your email first';
      }
      showSnackBar(context, 'Sign in failed: $errorMessage');
      return null;
    } catch (e) {
      showSnackBar(context, 'Sign in failed: $e');
      return null;
    }
  }

  /// Signs out the current user.
  Future<bool> signOut(BuildContext context) async {
    try {
      await _client.auth.signOut();
      showSnackBar(context, 'Signed out successfully!');
      return true;
    } catch (e) {
      showSnackBar(context, 'Sign out failed: $e');
      return false;
    }
  }

  /// Updates the email address for the current user.
  ///
  /// Returns true if successful, false otherwise.
  Future<bool> updateEmail(BuildContext context, String newEmail) async {
    try {
      await _client.auth.updateUser(UserAttributes(email: newEmail));
      showSnackBar(context, 'Email change initiated. Verify your new email.');
      return true;
    } on AuthException catch (e) {
      showSnackBar(context, 'Email update failed: ${e.message}');
      return false;
    } catch (e) {
      showSnackBar(context, 'Email update failed: $e');
      return false;
    }
  }

  /// Updates the password for the current user.
  ///
  /// Returns true if successful, false otherwise.
  Future<bool> updatePassword(BuildContext context, String newPassword) async {
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
      showSnackBar(context, 'Password updated successfully!');
      return true;
    } on AuthException catch (e) {
      showSnackBar(context, 'Password update failed: ${e.message}');
      return false;
    } catch (e) {
      showSnackBar(context, 'Password update failed: $e');
      return false;
    }
  }

  /// Sends a password reset email to the specified email address.
  ///
  /// Returns true if the email was sent successfully, false otherwise.
  Future<bool> resetPassword(BuildContext context, String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      showSnackBar(context, 'Password reset email sent!');
      return true;
    } on AuthException catch (e) {
      showSnackBar(context, 'Password reset failed: ${e.message}');
      return false;
    } catch (e) {
      showSnackBar(context, 'Password reset failed: $e');
      return false;
    }
  }

  /// Resends the verification email for account confirmation.
  ///
  /// Returns true if the email was sent successfully, false otherwise.
  Future<bool> resendVerificationEmail({
    required BuildContext context,
    required String email,
  }) async {
    try {
      await _client.auth.resend(
        type: OtpType.signup,
        email: email,
      );
      showSnackBar(context, 'Verification email sent!');
      return true;
    } on AuthException catch (e) {
      showSnackBar(context, 'Failed to resend verification: ${e.message}');
      return false;
    } catch (e) {
      showSnackBar(context, 'Failed to resend verification: $e');
      return false;
    }
  }

  /// Gets the current authenticated user.
  User? get currentUser => _client.auth.currentUser;

  /// Checks if a user is currently signed in.
  bool get isSignedIn => currentUser != null;

  /// Stream of auth state changes (sign in, sign out, etc.)
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}