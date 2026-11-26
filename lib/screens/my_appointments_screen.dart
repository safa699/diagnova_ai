
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color appointmentNavy = Color(0xFF102A43);
const Color appointmentTeal = Color(0xFF087E8B);
const Color appointmentBackground = Color(0xFFF6F9FC);

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() =>
      _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState
    extends State<MyAppointmentsScreen> {
  String selectedTab = 'Upcoming';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // Upcoming tab includes both Pending and Upcoming.
  bool _isUpcoming(String status) {
    return status == 'Pending' || status == 'Upcoming';
  }

  String _formatDate(dynamic value) {
    DateTime? date;

    if (value is Timestamp) {
      date = value.toDate();
    } else if (value is DateTime) {
      date = value;
    }

    if (date == null) {
      return 'Date not available';
    }

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _cancelAppointment(
      String appointmentId,
      ) async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cancel Appointment?'),
          content: const Text(
            'Are you sure you want to cancel this appointment?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Yes, Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (shouldCancel != true) return;

    try {
      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({
        'status': 'Cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment cancelled successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not cancel appointment: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: appointmentBackground,
        appBar: AppBar(
          backgroundColor: appointmentNavy,
          foregroundColor: Colors.white,
          title: const Text('My Appointments'),
        ),
        body: const Center(
          child: Text(
            'Please login to view your appointments.',
            style: TextStyle(
              color: appointmentNavy,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: appointmentBackground,
      appBar: AppBar(
        backgroundColor: appointmentNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Appointments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: appointmentNavy,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Health, Your Schedule',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Manage your doctor appointments easily.',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                children: [
                  _buildTab('Upcoming'),
                  const SizedBox(width: 8),
                  _buildTab('Completed'),
                  const SizedBox(width: 8),
                  _buildTab('Cancelled'),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Firebase appointments
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('appointments')
                    .where('patientId', isEqualTo: user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: appointmentTeal,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Unable to load appointments.\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  }

                  final documents =
                      snapshot.data?.docs ?? [];

                  final filteredDocuments =
                  documents.where((document) {
                    final data =
                    document.data() as Map<String, dynamic>;

                    final status =
                    (data['status'] ?? '').toString();

                    if (selectedTab == 'Upcoming') {
                      return _isUpcoming(status);
                    }

                    if (selectedTab == 'Completed') {
                      return status == 'Completed';
                    }

                    return status == 'Cancelled';
                  }).toList();

                  if (filteredDocuments.isEmpty) {
                    return _emptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredDocuments.length,
                    itemBuilder: (context, index) {
                      final document =
                      filteredDocuments[index];

                      final appointment =
                      document.data()
                      as Map<String, dynamic>;

                      return _appointmentCard(
                        appointment,
                        document.id,
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

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_month,
            size: 65,
            color: appointmentTeal,
          ),
          SizedBox(height: 12),
          Text(
            'No appointments found',
            style: TextStyle(
              color: appointmentNavy,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Your appointments will appear here.',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String tab) {
    final isSelected = selectedTab == tab;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = tab;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? appointmentTeal
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: appointmentTeal,
            ),
          ),
          child: Text(
            tab,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : appointmentNavy,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _appointmentCard(
      Map<String, dynamic> appointment,
      String appointmentId,
      ) {
    final status =
    (appointment['status'] ?? 'Pending').toString();

    final doctor =
    (appointment['doctorName'] ?? 'Doctor').toString();

    final specialty =
    (appointment['specialty'] ?? 'Specialist')
        .toString();

    final date = _formatDate(
      appointment['appointmentDate'],
    );

    final time =
    (appointment['appointmentTime'] ?? 'Not specified')
        .toString();

    final type =
    (appointment['appointmentType'] ?? 'In-person')
        .toString();

    final image =
    (appointment['image'] ?? '').toString();

    final isCancelled = status == 'Cancelled';
    final isCompleted = status == 'Completed';

    final statusColor = isCancelled
        ? Colors.red
        : isCompleted
        ? Colors.grey
        : appointmentTeal;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: appointmentNavy.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Doctor information
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: image.isNotEmpty
                    ? Image.network(
                  image,
                  width: 65,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) {
                    return _doctorPlaceholder();
                  },
                )
                    : _doctorPlaceholder(),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor,
                      style: const TextStyle(
                        color: appointmentNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      specialty,
                      style: const TextStyle(
                        color: appointmentTeal,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 25),

          // Date
          Row(
            children: [
              const Icon(
                Icons.calendar_month,
                color: appointmentTeal,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  date,
                  style: const TextStyle(
                    color: appointmentNavy,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Time and appointment type
          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: appointmentTeal,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(
                  color: appointmentNavy,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  type,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: appointmentTeal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          // Cancel button
          if (_isUpcoming(status)) ...[
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  _cancelAppointment(appointmentId);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(
                    color: Colors.red,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel Appointment',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _doctorPlaceholder() {
    return Container(
      width: 65,
      height: 70,
      color: const Color(0xFFEAF3F5),
      child: const Icon(
        Icons.person,
        color: appointmentTeal,
        size: 35,
      ),
    );
  }
}
