import 'package:doctor/core/helpers/doctor_image_helper.dart';
import 'package:doctor/core/helpers/extensions.dart';
import 'package:doctor/core/helpers/spacing.dart';
import 'package:doctor/core/routing/routes.dart';
import 'package:doctor/core/theming/colors.dart';
import 'package:doctor/core/theming/styles.dart';
import 'package:doctor/core/widgets/app_text_button.dart';
import 'package:doctor/features/booking/logic/cubit/appointment_cubit.dart';
import 'package:doctor/features/booking/logic/cubit/appointment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryStep extends StatelessWidget {
  final VoidCallback onChangePayment;
  const SummaryStep({super.key, required this.onChangePayment});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppointmentCubit>();
    final doctor = cubit.doctorData;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpace(8),

          // ── Booking Information ──
          Text('Booking Information', style: TextStyles.font15DarkBlueMedium),
          verticalSpace(12),
          _infoRow(
            icon: Icons.calendar_today_outlined,
            iconColor: ColorsManager.mainBlue,
            title: 'Date & Time',
            value: '${cubit.formattedDate}\n${cubit.selectedTime ?? ''}',
          ),
          verticalSpace(10),
          _infoRow(
            icon: Icons.medical_services_outlined,
            iconColor: ColorsManager.mainBlue,
            title: 'Appointment Type',
            value: cubit.appointmentTypeLabel,
          ),
          verticalSpace(20),

          // ── Doctor Information ──
          Text('Doctor Information', style: TextStyles.font15DarkBlueMedium),
          verticalSpace(12),
          _buildDoctorCard(doctor),
          verticalSpace(20),

          // ── Payment Information ──
          Text('Payment Information', style: TextStyles.font15DarkBlueMedium),
          verticalSpace(12),
          _buildPaymentInfo(context, cubit),
          verticalSpace(20),

          // ── Payment Info (pricing) ──
          Text('Payment Info', style: TextStyles.font15DarkBlueMedium),
          verticalSpace(12),
          _buildPricingSection(cubit),
          verticalSpace(20),

          // ── Notes ──
          Text('Notes', style: TextStyles.font15DarkBlueMedium),
          verticalSpace(8),
          TextFormField(
            controller: cubit.notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add any notes for your appointment...',
              hintStyle: TextStyles.font13GrayRegular,
              filled: true,
              fillColor: ColorsManager.superLightGray,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: ColorsManager.lighterGray),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: ColorsManager.lighterGray),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: ColorsManager.mainBlue),
              ),
            ),
          ),
          verticalSpace(24),

          // ── Book Now Button ──
          BlocConsumer<AppointmentCubit, AppointmentState>(
            listener: (context, state) {
              state.when(
                initial: () {},
                loading: () {},
                success: (data) {
                  context.pushNamedAndRemoveUntil(
                    Routes.bookingConfirmed,
                    arguments: cubit,
                    predicate: (route) => false,
                  );
                },
                error: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error),
                      backgroundColor: ColorsManager.red,
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.when(
                initial: () => _buildBookNowButton(cubit),
                loading:
                    () => const Center(
                      child: CircularProgressIndicator(
                        color: ColorsManager.mainBlue,
                      ),
                    ),
                success: (_) => _buildBookNowButton(cubit),
                error: (_) => _buildBookNowButton(cubit),
              );
            },
          ),
          verticalSpace(16),
        ],
      ),
    );
  }

  Widget _buildBookNowButton(AppointmentCubit cubit) {
    return AppTextButton(
      buttonText: 'Book Now',
      textStyle: TextStyles.font16WhiteSemiBold,
      onPressed: () => cubit.bookAppointment(),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorsManager.superLightGray,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.r),
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyles.font12GrayMedium),
                SizedBox(height: 2.h),
                Text(value, style: TextStyles.font13DarkBlueMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(doctor) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ColorsManager.superLightGray,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              getDoctorImage(doctor?.id),
              width: 60.w,
              height: 60.h,
              fit: BoxFit.cover,
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor?.name ?? 'Doctor',
                  style: TextStyles.font14DarkBlueBold,
                ),
                SizedBox(height: 2.h),
                Text(
                  '${doctor?.degree ?? ''} | ${doctor?.specialization?.name ?? ''}',
                  style: TextStyles.font12GrayMedium,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16.r),
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
    );
  }

  Widget _buildPaymentInfo(BuildContext context, AppointmentCubit cubit) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorsManager.superLightGray,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: ColorsManager.mainBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.payment,
              color: ColorsManager.mainBlue,
              size: 20.r,
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: Text(
              cubit.paymentMethodLabel,
              style: TextStyles.font14DarkBlueMedium,
            ),
          ),
          GestureDetector(
            onTap: onChangePayment,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: ColorsManager.mainBlue),
              ),
              child: Text('Change', style: TextStyles.font12BlueRegular),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(AppointmentCubit cubit) {
    final price = cubit.doctorData?.appointPrice ?? 0;
    final tax = (price * 0.15).round(); // 15% tax
    final total = price + tax;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ColorsManager.superLightGray,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _priceRow('Subtotal', '$price'),
          SizedBox(height: 8.h),
          _priceRow('Tax', '$tax'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: const Divider(color: ColorsManager.lighterGray),
          ),
          _priceRow('Payment Total', '$total', isBold: true),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              isBold
                  ? TextStyles.font14DarkBlueBold
                  : TextStyles.font13GrayRegular,
        ),
        Row(
          children: [
            Image.asset('assets/images/symbol.png', width: 14.r, height: 14.r),
            horizontalSpace(4),
            Text(
              amount,
              style:
                  isBold
                      ? TextStyles.font14DarkBlueBold
                      : TextStyles.font14DarkBlueMedium,
            ),
          ],
        ),
      ],
    );
  }
}
