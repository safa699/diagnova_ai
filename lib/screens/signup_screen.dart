
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:diagnova_ai/screens/login_screen.dart';
import 'package:diagnova_ai/screens/home_screen.dart';

const Color signupTeal = Color(0xFF087E8B);
const Color signupNavy = Color(0xFF102A43);
const Color signupBackground = Color(0xFFF6F9FC);

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Widget buildInput({
    required String hint,
    required TextEditingController controller,
    IconData? icon,
    bool isPassword = false,
    bool isConfirmPassword = false,
  }) {
    final bool hide = isConfirmPassword
        ? hideConfirmPassword
        : hidePassword;

    return TextField(
      controller: controller,
      obscureText: (isPassword || isConfirmPassword) && hide,
      keyboardType: hint == 'Email Address'
          ? TextInputType.emailAddress
          : hint == 'Phone Number'
          ? TextInputType.phone
          : TextInputType.text,
      style: const TextStyle(
        fontSize: 17,
        color: signupNavy,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF82939B),
          fontSize: 18,
        ),
        prefixIcon: icon != null
            ? Icon(icon, color: signupTeal, size: 21)
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 17,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: signupTeal,
            width: 1.5,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: signupNavy,
            width: 2,
          ),
        ),
        suffixIcon: (isPassword || isConfirmPassword)
            ? IconButton(
          onPressed: () {
            setState(() {
              if (isConfirmPassword) {
                hideConfirmPassword =
                !hideConfirmPassword;
              } else {
                hidePassword = !hidePassword;
              }
            });
          },
          icon: Icon(
            hide
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: signupTeal,
          ),
        )
            : null,
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: signupNavy,
      ),
    );
  }

  Future<void> createAccount() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Check empty fields
    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage('Please fill all fields');
      return;
    }

    // Check email
    if (!email.contains('@') || !email.contains('.')) {
      showMessage('Please enter a valid email address');
      return;
    }

    // Check password length
    if (password.length < 6) {
      showMessage('Password must be at least 6 characters');
      return;
    }

    // Check confirm password
    if (password != confirmPassword) {
      showMessage('Passwords do not match');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // 1. Create account in Firebase Authentication
      final UserCredential userCredential =
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user == null) {
        showMessage('Account could not be created');
        return;
      }

      // 2. Save user profile in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Update Firebase display name
      await user.updateDisplayName(name);

      if (!mounted) return;

      showMessage('Account created successfully!');

      // 4. Navigate to Home
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
        case 'email-already-in-use':
          message = 'This email is already registered';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email address';
          break;

        case 'weak-password':
          message = 'Please choose a stronger password';
          break;

        case 'network-request-failed':
          message = 'Check your internet connection';
          break;

        case 'operation-not-allowed':
          message = 'Email/Password login is not enabled in Firebase';
          break;

        default:
          message = e.message ?? 'Signup failed. Please try again';
      }

      if (mounted) {
        showMessage(message);
      }
    } catch (e) {
      if (mounted) {
        showMessage(
          'Something went wrong. Please try again.',
        );
      }

      debugPrint('Signup error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: signupBackground,
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
                vertical: 20,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  // App Logo
                  Container(
                    height: 85,
                    width: 85,
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
                      size: 53,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Diagnova AI',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: signupNavy,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Your Smart Healthcare Companion',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Signup Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(
                      24, 28, 24, 28,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: signupNavy.withOpacity(0.15),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: signupNavy,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Join Diagnova AI and take care of your health.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF71838D),
                          ),
                        ),

                        const SizedBox(height: 25),

                        buildInput(
                          hint: 'Full Name',
                          controller: nameController,
                          icon: Icons.person_outline,
                        ),

                        const SizedBox(height: 22),

                        buildInput(
                          hint: 'Email Address',
                          controller: emailController,
                          icon: Icons.email_outlined,
                        ),

                        const SizedBox(height: 22),

                        buildInput(
                          hint: 'Phone Number',
                          controller: phoneController,
                          icon: Icons.phone_outlined,
                        ),

                        const SizedBox(height: 22),

                        buildInput(
                          hint: 'Password',
                          controller: passwordController,
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),

                        const SizedBox(height: 22),

                        buildInput(
                          hint: 'Confirm Password',
                          controller: confirmPasswordController,
                          icon: Icons.lock_outline,
                          isConfirmPassword: true,
                        ),

                        const SizedBox(height: 32),

                        // Create Account Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed:
                            isLoading ? null : createAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: signupTeal,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                              signupTeal.withOpacity(0.6),
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
                              'Create Account',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: signupNavy,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const LoginScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: signupTeal,
                                    fontSize: 15,
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

                  const SizedBox(height: 25),

                  const Text(
                    'Your Health, Our Priority',
                    style: TextStyle(
                      color: signupNavy,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
