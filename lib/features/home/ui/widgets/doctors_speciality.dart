import 'package:doctor/core/theming/styles.dart';
import 'package:flutter/material.dart';

class DoctorSpeciality extends StatelessWidget {
  const DoctorSpeciality({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Doctor Speciality', style: TextStyles.font18DarkBlueSemiBold),
      ],
    );
  }
}
