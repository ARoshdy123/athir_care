import 'package:doctor/core/helpers/doctor_image_helper.dart';
import 'package:doctor/core/helpers/spacing.dart';
import 'package:doctor/core/theming/colors.dart';
import 'package:doctor/core/theming/styles.dart';
import 'package:doctor/features/my_appointments/data/models/appointments_list_response_model.dart';
import 'package:doctor/features/my_appointments/logic/cubit/my_appointments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  final AppointmentItem appointment;
  final VoidCallback onReschedule;

  const UpcomingAppointmentCard({
    super.key,
    required this.appointment,
    required this.onReschedule,
  });

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
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 12.r,
                          color: ColorsManager.gray,
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            appointment.appointmentTime ?? '',
                            style: TextStyles.font12GrayRegular,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Icon(
              //   Icons.chat_bubble_outline,
              //   color: ColorsManager.mainBlue,
              //   size: 20.r,
              // ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text('Cancel Appointment'),
                            content: const Text(
                              'Are you sure you want to cancel this appointment?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'No',
                                  style: TextStyles.font13BlueSemiBold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context
                                      .read<MyAppointmentsCubit>()
                                      .cancelAppointment(appointment);
                                },
                                child: Text(
                                  'Yes, Cancel',
                                  style: TextStyle(color: ColorsManager.red),
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: ColorsManager.mainBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    'Cancel Appointment',
                    style: TextStyles.font12BlueRegular,
                  ),
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onReschedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.mainBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    'Reschedule',
                    style: TextStyles.font12GrayRegular.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
