import 'package:dbapp/screens/home_screen.dart';
import 'package:dbapp/screens/sign_up_screen.dart';
import 'package:dbapp/services/authentication.dart';
import 'package:dbapp/widgets/button.dart';
import 'package:dbapp/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  
  // Get SupabaseClient instance
  final _supabase = Supabase.instance.client;
  late final SupaAuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = SupaAuthService(_supabase);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Changed to non-async function that calls the async function
  void _signIn() {
    _handleSignIn();
  }

  // Actual async implementation
  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    
    // Input validation
    if (email.isEmpty || password.isEmpty) {
      showSnackBar(context, 'Please fill in all fields');
      return;
    }
    
    // Email format validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      showSnackBar(context, 'Please enter a valid email address');
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Use auth service to sign in
      final response = await _authService.signIn(
        context: context,
        email: email,
        password: password,
      );
      
      if (response != null && mounted) {
        // Navigate to home screen or dashboard on success
        _navToHomeScreen(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Changed to non-async function that calls the async function
  void _forgotPassword() {
    _handleForgotPassword();
  }

  // Actual async implementation
  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    
    if (email.isEmpty) {
      showSnackBar(context, 'Please enter your email address');
      return;
    }
    
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      showSnackBar(context, 'Please enter a valid email address');
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await _authService.resetPassword(context, email);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navToSignUpScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void _navToHomeScreen(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Taskio',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Email Field
            const Text(
              'EMAIL',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'example@email.com',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Password Field
            const Text(
              'PASSWORD',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: InputBorder.none,
                  suffixIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: const Text(
                      'SHOW',
                      style: TextStyle(
                        color: Color(0xFF8000FF),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Forgot Password Link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _isLoading ? null : _forgotPassword,
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Color(0xFF8000FF),
                    fontSize: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sign In Button
            ActionButton(
              label: _isLoading ? 'SIGNING IN...' : 'SIGN IN',
              onPressed: _isLoading ? () {} : _signIn,
            ),

            const SizedBox(height: 24),

            // OR divider
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[300])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey[300])),
              ],
            ),

            const SizedBox(height: 24),

            // Create Account Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New user?',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: _isLoading ? null : () => _navToSignUpScreen(context),
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.only(left: 8),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Create an account',
                    style: TextStyle(
                      color: Color(0xFF8000FF),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}