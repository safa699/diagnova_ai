import 'package:flutter/material.dart';

void main() {
  runApp(const DiagnovaApp());
}

class DiagnovaApp extends StatelessWidget {
  const DiagnovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diagnova AI',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F9FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087E8B),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    DashboardScreen(),
    SimpleScreen(title: 'Appointments', icon: Icons.calendar_month),
    SimpleScreen(title: 'Health Records', icon: Icons.folder_shared),
    SimpleScreen(title: 'My Profile', icon: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Appointments',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            label: 'Records',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DIAGNOVA AI',
                      style: TextStyle(
                        color: Color(0xFF087E8B),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Hello, Welcome!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF183247),
                      ),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFFDDF3F1),
                  child: Icon(Icons.person, color: Color(0xFF087E8B)),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF087E8B),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.health_and_safety,
                      color: Colors.white, size: 35),
                  const SizedBox(height: 15),
                  const Text(
                    'Your Health, Our Priority',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Get smart health information and manage your healthcare journey.',
                    style: TextStyle(color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(height: 18),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF087E8B),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SymptomScreen(),
                        ),
                      );
                    },
                    child: const Text('Check Symptoms'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            const Text(
              'Healthcare Services',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF183247),
              ),
            ),
            const SizedBox(height: 15),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.15,
              children: [
                serviceCard(
                  context,
                  'AI Symptom Checker',
                  Icons.monitor_heart_outlined,
                  const Color(0xFF087E8B),
                  const SymptomScreen(),
                ),
                serviceCard(
                  context,
                  'Health Assistant',
                  Icons.smart_toy_outlined,
                  Colors.deepPurple,
                  const SimpleScreen(
                    title: 'AI Health Assistant',
                    icon: Icons.smart_toy,
                  ),
                ),
                serviceCard(
                  context,
                  'Find Doctors',
                  Icons.medical_services_outlined,
                  Colors.blue,
                  const SimpleScreen(
                    title: 'Find Doctors in Pakistan',
                    icon: Icons.local_hospital,
                  ),
                ),
                serviceCard(
                  context,
                  'Medical Reports',
                  Icons.description_outlined,
                  Colors.orange,
                  const SimpleScreen(
                    title: 'Medical Reports',
                    icon: Icons.folder_shared,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
            const Text(
              'Health & Safety',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF183247),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Diagnova AI provides general health information and does not replace professional medical advice or emergency care.',
              style: TextStyle(color: Colors.black54, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceCard(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      Widget page,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8EEF2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 31),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Explore service',
              style: TextStyle(color: Colors.black45, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class SymptomScreen extends StatefulWidget {
  const SymptomScreen({super.key});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  final List<String> symptoms = [
    'Headache',
    'Fever',
    'Cough',
    'Fatigue',
    'Sore throat',
    'Nausea',
  ];

  final Set<String> selectedSymptoms = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Symptom Checker')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your symptoms',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Choose all symptoms you are experiencing.'),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: symptoms.map((symptom) {
                  return CheckboxListTile(
                    title: Text(symptom),
                    value: selectedSymptoms.contains(symptom),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedSymptoms.add(symptom);
                        } else {
                          selectedSymptoms.remove(symptom);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: selectedSymptoms.isEmpty
                    ? null
                    : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${selectedSymptoms.length} symptoms selected. AI integration will be added next.',
                      ),
                    ),
                  );
                },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const SimpleScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 65, color: const Color(0xFF087E8B)),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('This module will be developed next.'),
          ],
        ),
      ),
    );
  }
}
