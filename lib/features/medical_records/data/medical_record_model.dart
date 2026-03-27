enum RecordCategory { labResults, radiology, approvals }

class MedicalRecord {
  final String doctorName;
  final String date;
  final String description;
  final String imagePath;
  final String pdfAssetPath;
  final RecordCategory category;

  const MedicalRecord({
    required this.doctorName,
    required this.date,
    required this.description,
    required this.imagePath,
    required this.pdfAssetPath,
    required this.category,
  });
}

const List<MedicalRecord> mockMedicalRecords = [
  // Lab Results
  MedicalRecord(
    doctorName: 'Dr. Mitchell Green',
    date: 'OCT 24, 2023 • 10:00 AM',
    description: 'General Medical Checkup',
    imagePath: 'assets/images/med1.png',
    pdfAssetPath: 'assets/pdf/lab_results.pdf',
    category: RecordCategory.labResults,
  ),
  MedicalRecord(
    doctorName: 'Dr. Sarah Jenkins',
    date: 'NOV 02, 2023 • 02:30 PM',
    description: 'Blood Panel Results',
    imagePath: 'assets/images/med2.png',
    pdfAssetPath: 'assets/pdf/lab_results2.pdf',
    category: RecordCategory.labResults,
  ),
  MedicalRecord(
    doctorName: 'Dr. James Wilson',
    date: 'DEC 15, 2023 • 09:00 AM',
    description: 'Complete Blood Count',
    imagePath: 'assets/images/med1.png',
    pdfAssetPath: 'assets/pdf/lab_results3.pdf',
    category: RecordCategory.labResults,
  ),
  MedicalRecord(
    doctorName: 'Dr. Emily Carter',
    date: 'JAN 08, 2024 • 11:30 AM',
    description: 'Thyroid Function Test',
    imagePath: 'assets/images/med2.png',
    pdfAssetPath: 'assets/pdf/lab_results4.pdf',
    category: RecordCategory.labResults,
  ),
  // Radiology
  MedicalRecord(
    doctorName: 'Dr. Robert Hayes',
    date: 'SEP 18, 2023 • 03:00 PM',
    description: 'Chest X-Ray Report',
    imagePath: 'assets/images/med1.png',
    pdfAssetPath: 'assets/pdf/xray.pdf',
    category: RecordCategory.radiology,
  ),
  MedicalRecord(
    doctorName: 'Dr. Linda Park',
    date: 'OCT 05, 2023 • 01:00 PM',
    description: 'MRI Scan Results',
    imagePath: 'assets/images/med2.png',
    pdfAssetPath: 'assets/pdf/radr.pdf',
    category: RecordCategory.radiology,
  ),
  // Approvals
  MedicalRecord(
    doctorName: 'Dr. Alan Foster',
    date: 'AUG 22, 2023 • 10:30 AM',
    description: 'Surgery Approval',
    imagePath: 'assets/images/med1.png',
    pdfAssetPath: 'assets/pdf/approval.pdf',
    category: RecordCategory.approvals,
  ),
  MedicalRecord(
    doctorName: 'Dr. Megan Cole',
    date: 'SEP 10, 2023 • 04:00 PM',
    description: 'Treatment Authorization',
    imagePath: 'assets/images/med2.png',
    pdfAssetPath: 'assets/pdf/approval2.pdf',
    category: RecordCategory.approvals,
  ),
  MedicalRecord(
    doctorName: 'Dr. Nathan Brooks',
    date: 'NOV 28, 2023 • 09:45 AM',
    description: 'Prescription Approval',
    imagePath: 'assets/images/med1.png',
    pdfAssetPath: 'assets/pdf/approval3.pdf',
    category: RecordCategory.approvals,
  ),
];
