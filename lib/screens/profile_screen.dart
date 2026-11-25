
import 'package:flutter/material.dart';

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
  TextEditingController(text: 'Your Name');

  final TextEditingController emailController =
  TextEditingController(text: 'your.email@example.com');

  final TextEditingController phoneController =
  TextEditingController(text: '+92 300 1234567');

  void editProfile() {
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
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
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
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(dialogContext);
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
        child: SingleChildScrollView(
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
                style: TextStyle(color: Colors.blueGrey),
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
                      nameController.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      emailController.text,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: editProfile,
                      icon: const Icon(Icons.edit, size: 17),
                      label: const Text('Edit Profile'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white70),
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
                nameController.text,
              ),
              infoTile(
                Icons.email_outlined,
                'Email Address',
                emailController.text,
              ),
              infoTile(
                Icons.phone_outlined,
                'Phone Number',
                phoneController.text,
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
                    () => showMessage('Notification settings coming soon'),
              ),
              settingTile(
                Icons.lock_outline_rounded,
                'Privacy & Security',
                'Manage account security',
                    () => showMessage('Privacy settings coming soon'),
              ),
              settingTile(
                Icons.help_outline_rounded,
                'Help & Support',
                'Get assistance',
                    () => showMessage('Help & Support coming soon'),
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

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => showMessage(
                    'Logout functionality will be connected later.',
                  ),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Log Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.all(15),
                    side: const BorderSide(color: Colors.red),
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

  Widget infoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: profileTeal, size: 23),
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
        leading: Icon(icon, color: profileTeal),
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
