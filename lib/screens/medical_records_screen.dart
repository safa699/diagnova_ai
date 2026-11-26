import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const Color medicalNavy = Color(0xFF102A43);
const Color medicalTeal = Color(0xFF087E8B);
const Color medicalBackground = Color(0xFFF6F9FC);

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() =>
      _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState
    extends State<MedicalRecordsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  DocumentReference<Map<String, dynamic>> get userDocument =>
      _firestore.collection('users').doc(userId);

  CollectionReference<Map<String, dynamic>> get recordsCollection =>
      _firestore.collection('medical_records');

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please login to view medical records.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: medicalBackground,
      appBar: AppBar(
        backgroundColor: medicalNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Medical Records',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: medicalTeal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
        onPressed: _addRecord,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildHealthInformation(),
            const SizedBox(height: 24),
            _buildRecordsHeading(),
            const SizedBox(height: 12),
            _buildRecordsList(),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: medicalNavy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.folder_shared_outlined,
              color: medicalTeal,
              size: 30,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Health Records',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Keep your important health information in one place.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Health Information',
          style: TextStyle(
            color: medicalNavy,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: userDocument.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _errorCard(
                'Could not load health information.',
              );
            }

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: medicalTeal,
                ),
              );
            }

            final data = snapshot.data?.data() ?? {};
            final medicalInfo =
            Map<String, dynamic>.from(
              data['medicalInfo'] ?? {},
            );

            final items = [
              {
                'title': 'Blood Group',
                'icon': Icons.bloodtype_outlined,
                'value': medicalInfo['Blood Group'] ?? 'Not added',
              },
              {
                'title': 'Allergies',
                'icon': Icons.warning_amber_rounded,
                'value': medicalInfo['Allergies'] ?? 'Not added',
              },
              {
                'title': 'Medications',
                'icon': Icons.medication_outlined,
                'value': medicalInfo['Medications'] ?? 'Not added',
              },
              {
                'title': 'Medical Conditions',
                'icon': Icons.health_and_safety_outlined,
                'value':
                medicalInfo['Medical Conditions'] ?? 'Not added',
              },
            ];

            return Column(
              children: items.map((item) {
                return _healthInfoCard(
                  title: item['title'] as String,
                  icon: item['icon'] as IconData,
                  value: item['value'].toString(),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _healthInfoCard({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: medicalTeal.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: medicalTeal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: medicalNavy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit $title',
            icon: const Icon(
              Icons.edit_outlined,
              color: medicalTeal,
            ),
            onPressed: () => _editHealthInfo(title, value),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Medical Documents',
          style: TextStyle(
            color: medicalNavy,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Saved in Firebase',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordsList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: recordsCollection
          .where('patientId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorCard(
            'Could not load records. Please check your internet connection and Firestore rules.',
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(25),
            child: Center(
              child: CircularProgressIndicator(
                color: medicalTeal,
              ),
            ),
          );
        }

        final documents = snapshot.data?.docs ?? [];

        if (documents.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.folder_open_outlined,
                  size: 45,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 10),
                const Text(
                  'No medical records yet',
                  style: TextStyle(
                    color: medicalNavy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Tap Add Record to save your first record.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }

        final sortedDocuments = [...documents];

        sortedDocuments.sort((a, b) {
          final aDate = _getDate(a.data()['recordDate']);
          final bDate = _getDate(b.data()['recordDate']);
          return bDate.compareTo(aDate);
        });

        return Column(
          children: sortedDocuments.map((document) {
            final record = document.data();

            return _recordCard(
              recordId: document.id,
              record: record,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _recordCard({
    required String recordId,
    required Map<String, dynamic> record,
  }) {
    final title = record['title']?.toString() ?? 'Medical Record';
    final type = record['type']?.toString() ?? 'Other';
    final doctor = record['doctor']?.toString() ?? 'Not specified';
    final date = _formatDate(record['recordDate']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: medicalTeal.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _recordIcon(type),
              color: medicalTeal,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: medicalNavy,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$type • $date',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Doctor: $doctor',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: medicalNavy,
            ),
            onSelected: (value) {
              if (value == 'view') {
                _viewRecord(record);
              } else if (value == 'delete') {
                _deleteRecord(recordId);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'view',
                child: Text('View Details'),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete Record'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _editHealthInfo(
      String title,
      String currentValue,
      ) async {
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return EditHealthInfoDialog(
          title: title,
          currentValue:
          currentValue == 'Not added' ? '' : currentValue,
        );
      },
    );

    if (!mounted || result == null) return;

    try {
      await userDocument.set({
        'medicalInfo': {title: result},
      }, SetOptions(merge: true));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$title updated successfully'),
          backgroundColor: medicalTeal,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not save health information: $e'),
        ),
      );
    }
  }

  Future<void> _addRecord() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return const AddMedicalRecordDialog();
      },
    );

    if (!mounted || result == null) return;

    try {
      await recordsCollection.add({
        'patientId': userId,
        'title': result['title'],
        'type': result['type'],
        'doctor': result['doctor'],
        'notes': result['notes'],
        'recordDate': Timestamp.fromDate(
          result['recordDate'] as DateTime,
        ),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medical record saved successfully'),
          backgroundColor: medicalTeal,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not add record: $e')),
      );
    }
  }

  Future<void> _deleteRecord(String recordId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Medical Record'),
          content: const Text(
            'Are you sure you want to delete this record?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    try {
      await recordsCollection.doc(recordId).delete();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medical record deleted'),
          backgroundColor: medicalTeal,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete record: $e')),
      );
    }
  }

  void _viewRecord(Map<String, dynamic> record) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            record['title']?.toString() ?? 'Medical Record',
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _detailRow(
                  'Type',
                  record['type']?.toString() ?? 'Other',
                ),
                _detailRow(
                  'Date',
                  _formatDate(record['recordDate']),
                ),
                _detailRow(
                  'Doctor',
                  record['doctor']?.toString() ??
                      'Not specified',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Notes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: medicalNavy,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  record['notes']?.toString().trim().isNotEmpty ==
                      true
                      ? record['notes'].toString()
                      : 'No notes added.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: medicalTeal),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 75,
            child: Text(
              '$title:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: medicalNavy,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _errorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  IconData _recordIcon(String type) {
    switch (type.toLowerCase()) {
      case 'lab report':
      case 'test report':
        return Icons.biotech_outlined;
      case 'prescription':
        return Icons.medication_outlined;
      case 'scan':
      case 'x-ray':
        return Icons.image_outlined;
      case 'discharge summary':
        return Icons.description_outlined;
      default:
        return Icons.folder_outlined;
    }
  }

  DateTime _getDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime(2000);
  }

  String _formatDate(dynamic value) {
    final date = _getDate(value);
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

// ------------------------------------------------------------
// Separate dialog widget for editing health information.
// The TextEditingController is disposed by this widget's State.
// ------------------------------------------------------------

class EditHealthInfoDialog extends StatefulWidget {
  final String title;
  final String currentValue;

  const EditHealthInfoDialog({
    super.key,
    required this.title,
    required this.currentValue,
  });

  @override
  State<EditHealthInfoDialog> createState() =>
      _EditHealthInfoDialogState();
}

class _EditHealthInfoDialogState
    extends State<EditHealthInfoDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.currentValue,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.title}'),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Enter ${widget.title.toLowerCase()}',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: medicalTeal,
              width: 2,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: medicalTeal,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop(
              _controller.text.trim(),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------
// Separate dialog widget for adding a medical record.
// ------------------------------------------------------------

class AddMedicalRecordDialog extends StatefulWidget {
  const AddMedicalRecordDialog({super.key});

  @override
  State<AddMedicalRecordDialog> createState() =>
      _AddMedicalRecordDialogState();
}

class _AddMedicalRecordDialogState
    extends State<AddMedicalRecordDialog> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _doctorController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedType = 'Lab Report';
  DateTime _selectedDate = DateTime.now();

  final List<String> _recordTypes = [
    'Lab Report',
    'Prescription',
    'Scan',
    'X-Ray',
    'Discharge Summary',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _doctorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (!mounted || selected == null) return;

    setState(() {
      _selectedDate = selected;
    });
  }

  void _saveRecord() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop({
      'title': _titleController.text.trim(),
      'type': _selectedType,
      'doctor': _doctorController.text.trim(),
      'notes': _notesController.text.trim(),
      'recordDate': _selectedDate,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add Medical Record',
        style: TextStyle(
          color: medicalNavy,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: _inputDecoration('Record Title'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: _inputDecoration('Record Type'),
                  items: _recordTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _doctorController,
                  decoration: _inputDecoration('Doctor Name'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: _inputDecoration('Notes'),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade400,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: medicalTeal,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Date: ${_selectedDate.day.toString().padLeft(2, '0')}/'
                              '${_selectedDate.month.toString().padLeft(2, '0')}/'
                              '${_selectedDate.year}',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: medicalTeal,
            foregroundColor: Colors.white,
          ),
          onPressed: _saveRecord,
          child: const Text('Save Record'),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: medicalTeal,
          width: 2,
        ),
      ),
    );
  }
}
