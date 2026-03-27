import 'package:doctor/core/helpers/spacing.dart';
import 'package:doctor/core/theming/styles.dart';
import 'package:doctor/features/home/data/models/banner_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A single banner card displayed inside the carousel.
/// Stateless for maximum performance — no internal state, no rebuilds.
class BannerCard extends StatelessWidget {
  final BannerItem banner;

  const BannerCard({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 195.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: double.infinity,
            height: 165.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              image: DecorationImage(
                image: AssetImage(banner.backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(banner.title, style: TextStyles.font18WhiteMedium),
                verticalSpace(14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => banner.onTap(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48.0),
                      ),
                    ),
                    child: Text(
                      banner.buttonText,
                      style: TextStyles.font12BlueRegular,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 9.w,
            top: 0,
            child: Image.asset(banner.imagePath, height: 200.h),
          ),
        ],
      ),
    );
  }
}
