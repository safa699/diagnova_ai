
import 'package:flutter/material.dart';

const Color recordNavy = Color(0xFF102A43);
const Color recordTeal = Color(0xFF087E8B);
const Color recordBackground = Color(0xFFF6F9FC);

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() =>
      _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState
    extends State<MedicalRecordsScreen> {
  final Map<String, String> healthInfo = {
    'Blood Group': 'Not Added',
    'Allergies': 'Not Added',
    'Medications': 'Not Added',
    'Medical Conditions': 'Not Added',
  };

  final List<Map<String, String>> records = [
    {
      'title': 'Blood Test Report',
      'type': 'Laboratory Report',
      'date': '12 Nov 2026',
      'doctor': 'Not specified',
      'notes': 'Demo record',
    },
    {
      'title': 'General Checkup',
      'type': 'Doctor Visit',
      'date': '05 Oct 2026',
      'doctor': 'Not specified',
      'notes': 'Demo record',
    },
  ];

  // Edit personal health information
  Future<void> editHealthInfo(String title) async {
    final controller = TextEditingController(
      text: healthInfo[title] == 'Not Added'
          ? ''
          : healthInfo[title],
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter $title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
              onPressed: () {
                if (controller.text.trim().isEmpty) {
                  return;
                }

                setState(() {
                  healthInfo[title] = controller.text.trim();
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title updated successfully'),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  // Add new medical record
  Future<void> addRecord() async {
    final titleController = TextEditingController();
    final typeController = TextEditingController();
    final doctorController = TextEditingController();
    final notesController = TextEditingController();

    DateTime selectedDate = DateTime.now();

    String formattedDate =
        '${selectedDate.day} ${_monthName(selectedDate.month)} '
        '${selectedDate.year}';

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: const Text('Add Medical Record'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Record Title *',
                        hintText: 'e.g. Blood Test Report',
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: typeController,
                      decoration: const InputDecoration(
                        labelText: 'Record Type *',
                        hintText: 'e.g. Lab Report',
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: doctorController,
                      decoration: const InputDecoration(
                        labelText: 'Doctor Name (Optional)',
                      ),
                    ),

                    const SizedBox(height: 12),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.calendar_month,
                        color: recordTeal,
                      ),
                      title: const Text('Record Date'),
                      subtitle: Text(formattedDate),
                      trailing: const Icon(
                        Icons.edit_calendar,
                      ),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: dialogContext,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          dialogSetState(() {
                            selectedDate = pickedDate;

                            formattedDate =
                            '${selectedDate.day} '
                                '${_monthName(selectedDate.month)} '
                                '${selectedDate.year}';
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Notes (Optional)',
                        hintText: 'Enter additional details',
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: recordTeal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (titleController.text.trim().isEmpty ||
                        typeController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter title and record type',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      records.insert(0, {
                        'title': titleController.text.trim(),
                        'type': typeController.text.trim(),
                        'date': formattedDate,
                        'doctor': doctorController.text.trim().isEmpty
                            ? 'Not specified'
                            : doctorController.text.trim(),
                        'notes': notesController.text.trim().isEmpty
                            ? 'No notes'
                            : notesController.text.trim(),
                      });
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Medical record added'),
                      ),
                    );
                  },
                  child: const Text('Add Record'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    typeController.dispose();
    doctorController.dispose();
    notesController.dispose();
  }

  // Delete record
  void deleteRecord(int index) {
    setState(() {
      records.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medical record deleted'),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: recordBackground,
      appBar: AppBar(
        backgroundColor: recordBackground,
        foregroundColor: recordNavy,
        elevation: 0,
        title: const Text(
          'Medical Records',
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
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: recordNavy,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.folder_shared_rounded,
                    color: Colors.white,
                    size: 38,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Your Health Records',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Manage your health information and '
                        'medical history in one place.',
                    style: TextStyle(
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Health Information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Health Information',
                  style: TextStyle(
                    color: recordNavy,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text(
                  'Tap to edit',
                  style: TextStyle(
                    color: recordTeal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: healthInfoCard(
                    'Blood Group',
                    healthInfo['Blood Group']!,
                    Icons.bloodtype_rounded,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: healthInfoCard(
                    'Allergies',
                    healthInfo['Allergies']!,
                    Icons.warning_amber_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: healthInfoCard(
                    'Medications',
                    healthInfo['Medications']!,
                    Icons.medication_rounded,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: healthInfoCard(
                    'Medical Conditions',
                    healthInfo['Medical Conditions']!,
                    Icons.health_and_safety_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Recent Records
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Records',
                  style: TextStyle(
                    color: recordNavy,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  '${records.length} Records',
                  style: const TextStyle(
                    color: recordTeal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            if (records.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.folder_open_rounded,
                      size: 45,
                      color: recordTeal,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No medical records yet',
                      style: TextStyle(
                        color: recordNavy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Add your first medical record below.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

            ...records.asMap().entries.map((entry) {
              final index = entry.key;
              final record = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: recordTeal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.description_rounded,
                        color: recordTeal,
                        size: 27,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record['title']!,
                            style: const TextStyle(
                              color: recordNavy,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            record['type']!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            record['date']!,
                            style: const TextStyle(
                              color: recordTeal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          deleteRecord(index);
                        }

                        if (value == 'details') {
                          showRecordDetails(record);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'details',
                          child: Text('View Details'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete Record'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 15),

            // Add Record Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: addRecord,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Medical Record'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: recordTeal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Demo information is stored temporarily '
                  'and is not saved to an online account.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Health information card
  Widget healthInfoCard(
      String title,
      String value,
      IconData icon,
      ) {
    return GestureDetector(
      onTap: () {
        editHealthInfo(title);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: recordTeal,
              size: 27,
            ),

            const SizedBox(height: 12),

            Text(
              title,
              style: const TextStyle(
                color: recordNavy,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Edit',
              style: TextStyle(
                color: recordTeal,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // View record details
  void showRecordDetails(Map<String, String> record) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(record['title']!),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type: ${record['type']}'),
              const SizedBox(height: 8),
              Text('Date: ${record['date']}'),
              const SizedBox(height: 8),
              Text('Doctor: ${record['doctor']}'),
              const SizedBox(height: 8),
              Text('Notes: ${record['notes']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
