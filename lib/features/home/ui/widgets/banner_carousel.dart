import 'dart:async';

import 'package:doctor/core/helpers/spacing.dart';
import 'package:doctor/core/routing/routes.dart';
import 'package:doctor/core/theming/colors.dart';
import 'package:doctor/features/home/data/models/banner_item_model.dart';
import 'package:doctor/features/home/ui/widgets/banner_card.dart';
import 'package:doctor/features/main_layout/logic/main_layout_cubit.dart';
import 'package:doctor/features/offers/data/models/offer_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A horizontally-scrollable banner carousel with indicator dots and auto-advance.
/// Uses [WidgetsBindingObserver] to pause/resume the timer when the app
/// goes to the background, preventing buffer-overflow crashes.
class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel>
    with WidgetsBindingObserver {
  late final PageController _pageController;
  Timer? _autoAdvanceTimer;
  int _currentPage = 0;

  // ── Mock offer data (ready for API integration) ──
  static const _mockOffers = [
    OfferItem(
      title: 'Complete Health Checkups',
      description: 'Accurate lab tests with fast results from trusted laboratories',
      status: 'Available',
      provider: 'Fatima',
      cost: 150.00,
      currency: 'SAR',
      imagePath: 'assets/images/med1.png',
      packageNumber: '#LB-2026',
      duration: '45-60 Minutes',
      location: 'Riyadh Medical Center',
      googleMapsUrl: 'https://maps.app.goo.gl/mEwoDmHEv13v76tD9',
      aboutText:
          'This package includes a comprehensive set of laboratory tests covering liver function, kidney function, cumulative sugar, and full blood count. Tests are performed using the latest technologies to ensure accurate results with 25% discounts.',
      availableTimes: [
        '09:00 AM',
        '10:00 AM',
        '11:00 AM',
        '01:00 PM',
        '02:00 PM',
        '03:00 PM',
      ],
    ),
    OfferItem(
      title: 'Expert Physiotherapy Care',
      description: 'Recover Faster with Expert Physiotherapy Session and enjoy 25% discounts',
      status: 'Available',
      provider: 'Dr. Ahmed',
      cost: 200.00,
      currency: 'SAR',
      imagePath: 'assets/images/med2.png',
      packageNumber: '#DN-2026',
      duration: '30-45 Minutes',
      location: 'Jeddah Dental Clinic',
      googleMapsUrl: 'https://maps.app.goo.gl/mEwoDmHEv13v76tD9',
      aboutText:
          'Customized treatment plans with flexible sessions and special pricing for new patients with 35% discounts.',
      availableTimes: [
        '08:00 AM',
        '09:30 AM',
        '11:00 AM',
        '01:00 PM',
        '03:00 PM',
      ],
    ),
    OfferItem(
      title: 'Eid Al-Adha Special Offer',
      description: 'Enjoy exclusive discounts on medical services for you and your family',
      status: 'Available',
      provider: 'Dr. Sara',
      cost: 120.00,
      currency: 'SAR',
      imagePath: 'assets/images/med1.png',
      packageNumber: '#EY-2026',
      duration: '20-30 Minutes',
      location: 'Riyadh Eye Center',
      googleMapsUrl: 'https://maps.app.goo.gl/mEwoDmHEv13v76tD9',
      aboutText:
          'Limited-time Eid discounts on doctor consultations, lab tests, and health packages.',
      availableTimes: [
        '09:00 AM',
        '10:30 AM',
        '12:00 PM',
        '02:00 PM',
        '04:00 PM',
      ],
    ),
  ];

  // ── Banner definitions ──
  late final List<BannerItem> _banners;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController();

    _banners = [
      // Banner 1 — original navigation (go to Explore tab)
      BannerItem(
        imagePath: 'assets/images/doctor1.png',
        backgroundImage: 'assets/images/home_blue_pattern.png',
        title: 'Get Care From\nTrusted Doctors\nYou\'ll Love',
        buttonText: 'Book Appointment',
        onTap: (context) => context.read<MainLayoutCubit>().goToTab(1),
      ),
      // Banner 2 — Lab Package offer
      BannerItem(
        imagePath: 'assets/images/doctor3.png',
        backgroundImage: 'assets/images/home_blue_pattern.png',
        title: 'Full Health Checkup\nFast, Affordable\nAnd Best Lab Testing',
        buttonText: 'View Offer',
        onTap:
            (context) => Navigator.of(
              context,
            ).pushNamed(Routes.offerDetails, arguments: _mockOffers[0]),
      ),
      // Banner 3 — Dental Checkup offer
      BannerItem(
        imagePath: 'assets/images/doctor2.png',
        backgroundImage: 'assets/images/home_blue_pattern.png',
        title: 'Recover Faster with\nExpert Physiotherapy\nSession',
        buttonText: 'Book Session',
        onTap:
            (context) => Navigator.of(
              context,
            ).pushNamed(Routes.offerDetails, arguments: _mockOffers[1]),
      ),
      // Banner 4 — Eye Exam offer
      BannerItem(
        imagePath: 'assets/images/doctor4.png',
        backgroundImage: 'assets/images/home_blue_pattern.png',
        title: 'Eid Al-Adha Offer\nEnjoy exclusive\nMedical Discounts',
        buttonText: 'View Offer',
        onTap:
            (context) => Navigator.of(
              context,
            ).pushNamed(Routes.offerDetails, arguments: _mockOffers[2]),
      ),
    ];

    _startTimer();
  }

  /// Pause the timer when the app is backgrounded / inactive.
  /// Resume when the app returns to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _stopTimer();
    } else if (state == AppLifecycleState.resumed) {
      _startTimer();
    }
  }

  void _startTimer() {
    _stopTimer(); // prevent duplicate timers
    _autoAdvanceTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _advancePage(),
    );
  }

  void _stopTimer() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;
  }

  void _advancePage() {
    if (!mounted || !_pageController.hasClients) return;
    final nextPage = (_currentPage + 1) % _banners.length;
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── PageView ──
        SizedBox(
          height: 195.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: BannerCard(banner: _banners[index]),
              );
            },
          ),
        ),
        verticalSpace(4.h),

        // ── Indicator Dots ──
        SizedBox(
          height: 20.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: _currentPage == index ? 24.w : 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color:
                      _currentPage == index
                          ? ColorsManager.mainBlue
                          : ColorsManager.lighterGray,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
