import 'package:doctor/core/helpers/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/doctors_speciality.dart';
import 'widgets/home_top_bar.dart';
import 'widgets/specializations_and_doctors_bloc_builder.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeTopBar(),
              const BannerCarousel(), // doctor banner
              verticalSpace(14.h),
              const DoctorSpeciality(),
              verticalSpace(18),
              const Expanded(child: SpecializationsAndDoctorsBlocBuilder()),
            ],
          ),
        ),
      ),
    );
  }
}
