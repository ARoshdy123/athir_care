import 'package:doctor/core/helpers/spacing.dart';
import 'package:doctor/core/theming/colors.dart';
import 'package:doctor/core/theming/styles.dart';
import 'package:doctor/features/explore/logic/explore_cubit.dart';
import 'package:doctor/features/explore/logic/explore_state.dart';
import 'package:doctor/features/explore/ui/widgets/explore_doctor_card.dart';
import 'package:doctor/features/explore/ui/widgets/explore_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.superLightGray,
      appBar: AppBar(
        backgroundColor: ColorsManager.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Recommendation Doctor',
          style: TextStyles.font18DarkBlueBold,
        ),
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.more_horiz,
          //     color: ColorsManager.darkBlue,
          //     size: 24.r,
          //   ),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            verticalSpace(8),
            const ExploreSearchBar(),
            verticalSpace(8),
            Expanded(
              child: BlocBuilder<ExploreCubit, ExploreState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const SizedBox.shrink(),
                    loading: () => _buildShimmerLoading(),
                    success: (allDoctorsResponseModel) {
                      final doctors =
                          allDoctorsResponseModel.doctorDataList ?? [];
                      if (doctors.isEmpty) {
                        return Center(
                          child: Text(
                            'No doctors found',
                            style: TextStyles.font14GrayRegular,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (context, index) {
                          return ExploreDoctorCard(doctorData: doctors[index]);
                        },
                      );
                    },
                    error:
                        (errorHandler) => Center(
                          child: Text(
                            errorHandler.apiErrorModel.message ??
                                'Something went wrong',
                            style: TextStyles.font14GrayRegular,
                          ),
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: ColorsManager.lighterGray,
      highlightColor: Colors.white,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              children: [
                Container(
                  width: 110.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                horizontalSpace(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      verticalSpace(8),
                      Container(
                        width: 100.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      verticalSpace(8),
                      Container(
                        width: 120.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
