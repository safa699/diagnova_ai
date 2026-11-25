import 'package:flutter/material.dart';
import 'package:diagnova_ai/screens/home_screen.dart';
import 'package:diagnova_ai/screens/signup_screen.dart';

const Color authNavy = Color(0xFF102A43);
const Color authTeal = Color(0xFF087E8B);
const Color authBackground = Color(0xFFF6F9FC);

class LoginScreen extends StatefulWidget {
const LoginScreen({super.key});

@override
State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
final emailController = TextEditingController();
final passwordController = TextEditingController();

bool hidePassword = true;

@override
void dispose() {
emailController.dispose();
passwordController.dispose();
super.dispose();
}

void login() {
if (emailController.text.trim().isEmpty ||
passwordController.text.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Please enter email and password'),
),
);
return;
}

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
backgroundColor: authBackground,
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.all(25),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const SizedBox(height: 35),

Center(
child: Container(
height: 85,
width: 85,
decoration: BoxDecoration(
color: authTeal,
borderRadius: BorderRadius.circular(25),
),
child: const Icon(
Icons.health_and_safety_rounded,
color: Colors.white,
size: 50,
),
),
),

const SizedBox(height: 20),

const Center(
child: Text(
'DIAGNOVA AI',
style: TextStyle(
fontSize: 25,
fontWeight: FontWeight.bold,
color: authNavy,
letterSpacing: 1.5,
),
),
),

const SizedBox(height: 8),

const Center(
child: Text(
'Your Smart Health Companion',
style: TextStyle(color: Colors.grey),
),
),

const SizedBox(height: 40),

const Text(
'Welcome Back!',
style: TextStyle(
fontSize: 27,
fontWeight: FontWeight.bold,
color: authNavy,
),
),

const SizedBox(height: 8),

const Text(
'Login to continue your health journey.',
style: TextStyle(color: Colors.grey),
),

const SizedBox(height: 30),

const Text(
'Email Address',
style: TextStyle(
fontWeight: FontWeight.w600,
color: authNavy,
),
),

const SizedBox(height: 10),

TextField(
controller: emailController,
keyboardType: TextInputType.emailAddress,
decoration: InputDecoration(
hintText: 'Enter your email',
prefixIcon: const Icon(
Icons.email_outlined,
color: authTeal,
),
filled: true,
fillColor: Colors.white,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(15),
borderSide: BorderSide.none,
),
),
),

const SizedBox(height: 20),

const Text(
'Password',
style: TextStyle(
fontWeight: FontWeight.w600,
color: authNavy,
),
),

const SizedBox(height: 10),

TextField(
controller: passwordController,
obscureText: hidePassword,
decoration: InputDecoration(
hintText: 'Enter your password',
prefixIcon: const Icon(
Icons.lock_outline,
color: authTeal,
),
suffixIcon: IconButton(
onPressed: () {
setState(() {
hidePassword = !hidePassword;
});
},
icon: Icon(
hidePassword
? Icons.visibility_off
    : Icons.visibility,
color: authTeal,
),
),
filled: true,
fillColor: Colors.white,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(15),
borderSide: BorderSide.none,
),
),
),

const SizedBox(height: 30),

SizedBox(
width: double.infinity,
height: 55,
child: ElevatedButton(
onPressed: login,
style: ElevatedButton.styleFrom(
backgroundColor: authTeal,
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(15),
),
),
child: const Text(
'Login',
style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 16,
),
),
),
),

const SizedBox(height: 25),

Center(
child: Wrap(
alignment: WrapAlignment.center,
children: [
const Text(
"Don't have an account? ",
style: TextStyle(color: Colors.grey),
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
),
);
}
}
