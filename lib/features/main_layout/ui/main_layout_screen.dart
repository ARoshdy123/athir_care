import 'package:doctor/core/di/dependency_injection.dart';
import 'package:doctor/core/theming/colors.dart';
import 'package:doctor/features/explore/logic/explore_cubit.dart';
import 'package:doctor/features/explore/ui/explore_screen.dart';
import 'package:doctor/features/home/logic/home_cubit.dart';
import 'package:doctor/features/home/ui/home_screen.dart';
import 'package:doctor/features/main_layout/logic/main_layout_cubit.dart';
import 'package:doctor/features/my_appointments/logic/cubit/my_appointments_cubit.dart';
import 'package:doctor/features/my_appointments/ui/my_appointments_screen.dart';
import 'package:doctor/features/profile/logic/cubit/logout_cubit.dart';
import 'package:doctor/features/profile/logic/cubit/profile_cubit.dart';
import 'package:doctor/features/profile/ui/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainLayoutScreen extends StatefulWidget {
  final int initialTabIndex;
  const MainLayoutScreen({super.key, this.initialTabIndex = 0});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  late MainLayoutCubit _mainLayoutCubit;

  @override
  void initState() {
    super.initState();
    _mainLayoutCubit = MainLayoutCubit()..goToTab(widget.initialTabIndex);
  }

  @override
  void dispose() {
    _mainLayoutCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      const ExploreScreen(),
      const MyAppointmentsScreen(),
      ProfileScreen(
        onBack: () => _mainLayoutCubit.goToTab(0),
        onNavigateToAppointments: () => _mainLayoutCubit.goToTab(2),
      ),
    ];
    // MultiBlocProvider is OUTSIDE BlocBuilder so cubits are created
    // once when the layout mounts, not re-created on every tab switch.
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainLayoutCubit>.value(value: _mainLayoutCubit),
        BlocProvider<HomeCubit>(
          create: (_) => getIt<HomeCubit>()..getSpecializations(),
        ),
        BlocProvider<ExploreCubit>(
          create: (_) => getIt<ExploreCubit>()..getAllDoctors(),
        ),
        BlocProvider<ProfileCubit>(create: (_) => getIt<ProfileCubit>()),
        BlocProvider<LogoutCubit>(create: (_) => getIt<LogoutCubit>()),
        BlocProvider<MyAppointmentsCubit>(
          create: (_) => getIt<MyAppointmentsCubit>(),
        ),
      ],
      child: BlocBuilder<MainLayoutCubit, int>(
        bloc: _mainLayoutCubit,
        builder: (context, currentIndex) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (didPop) return;
              if (currentIndex != 0) {
                _mainLayoutCubit.goToTab(0);
              } else {
                SystemNavigator.pop();
              }
            },
            child: Scaffold(
              body: IndexedStack(index: currentIndex, children: pages),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black.withValues(alpha: 0.05),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: GNav(
                      rippleColor: ColorsManager.lightBlue,
                      hoverColor: ColorsManager.lightBlue,
                      gap: 8,
                      activeColor: ColorsManager.mainBlue,
                      iconSize: 24.r,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      duration: const Duration(milliseconds: 400),
                      tabBackgroundColor: ColorsManager.lightBlue,
                      color: ColorsManager.gray,
                      selectedIndex: currentIndex,
                      onTabChange: (index) => _mainLayoutCubit.goToTab(index),
                      tabs: const [
                        GButton(icon: Icons.home_outlined, text: 'Home'),
                        GButton(icon: Icons.search, text: 'Explore'),
                        GButton(
                          icon: Icons.calendar_today_outlined,
                          text: 'Appointment',
                        ),
                        GButton(icon: Icons.person_outline, text: 'Profile'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
