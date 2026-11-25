
import 'package:flutter/material.dart';

const Color bookingTeal = Color(0xFF087E8B);
const Color bookingNavy = Color(0xFF142B4A);
const Color bookingBackground = Color(0xFFF6F9FC);

class AppointmentBookingScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const AppointmentBookingScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState
    extends State<AppointmentBookingScreen> {
  final TextEditingController patientController =
  TextEditingController();

  DateTime selectedDate = DateTime.now().add(
    const Duration(days: 1),
  );

  String selectedTime = '10:00 AM';
  String appointmentType = 'In-person';

  final List<String> timeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
  ];

  @override
  void dispose() {
    patientController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 90),
      ),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void confirmBooking() {
    if (patientController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter patient name'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentConfirmationScreen(
          doctorName: widget.doctor['name'] ?? 'Doctor',
          patientName: patientController.text.trim(),
          date: selectedDate,
          time: selectedTime,
          appointmentType: appointmentType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String doctorName =
        widget.doctor['name'] ?? 'Doctor';

    final String specialty =
        widget.doctor['specialty'] ?? 'Medical Specialist';

    final String imageUrl =
        widget.doctor['image'] ?? '';

    return Scaffold(
      backgroundColor: bookingBackground,
      appBar: AppBar(
        backgroundColor: bookingBackground,
        foregroundColor: bookingNavy,
        elevation: 0,
        title: const Text(
          'Book Appointment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      width: 85,
                      height: 85,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return doctorPlaceholder();
                      },
                    )
                        : doctorPlaceholder(),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctorName,
                          style: const TextStyle(
                            color: bookingNavy,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          specialty,
                          style: const TextStyle(
                            color: bookingTeal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Appointment booking',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
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
              'Patient Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: bookingNavy,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: patientController,
              decoration: InputDecoration(
                hintText: 'Enter patient full name',
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: bookingTeal,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Appointment Date',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: bookingNavy,
              ),
            ),

            const SizedBox(height: 12),

            InkWell(
              onTap: selectDate,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: bookingTeal,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: bookingNavy,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Available Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: bookingNavy,
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: timeSlots.map((time) {
                final bool isSelected =
                    selectedTime == time;

                return ChoiceChip(
                  label: Text(time),
                  selected: isSelected,
                  selectedColor: bookingTeal,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : bookingNavy,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      selectedTime = time;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            const Text(
              'Appointment Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: bookingNavy,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: appointmentTypeCard(
                    'In-person',
                    Icons.local_hospital_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: appointmentTypeCard(
                    'Online',
                    Icons.video_call_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: bookingTeal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Confirm Appointment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appointmentTypeCard(
      String type,
      IconData icon,
      ) {
    final bool selected = appointmentType == type;

    return InkWell(
      onTap: () {
        setState(() {
          appointmentType = type;
        });
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? bookingTeal.withValues(alpha: 0.10)
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected
                ? bookingTeal
                : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: bookingTeal,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              type,
              style: const TextStyle(
                color: bookingNavy,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget doctorPlaceholder() {
    return Container(
      width: 85,
      height: 85,
      color: const Color(0xFFE3F3F4),
      child: const Icon(
        Icons.person,
        size: 45,
        color: bookingTeal,
      ),
    );
  }
}

class AppointmentConfirmationScreen extends StatelessWidget {
  final String doctorName;
  final String patientName;
  final DateTime date;
  final String time;
  final String appointmentType;

  const AppointmentConfirmationScreen({
    super.key,
    required this.doctorName,
    required this.patientName,
    required this.date,
    required this.time,
    required this.appointmentType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bookingBackground,
      appBar: AppBar(
        backgroundColor: bookingBackground,
        foregroundColor: bookingNavy,
        title: const Text('Appointment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const SizedBox(height: 35),

            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFE1F5EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 65,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: bookingNavy,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Your appointment details are ready.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  detailRow('Doctor', doctorName),
                  detailRow('Patient', patientName),
                  detailRow(
                    'Date',
                    '${date.day}/${date.month}/${date.year}',
                  ),
                  detailRow('Time', time),
                  detailRow('Type', appointmentType),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                        (route) => route.isFirst,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: bookingTeal,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: bookingNavy,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
