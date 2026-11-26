
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:diagnova_ai/screens/login_screen.dart';

const Color profileNavy = Color(0xFF102A43);
const Color profileTeal = Color(0xFF087E8B);
const Color profileBackground = Color(0xFFF6F9FC);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController phoneController =
  TextEditingController();

  bool isLoading = true;
  bool isSaving = false;
  bool isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // Load current user's profile from Firebase
  Future<void> loadProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        return;
      }

      final document = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = document.data();

      nameController.text =
          data?['name'] ?? user.displayName ?? '';

      emailController.text =
          data?['email'] ?? user.email ?? '';

      phoneController.text =
          data?['phone'] ?? '';
    } catch (e) {
      debugPrint('Profile loading error: $e');

      if (mounted) {
        showMessage('Unable to load profile information');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: profileNavy,
      ),
    );
  }

  // Edit profile dialog
  void editProfile() {
    final editNameController = TextEditingController(
      text: nameController.text,
    );

    final editEmailController = TextEditingController(
      text: emailController.text,
    );

    final editPhoneController = TextEditingController(
      text: phoneController.text,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: editNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: editEmailController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined),
                    helperText: 'Email cannot be changed here',
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: editPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                final newName =
                editNameController.text.trim();

                final newPhone =
                editPhoneController.text.trim();

                if (newName.isEmpty) {
                  showMessage('Please enter your name');
                  return;
                }

                Navigator.pop(dialogContext);

                await saveProfile(
                  newName: newName,
                  newPhone: newPhone,
                );
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    ).then((_) {
      editNameController.dispose();
      editEmailController.dispose();
      editPhoneController.dispose();
    });
  }

  // Save updated profile in Firestore
  Future<void> saveProfile({
    required String newName,
    required String newPhone,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showMessage('Please login again');
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'name': newName,
        'email': user.email ?? '',
        'phone': newPhone,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await user.updateDisplayName(newName);

      nameController.text = newName;
      phoneController.text = newPhone;

      if (mounted) {
        setState(() {});
        showMessage('Profile updated successfully!');
      }
    } catch (e) {
      debugPrint('Profile update error: $e');

      if (mounted) {
        showMessage('Unable to update profile');
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // Firebase Logout
  Future<void> logout() async {
    setState(() {
      isLoggingOut = true;
    });

    try {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
            (route) => false,
      );
    } catch (e) {
      debugPrint('Logout error: $e');

      if (mounted) {
        showMessage('Unable to logout. Please try again');
        setState(() {
          isLoggingOut = false;
        });
      }
    }
  }

  void confirmLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout from Diagnova AI?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: profileBackground,
      body: SafeArea(
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: profileTeal,
          ),
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: profileNavy,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Manage your personal information',
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
              ),

              const SizedBox(height: 25),

              // Profile Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: profileNavy,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 43,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person_rounded,
                        size: 48,
                        color: profileTeal,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      nameController.text.isEmpty
                          ? 'User'
                          : nameController.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      emailController.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 16),

                    OutlinedButton.icon(
                      onPressed:
                      isSaving ? null : editProfile,
                      icon: const Icon(
                        Icons.edit,
                        size: 17,
                      ),
                      label: isSaving
                          ? const Text('Saving...')
                          : const Text('Edit Profile'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: profileNavy,
                ),
              ),

              const SizedBox(height: 12),

              infoTile(
                Icons.person_outline,
                'Full Name',
                nameController.text.isEmpty
                    ? 'Not provided'
                    : nameController.text,
              ),

              infoTile(
                Icons.email_outlined,
                'Email Address',
                emailController.text.isEmpty
                    ? 'Not provided'
                    : emailController.text,
              ),

              infoTile(
                Icons.phone_outlined,
                'Phone Number',
                phoneController.text.isEmpty
                    ? 'Not provided'
                    : phoneController.text,
              ),

              const SizedBox(height: 22),

              const Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: profileNavy,
                ),
              ),

              const SizedBox(height: 12),

              settingTile(
                Icons.notifications_none_rounded,
                'Notifications',
                'Manage your notifications',
                    () => showMessage(
                  'Notification settings coming soon',
                ),
              ),

              settingTile(
                Icons.lock_outline_rounded,
                'Privacy & Security',
                'Manage account security',
                    () => showMessage(
                  'Privacy settings coming soon',
                ),
              ),

              settingTile(
                Icons.help_outline_rounded,
                'Help & Support',
                'Get assistance',
                    () => showMessage(
                  'Help & Support coming soon',
                ),
              ),

              settingTile(
                Icons.info_outline_rounded,
                'About Diagnova AI',
                'App information',
                    () => showAboutDialog(
                  context: context,
                  applicationName: 'Diagnova AI',
                  applicationVersion: '1.0.0',
                  applicationLegalese:
                  'Your smart healthcare companion.',
                ),
              ),

              const SizedBox(height: 20),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed:
                  isLoggingOut ? null : confirmLogout,
                  icon: isLoggingOut
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.red,
                    ),
                  )
                      : const Icon(Icons.logout_rounded),
                  label: Text(
                    isLoggingOut ? 'Logging out...' : 'Log Out',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.all(15),
                    side: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  'Diagnova AI  •  Version 1.0.0',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Personal information tile
  Widget infoTile(
      IconData icon,
      String title,
      String value,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: profileTeal,
            size: 23,
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    color: profileNavy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Account settings tile
  Widget settingTile(
      IconData icon,
      String title,
      String subtitle,
      VoidCallback onTap,
      ) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: profileTeal,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: profileNavy,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}
