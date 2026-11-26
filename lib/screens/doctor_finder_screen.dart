
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:diagnova_ai/screens/appointment_booking_screen.dart';

const Color doctorNavy = Color(0xFF102A43);
const Color doctorTeal = Color(0xFF087E8B);
const Color doctorBackground = Color(0xFFF6F9FC);

class DoctorFinderScreen extends StatefulWidget {
  const DoctorFinderScreen({super.key});

  @override
  State<DoctorFinderScreen> createState() =>
      _DoctorFinderScreenState();
}

class _DoctorFinderScreenState
    extends State<DoctorFinderScreen> {
  final TextEditingController searchController =
  TextEditingController();

  String selectedSpecialty = 'All';

  final List<String> specialties = [
    'All',
    'General Physician',
    'Cardiologist',
    'Dermatologist',
    'Neurologist',
  ];

  // Firestore se doctors load honge
  final Stream<QuerySnapshot<Map<String, dynamic>>>
  doctorsStream = FirebaseFirestore.instance
      .collection('doctors')
      .snapshots();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> filterDoctors(
      List<Map<String, dynamic>> doctors) {
    final search =
    searchController.text.toLowerCase().trim();

    return doctors.where((doctor) {
      final name =
      (doctor['name'] ?? '').toString().toLowerCase();

      final specialty =
      (doctor['specialty'] ?? '')
          .toString()
          .toLowerCase();

      final matchesSearch =
          name.contains(search) ||
              specialty.contains(search);

      final matchesSpecialty =
          selectedSpecialty == 'All' ||
              doctor['specialty'] == selectedSpecialty;

      return matchesSearch && matchesSpecialty;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: doctorBackground,

      appBar: AppBar(
        backgroundColor: doctorNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Find Doctors',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Header and search
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: doctorNavy,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Find the right doctor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Book your appointment with trusted specialists.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: searchController,

                    onChanged: (value) {
                      setState(() {});
                    },

                    style: const TextStyle(
                      color: doctorNavy,
                    ),

                    decoration: InputDecoration(
                      hintText:
                      'Search doctor or specialty',

                      prefixIcon: const Icon(
                        Icons.search,
                        color: doctorTeal,
                      ),

                      filled: true,
                      fillColor: Colors.white,

                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Specialty filters
            SizedBox(
              height: 42,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,

                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                itemCount: specialties.length,

                itemBuilder: (context, index) {
                  final specialty = specialties[index];

                  final isSelected =
                      selectedSpecialty == specialty;

                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 8,
                    ),

                    child: ChoiceChip(
                      label: Text(specialty),

                      selected: isSelected,

                      selectedColor: doctorTeal,
                      backgroundColor: Colors.white,

                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : doctorNavy,
                        fontWeight: FontWeight.w600,
                      ),

                      onSelected: (selected) {
                        setState(() {
                          selectedSpecialty = specialty;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Firestore doctors list
            Expanded(
              child: StreamBuilder<
                  QuerySnapshot<Map<String, dynamic>>>(
                stream: doctorsStream,

                builder: (context, snapshot) {
                  // Loading
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: doctorTeal,
                      ),
                    );
                  }

                  // Error
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),

                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 45,
                            ),

                            const SizedBox(height: 12),

                            const Text(
                              'Unable to load doctors.',
                              style: TextStyle(
                                color: doctorNavy,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Please check your internet connection '
                                  'and Firestore permissions.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 12),

                            ElevatedButton(
                              onPressed: () {
                                setState(() {});
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: doctorTeal,
                                foregroundColor: Colors.white,
                              ),

                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final documents =
                      snapshot.data?.docs ?? [];

                  // Firestore data ko maps mein convert karna
                  final doctors =
                  documents.map((document) {
                    final data = document.data();

                    return <String, dynamic>{
                      ...data,
                      'id': document.id,
                    };
                  }).toList();

                  final filteredDoctors =
                  filterDoctors(doctors);

                  // Database empty
                  if (doctors.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),

                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medical_services_outlined,
                              size: 60,
                              color: doctorTeal,
                            ),

                            SizedBox(height: 16),

                            Text(
                              'No doctors added yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: doctorNavy,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              'Add doctor documents in your '
                                  'Firestore doctors collection.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Search/filter empty
                  if (filteredDoctors.isEmpty) {
                    return const Center(
                      child: Text(
                        'No doctors found.',
                        style: TextStyle(
                          color: doctorNavy,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),

                    itemCount: filteredDoctors.length,

                    itemBuilder: (context, index) {
                      final doctor =
                      filteredDoctors[index];

                      return DoctorCard(
                        doctor: doctor,

                        onBook: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AppointmentBookingScreen(
                                    doctor: doctor,
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final VoidCallback onBook;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl =
    (doctor['image'] ?? '').toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: doctorNavy.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(15),

                child: imageUrl.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  width: 85,
                  height: 100,
                  fit: BoxFit.cover,

                  errorBuilder:
                      (context, error, stackTrace) {
                    return doctorPlaceholder();
                  },
                )
                    : doctorPlaceholder(),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      (doctor['name'] ?? 'Doctor')
                          .toString(),

                      style: const TextStyle(
                        color: doctorNavy,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      (doctor['specialty'] ?? '')
                          .toString(),

                      style: const TextStyle(
                        color: doctorTeal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      (doctor['experience'] ?? '')
                          .toString(),

                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 17,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          (doctor['rating'] ?? 'New')
                              .toString(),

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: doctorNavy,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [
              Text(
                'Rs. ${doctor['fee'] ?? '0'}',

                style: const TextStyle(
                  color: doctorNavy,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              ElevatedButton(
                onPressed: onBook,

                style: ElevatedButton.styleFrom(
                  backgroundColor: doctorTeal,
                  foregroundColor: Colors.white,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  'Book Appointment',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget doctorPlaceholder() {
    return Container(
      width: 85,
      height: 100,
      color: const Color(0xFFEAF3F5),

      child: const Icon(
        Icons.person,
        size: 45,
        color: doctorTeal,
      ),
    );
  }
}
