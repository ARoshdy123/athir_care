import 'package:doctor/core/helpers/doctor_image_helper.dart';
import 'package:doctor/features/explore/logic/explore_cubit.dart';
import 'package:doctor/features/home/data/models/specializations_response_model.dart';
import 'package:doctor/features/main_layout/logic/main_layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class DoctorsSpecialityListViewItem extends StatelessWidget {
  final SpecializationsData? specializationsData;
  final int itemIndex;

  const DoctorsSpecialityListViewItem({
    super.key,
    this.specializationsData,
    required this.itemIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: itemIndex == 0 ? 0 : 24.w),
      child: GestureDetector(
        onTap: () {
          final specId = specializationsData?.id;
          if (specId != null) {
            context.read<ExploreCubit>().filterDoctors(specId);
            context.read<MainLayoutCubit>().goToTab(1);
          }
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: ColorsManager.superLightGreen.withValues(
                alpha: 0.5,
              ),
              child: Image.asset(
                getSpecialtyImage(specializationsData?.id),
                height: 40.h,
                width: 40.w,
              ),
            ),
            verticalSpace(8),
            Text(
              specializationsData?.name ?? 'Specialization',
              style: TextStyles.font12DarkBlueRegular,
            ),
          ],
        ),
      ),
    );
  }
}
