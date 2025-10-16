import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart'; // For email validation

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // For form validation
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.dispose(); // Dispose form key if needed
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF6A5AE0), // Match theme
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      setState(() => _loading = true);

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        _showMessage('Login successful!');
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'wrong-password':
            message = 'Incorrect password. Please try again.';
            break;
          case 'invalid-email':
            message = 'The email address format is invalid.';
            break;
          case 'user-disabled':
            message = 'This account has been disabled.';
            break;
          case 'user-not-found':
            message = 'No account found for this email. Please register.';
            break;
          case 'too-many-requests':
            message = 'Too many failed login attempts. Try again later.';
            break;
          default:
            message = e.message ?? 'Login failed. Please check your credentials.';
        }
        _showMessage(message);
      } catch (e) {
        _showMessage('Unexpected error: $e');
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    }
  }

  Future<void> _loginAsGuest() async {
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInAnonymously();
      _showMessage('Logged in as guest!');
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String message = e.code == 'operation-not-allowed'
          ? 'Guest login is not enabled. Please use email login.'
          : 'Guest login failed: ${e.message ?? "Unknown error"}';
      _showMessage(message);
    } catch (e) {
      _showMessage('Unexpected error during guest login: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      body: Stack( // Use Stack for overlay loading indicator
        children: [
          Center(
            child: AnimatedOpacity( // Add fade-in animation
              opacity: _loading ? 0.5 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Warmly",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A5AE0),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Your menstrual health companion",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email.';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password.';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: _loading ? null : () => Navigator.pushNamed(context, '/forgot_password'),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Color(0xFF6A5AE0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 350,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A5AE0),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white),
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _loading ? null : () => Navigator.pushReplacementNamed(context, '/register'),
                        child: const Text(
                          "Create new account",
                          style: TextStyle(color: Color(0xFF6A5AE0)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _loading
                            ? null
                            : () async {
                                final confirm = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirm Guest Login'),
                                    content: const Text('Are you sure you want to continue as a guest?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pushReplacementNamed(context, '/homepage'),
                                        child: const Text('Continue'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) _loginAsGuest();
                              },
                        icon: const Icon(Icons.person_outline, color: Colors.grey),
                        label: const Text(
                          "Continue as Guest",
                          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_loading)
            const ModalBarrier( // Full-screen loading overlay
              color: Colors.black54,
              dismissible: false,
            ),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6A5AE0),
              ),
            ),
        ],
      ),
    );
  }

  // Reusable widget for text fields with limited width
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      width: 350,  // Limit the width to 350 pixels
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          errorStyle: const TextStyle(color: Colors.redAccent),
        ),
        validator: validator,
      ),
    );
  }
}