import 'package:doctor/core/helpers/doctor_image_helper.dart';
import 'package:doctor/core/helpers/spacing.dart';
import 'package:doctor/core/theming/colors.dart';
import 'package:doctor/core/theming/styles.dart';
import 'package:doctor/features/my_appointments/data/models/appointments_list_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelledAppointmentCard extends StatelessWidget {
  final AppointmentItem appointment;

  const CancelledAppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final doctor = appointment.doctor;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Status row: label + three-dots ──
          Row(
            children: [
              Text(
                'Appointment cancelled',
                style: TextStyles.font12BlueRegular.copyWith(
                  color: ColorsManager.red,
                ),
              ),
              const Spacer(),
              // Icon(Icons.more_vert, size: 18.r, color: ColorsManager.gray),
            ],
          ),
          SizedBox(height: 4.h),
          // ── Date / time below label ──
          Text(
            appointment.appointmentTime ?? '',
            style: TextStyles.font12GrayRegular,
          ),
          Divider(height: 20.h, color: ColorsManager.lighterGray),
          // ── Doctor info ──
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  getDoctorImage(doctor?.id),
                  width: 64.w,
                  height: 64.h,
                  fit: BoxFit.cover,
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor?.name ?? '',
                      style: TextStyles.font14DarkBlueBold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      doctor?.specialization?.name ?? '',
                      style: TextStyles.font12GrayMedium,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14.r),
                        SizedBox(width: 4.w),
                        Text(
                          '4.8 (4,279 reviews)',
                          style: TextStyles.font12GrayRegular,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
