
import 'package:flutter/material.dart';

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

  // Demo appointments.
  // Later, Firebase se real appointments load hongi.
  final List<Map<String, dynamic>> appointments = [
    {
      'doctor': 'Dr. Sarah Ahmed',
      'specialty': 'General Physician',
      'date': '28 November 2026',
      'time': '10:30 AM',
      'type': 'In-person',
      'status': 'Upcoming',
      'image':
      'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400',
    },
    {
      'doctor': 'Dr. Ali Hassan',
      'specialty': 'Cardiologist',
      'date': '30 November 2026',
      'time': '02:00 PM',
      'type': 'Online',
      'status': 'Upcoming',
      'image':
      'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400',
    },
  ];

  void cancelAppointment(int index) {
    setState(() {
      appointments[index]['status'] = 'Cancelled';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment cancelled'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredAppointments =
    appointments.where((appointment) {
      if (selectedTab == 'Upcoming') {
        return appointment['status'] == 'Upcoming';
      }

      if (selectedTab == 'Completed') {
        return appointment['status'] == 'Completed';
      }

      return appointment['status'] == 'Cancelled';
    }).toList();

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

            Expanded(
              child: filteredAppointments.isEmpty
                  ? const Center(
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
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredAppointments.length,
                itemBuilder: (context, index) {
                  final appointment =
                  filteredAppointments[index];

                  final originalIndex =
                  appointments.indexOf(appointment);

                  return _appointmentCard(
                    appointment,
                    originalIndex,
                  );
                },
              ),
            ),
          ],
        ),
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
      int index,
      ) {
    final status = appointment['status'].toString();

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
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  appointment['image'].toString(),
                  width: 65,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) {
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
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment['doctor'].toString(),
                      style: const TextStyle(
                        color: appointmentNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      appointment['specialty'].toString(),
                      style: const TextStyle(
                        color: appointmentTeal,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      status,
                      style: TextStyle(
                        color: status == 'Upcoming'
                            ? appointmentTeal
                            : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 25),

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
                  appointment['date'].toString(),
                  style: const TextStyle(
                    color: appointmentNavy,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: appointmentTeal,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                appointment['time'].toString(),
                style: const TextStyle(
                  color: appointmentNavy,
                ),
              ),
              const Spacer(),
              Text(
                appointment['type'].toString(),
                style: const TextStyle(
                  color: appointmentTeal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          if (status == 'Upcoming') ...[
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  cancelAppointment(index);
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
}
