
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:diagnova_ai/screens/home_screen.dart';
import 'package:diagnova_ai/screens/signup_screen.dart';

const Color authTeal = Color(0xFF087E8B);
const Color authNavy = Color(0xFF102A43);
const Color authBackground = Color(0xFFF6F9FC);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;
  bool isResetLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: authNavy,
      ),
    );
  }

  // Firebase Login
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showMessage('Please enter your email and password');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      showMessage('Login successful!');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'invalid-email':
          message = 'Please enter a valid email address';
          break;

        case 'user-not-found':
          message = 'No account found with this email';
          break;

        case 'wrong-password':
          message = 'Incorrect password';
          break;

        case 'invalid-credential':
          message = 'Incorrect email or password';
          break;

        case 'user-disabled':
          message = 'This account has been disabled';
          break;

        case 'too-many-requests':
          message = 'Too many attempts. Try again later';
          break;

        case 'network-request-failed':
          message = 'Please check your internet connection';
          break;

        default:
          message = e.message ?? 'Login failed. Please try again';
      }

      if (mounted) {
        showMessage(message);
      }
    } catch (e) {
      if (mounted) {
        showMessage('Something went wrong. Please try again');
      }

      debugPrint('Login error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Firebase Forgot Password
  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage('Please enter your email address first');
      return;
    }

    setState(() {
      isResetLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      if (mounted) {
        showMessage(
          'Password reset email sent. Please check your inbox.',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        if (e.code == 'invalid-email') {
          showMessage('Please enter a valid email address');
        } else {
          showMessage(
            'Unable to send reset email. Please try again.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showMessage('Something went wrong. Please try again');
      }

      debugPrint('Password reset error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isResetLoading = false;
        });
      }
    }
  }

  Widget buildInput({
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isPassword
          ? TextInputType.text
          : TextInputType.emailAddress,
      obscureText: isPassword && hidePassword,
      style: const TextStyle(
        fontSize: 18,
        color: authNavy,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF82939B),
          fontSize: 19,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 18,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: authTeal,
            width: 1.5,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: authNavy,
            width: 2,
          ),
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            hidePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: authTeal,
          ),
          onPressed: () {
            setState(() {
              hidePassword = !hidePassword;
            });
          },
        )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: authBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF087E8B),
              Color(0xFFB8DDE0),
              Color(0xFFF6F9FC),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 25,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 35),

                  // App Logo
                  Container(
                    height: 95,
                    width: 95,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.health_and_safety_rounded,
                      size: 58,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Diagnova AI',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: authNavy,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Your Smart Healthcare Companion',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 55),

                  // White Login Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(
                      24, 32, 24, 30,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(38),
                      boxShadow: [
                        BoxShadow(
                          color: authNavy.withOpacity(0.15),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: authNavy,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Login to continue your health journey.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF71838D),
                          ),
                        ),

                        const SizedBox(height: 38),

                        buildInput(
                          hint: 'Email Address',
                          controller: emailController,
                        ),

                        const SizedBox(height: 38),

                        buildInput(
                          hint: 'Password',
                          controller: passwordController,
                          isPassword: true,
                        ),

                        const SizedBox(height: 18),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed:
                            isResetLoading ? null : forgotPassword,
                            child: isResetLoading
                                ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: authTeal,
                              ),
                            )
                                : const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: authTeal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: authTeal,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                              authTeal.withOpacity(0.6),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(9),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                                : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 19,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 38),

                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: authNavy,
                                  fontSize: 16,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const SignupScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: authTeal,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  const Text(
                    'Your Health, Our Priority',
                    style: TextStyle(
                      color: authNavy,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
