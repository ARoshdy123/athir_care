import 'package:doctor/core/helpers/spacing.dart';
import 'package:doctor/core/theming/colors.dart';
import 'package:doctor/core/theming/styles.dart';
import 'package:doctor/core/widgets/app_text_button.dart';
import 'package:doctor/features/offers/data/models/offer_item_model.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class OfferDetailsScreen extends StatefulWidget {
  final OfferItem offer;

  const OfferDetailsScreen({super.key, required this.offer});

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;

  Future<void> _openGoogleMaps() async {
    final uri = Uri.parse(widget.offer.googleMapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;

    return Scaffold(
      backgroundColor: ColorsManager.superLightGray,
      appBar: AppBar(
        backgroundColor: ColorsManager.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        title: Text('Offer Details', style: TextStyles.font18DarkBlueBold),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: ColorsManager.darkBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(8),

            // ── Hero Image Card ──
            _buildHeroCard(offer),
            verticalSpace(16),

            // ── Title + Status ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    offer.title,
                    style: TextStyles.font18DarkBlueBold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsManager.lightBlue,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    offer.status,
                    style: TextStyles.font12BlueRegular.copyWith(
                      color: ColorsManager.mainBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace(8),

            // ── Description ──
            Text(offer.description, style: TextStyles.font14GrayRegular),
            verticalSpace(12),

            // ── Provider & Cost ──
            _buildInfoRow(
              icon: Icons.person_outline,
              label: 'Service Provider: ${offer.provider}',
            ),
            verticalSpace(8),
            _buildInfoRow(
              icon: Icons.monetization_on_outlined,
              label: 'Cost: ${offer.cost.toStringAsFixed(2)} ${offer.currency}',
            ),
            verticalSpace(24),

            // ── Select Date (reusing same style as booking) ──
            Text('Select Date', style: TextStyles.font15DarkBlueMedium),
            verticalSpace(12),
            _buildDateTimeline(),
            verticalSpace(20),

            // ── Available Time (reusing same style as booking) ──
            Text('Available Time', style: TextStyles.font15DarkBlueMedium),
            verticalSpace(12),
            _buildTimeGrid(offer.availableTimes),
            verticalSpace(24),

            // ── Book Appointment Now ──
            AppTextButton(
              buttonText: 'Book Appointment Now',
              textStyle: TextStyles.font16WhiteSemiBold,
              onPressed: () {
                if (_selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a time slot')),
                  );
                  return;
                }
                // TODO: Integrate with booking API endpoint
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking confirmed!')),
                );
              },
            ),
            verticalSpace(24),

            // ── Additional Details ──
            Text('Additional Details', style: TextStyles.font18DarkBlueBold),
            verticalSpace(12),
            _buildDetailRow('Package Number', offer.packageNumber),
            _buildDetailRow('Examination Duration', offer.duration),
            _buildLocationRow(offer.location),
            verticalSpace(24),

            // ── About the Offer ──
            Text('About the Offer', style: TextStyles.font18DarkBlueBold),
            verticalSpace(12),
            Text(offer.aboutText, style: TextStyles.font14GrayRegular),
            verticalSpace(32),
          ],
        ),
      ),
    );
  }

  // ── Hero Image Card ──
  Widget _buildHeroCard(OfferItem offer) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: ColorsManager.superLightGray2,
        border: Border.all(color: ColorsManager.lighterGray, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Image.asset(
          offer.imagePath,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) => Center(
                child: Icon(
                  Icons.medical_services_outlined,
                  size: 60.r,
                  color: ColorsManager.mainBlue,
                ),
              ),
        ),
      ),
    );
  }

  // ── Info Row ──
  Widget _buildInfoRow({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 20.r, color: ColorsManager.gray),
        horizontalSpace(8),
        Expanded(child: Text(label, style: TextStyles.font14GrayRegular)),
      ],
    );
  }

  // ── EasyDateTimeline (same style as DateTimeStep in booking) ──
  Widget _buildDateTimeline() {
    return EasyDateTimeLine(
      initialDate: _selectedDate,
      onDateChange: (date) {
        setState(() => _selectedDate = date);
      },
      headerProps: const EasyHeaderProps(
        monthPickerType: MonthPickerType.dropDown,
        dateFormatter: DateFormatter.fullDateDMY(),
      ),
      dayProps: EasyDayProps(
        height: 76.h,
        width: 58.w,
        dayStructure: DayStructure.dayStrDayNum,
        activeDayStyle: DayStyle(
          decoration: BoxDecoration(
            color: ColorsManager.mainBlue,
            borderRadius: BorderRadius.circular(12.r),
          ),
          dayStrStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          dayNumStyle: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        inactiveDayStyle: DayStyle(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ColorsManager.lighterGray),
          ),
          dayStrStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: ColorsManager.gray,
          ),
          dayNumStyle: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: ColorsManager.darkBlue,
          ),
        ),
        todayStyle: DayStyle(
          decoration: BoxDecoration(
            color: ColorsManager.lightBlue,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ColorsManager.mainBlue),
          ),
          dayStrStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: ColorsManager.mainBlue,
          ),
          dayNumStyle: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: ColorsManager.mainBlue,
          ),
        ),
      ),
    );
  }

  // ── Time Grid (same style as DateTimeStep in booking) ──
  Widget _buildTimeGrid(List<String> times) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 2.6,
      ),
      itemCount: times.length,
      itemBuilder: (context, index) {
        final time = times[index];
        final isSelected = _selectedTime == time;

        return GestureDetector(
          onTap: () => setState(() => _selectedTime = time),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? ColorsManager.mainBlue : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color:
                    isSelected
                        ? ColorsManager.mainBlue
                        : ColorsManager.lighterGray,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              time,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : ColorsManager.darkBlue,
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Detail Row (table-like) ──
  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorsManager.lighterGray, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles.font14GrayRegular),
          Text(value, style: TextStyles.font14DarkBlueMedium),
        ],
      ),
    );
  }

  // ── Location Row (tappable → Google Maps) ──
  Widget _buildLocationRow(String location) {
    return GestureDetector(
      onTap: _openGoogleMaps,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: ColorsManager.lighterGray, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Location', style: TextStyles.font14GrayRegular),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(location, style: TextStyles.font14DarkBlueMedium),
                horizontalSpace(4),
                Icon(
                  Icons.location_on,
                  color: ColorsManager.mainBlue,
                  size: 18.r,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
