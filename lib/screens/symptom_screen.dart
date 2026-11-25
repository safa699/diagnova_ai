
import 'package:flutter/material.dart';
import 'package:diagnova_ai/screens/assessment_result_screen.dart';

const Color symptomNavy = Color(0xFF102A43);
const Color symptomTeal = Color(0xFF087E8B);
const Color symptomBackground = Color(0xFFF6F9FC);

class SymptomScreen extends StatefulWidget {
  const SymptomScreen({super.key});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  final TextEditingController ageController = TextEditingController();

  String? selectedGender;
  String selectedDuration = '1–2 days';
  String selectedSeverity = 'Moderate';

  final Set<String> selectedSymptoms = {};

  final List<Map<String, dynamic>> symptoms = [
    {
      'name': 'Fever',
      'icon': Icons.thermostat_rounded,
    },
    {
      'name': 'Headache',
      'icon': Icons.psychology_rounded,
    },
    {
      'name': 'Cough',
      'icon': Icons.sick_rounded,
    },
    {
      'name': 'Fatigue',
      'icon': Icons.battery_1_bar_rounded,
    },
    {
      'name': 'Sore Throat',
      'icon': Icons.record_voice_over_rounded,
    },
    {
      'name': 'Nausea',
      'icon': Icons.sick_outlined,
    },
    {
      'name': 'Body Pain',
      'icon': Icons.accessibility_new_rounded,
    },
    {
      'name': 'Dizziness',
      'icon': Icons.rotate_right_rounded,
    },
  ];

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }

  void continueToReview() {
    final int? age = int.tryParse(ageController.text.trim());

    if (age == null || age < 1 || age > 120) {
      showMessage('Please enter a valid age.');
      return;
    }

    if (selectedGender == null) {
      showMessage('Please select your gender.');
      return;
    }

    if (selectedSymptoms.isEmpty) {
      showMessage('Please select at least one symptom.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SymptomReviewScreen(
          age: age,
          gender: selectedGender!,
          symptoms: selectedSymptoms.toList(),
          duration: selectedDuration,
          severity: selectedSeverity,
        ),
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: symptomBackground,
      appBar: AppBar(
        backgroundColor: symptomBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: symptomNavy,
          ),
        ),
        title: const Text(
          'Symptom Checker',
          style: TextStyle(
            color: symptomNavy,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Let’s understand how you feel',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: symptomNavy,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Enter your details and select your symptoms.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 25),

              // Age
              const Text(
                'Your Age',
                style: TextStyle(
                  color: symptomNavy,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter your age',
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: symptomTeal,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Gender
              const Text(
                'Gender',
                style: TextStyle(
                  color: symptomNavy,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: genderButton('Male'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: genderButton('Female'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: genderButton('Other'),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Symptoms
              const Text(
                'Select Your Symptoms',
                style: TextStyle(
                  color: symptomNavy,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Choose all symptoms you are experiencing.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 15),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: symptoms.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.45,
                ),
                itemBuilder: (context, index) {
                  final symptom = symptoms[index];
                  final String name = symptom['name'];
                  final IconData icon = symptom['icon'];

                  final bool isSelected =
                  selectedSymptoms.contains(name);

                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedSymptoms.remove(name);
                        } else {
                          selectedSymptoms.add(name);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? symptomTeal.withValues(alpha: 0.10)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? symptomTeal
                              : Colors.grey.withValues(alpha: 0.15),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            color: symptomTeal,
                            size: 27,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: symptomNavy,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: symptomTeal,
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              // Duration
              const Text(
                'How long have you had these symptoms?',
                style: TextStyle(
                  color: symptomNavy,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: selectedDuration,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Less than 24 hours',
                    child: Text('Less than 24 hours'),
                  ),
                  DropdownMenuItem(
                    value: '1–2 days',
                    child: Text('1–2 days'),
                  ),
                  DropdownMenuItem(
                    value: '3–7 days',
                    child: Text('3–7 days'),
                  ),
                  DropdownMenuItem(
                    value: 'More than a week',
                    child: Text('More than a week'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedDuration = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 25),

              // Severity
              const Text(
                'Symptom Severity',
                style: TextStyle(
                  color: symptomNavy,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  severityButton('Mild'),
                  const SizedBox(width: 10),
                  severityButton('Moderate'),
                  const SizedBox(width: 10),
                  severityButton('Severe'),
                ],
              ),

              const SizedBox(height: 30),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: continueToReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: symptomTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 17,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Review Symptoms',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'For educational purposes only. This app does not '
                    'replace professional medical advice.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget genderButton(String gender) {
    final bool isSelected = selectedGender == gender;

    return InkWell(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: isSelected
              ? symptomTeal.withValues(alpha: 0.10)
              : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: isSelected ? symptomTeal : Colors.transparent,
          ),
        ),
        child: Text(
          gender,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? symptomTeal : symptomNavy,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget severityButton(String severity) {
    final bool isSelected = selectedSeverity == severity;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedSeverity = severity;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: isSelected
                ? symptomTeal.withValues(alpha: 0.10)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? symptomTeal : Colors.transparent,
            ),
          ),
          child: Text(
            severity,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? symptomTeal : symptomNavy,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- SYMPTOM REVIEW SCREEN ----------------

class SymptomReviewScreen extends StatelessWidget {
  final int age;
  final String gender;
  final List<String> symptoms;
  final String duration;
  final String severity;

  const SymptomReviewScreen({
    super.key,
    required this.age,
    required this.gender,
    required this.symptoms,
    required this.duration,
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: symptomBackground,
      appBar: AppBar(
        backgroundColor: symptomBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: symptomNavy,
          ),
        ),
        title: const Text(
          'Review Information',
          style: TextStyle(
            color: symptomNavy,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Confirm Your Details',
                style: TextStyle(
                  color: symptomNavy,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Please review the information before continuing.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 25),

              reviewCard(
                title: 'Personal Information',
                icon: Icons.person_rounded,
                children: [
                  reviewRow('Age', '$age years'),
                  reviewRow('Gender', gender),
                ],
              ),

              const SizedBox(height: 18),

              reviewCard(
                title: 'Selected Symptoms',
                icon: Icons.medical_services_rounded,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: symptoms.map((symptom) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: symptomTeal.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          symptom,
                          style: const TextStyle(
                            color: symptomTeal,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              reviewCard(
                title: 'Symptom Details',
                icon: Icons.access_time_rounded,
                children: [
                  reviewRow('Duration', duration),
                  reviewRow('Severity', severity),
                ],
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.deepOrange,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'The assessment result is for educational '
                            'purposes and is not a medical diagnosis.',
                        style: TextStyle(
                          color: symptomNavy,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AssessmentResultScreen(
                              condition: 'Assessment Pending',
                              confidence: 0.0,
                              symptoms: symptoms,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: symptomTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 17,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Start Assessment',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: symptomTeal,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    side: const BorderSide(
                      color: symptomTeal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('Edit Symptoms'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget reviewCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: symptomTeal),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: symptomNavy,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...children,
        ],
      ),
    );
  }

  Widget reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: symptomNavy,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
