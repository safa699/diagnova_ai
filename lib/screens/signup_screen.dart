
import 'package:flutter/material.dart';
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
                hideConfirmPassword = !hideConfirmPassword;
              } else {
                hidePassword = !hidePassword;
              }
            });
          },
          icon: Icon(
            hide ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: signupTeal,
          ),
        )
            : null,
      ),
    );
  }

  void createAccount() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
      return;
    }

    if (!emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
        ),
      );
      return;
    }

    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
        ),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created successfully!'),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
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

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: createAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: signupTeal,
                              foregroundColor: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            child: const Text(
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
