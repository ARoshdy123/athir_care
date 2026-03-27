import 'package:doctor/core/helpers/spacing.dart';
import 'package:doctor/core/routing/routes.dart';
import 'package:doctor/core/theming/colors.dart';
import 'package:doctor/core/theming/styles.dart';
import 'package:doctor/features/my_appointments/logic/cubit/my_appointments_cubit.dart';
import 'package:doctor/features/my_appointments/logic/cubit/my_appointments_state.dart';
import 'package:doctor/features/my_appointments/ui/widgets/cancelled_appointment_card.dart';
import 'package:doctor/features/my_appointments/ui/widgets/completed_appointment_card.dart';
import 'package:doctor/features/my_appointments/ui/widgets/upcoming_appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<MyAppointmentsCubit>().getAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.superLightGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('My Appointment', style: TextStyles.font18DarkBlueBold),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.search, color: ColorsManager.darkBlue, size: 22.r),
          //   onPressed: () {},
          // ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.h),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: ColorsManager.mainBlue,
              indicatorWeight: 2.5,
              labelColor: ColorsManager.mainBlue,
              unselectedLabelColor: ColorsManager.gray,
              labelStyle: TextStyles.font14DarkBlueBold.copyWith(
                color: ColorsManager.mainBlue,
                fontSize: 13.sp,
              ),
              unselectedLabelStyle: TextStyles.font14DarkBlueBold.copyWith(
                color: ColorsManager.gray,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<MyAppointmentsCubit, MyAppointmentsState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => _buildShimmerLoading(),
            success: (data) {
              final cubit = context.read<MyAppointmentsCubit>();
              final allItems = data.appointments ?? [];
              final upcoming = cubit.getUpcoming(allItems);
              final completed = cubit.getCompleted(allItems);
              final cancelled = cubit.getCancelled(allItems);

              return TabBarView(
                controller: _tabController,
                children: [
                  // Upcoming Tab
                  _buildList(
                    isEmpty: upcoming.isEmpty,
                    emptyMessage: 'No upcoming appointments',
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      itemCount: upcoming.length,
                      itemBuilder: (context, index) {
                        return UpcomingAppointmentCard(
                          appointment: upcoming[index],
                          onReschedule: () {
                            Navigator.pushNamed(
                              context,
                              Routes.rescheduleAppointment,
                              arguments: upcoming[index],
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Completed Tab
                  _buildList(
                    isEmpty: completed.isEmpty,
                    emptyMessage: 'No completed appointments',
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      itemCount: completed.length,
                      itemBuilder: (context, index) {
                        return CompletedAppointmentCard(
                          appointment: completed[index],
                        );
                      },
                    ),
                  ),

                  // Cancelled Tab
                  _buildList(
                    isEmpty: cancelled.isEmpty,
                    emptyMessage: 'No cancelled appointments',
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      itemCount: cancelled.length,
                      itemBuilder: (context, index) {
                        return CancelledAppointmentCard(
                          appointment: cancelled[index],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            error:
                (message) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48.r,
                        color: ColorsManager.gray,
                      ),
                      verticalSpace(12),
                      Text(message, style: TextStyles.font14DarkBlueBold),
                      verticalSpace(16),
                      TextButton(
                        onPressed:
                            () =>
                                context
                                    .read<MyAppointmentsCubit>()
                                    .getAppointments(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: ColorsManager.lighterGray,
      highlightColor: Colors.white,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 64.w,
                      height: 64.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 140.w,
                            height: 14.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: 100.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: 120.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Container(
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildList({
    required bool isEmpty,
    required String emptyMessage,
    required Widget child,
  }) {
    if (isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 48.r,
              color: ColorsManager.gray,
            ),
            verticalSpace(12),
            Text(emptyMessage, style: TextStyles.font14DarkBlueBold),
          ],
        ),
      );
    }
    return child;
  }
}
