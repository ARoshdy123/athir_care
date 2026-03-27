import 'package:doctor/core/di/dependency_injection.dart';
import 'package:doctor/core/routing/routes.dart';
import 'package:doctor/features/home/logic/home_cubit.dart';
import 'package:doctor/features/home/ui/home_screen.dart';
import 'package:doctor/features/login/logic/cubit/login_cubit.dart';
import 'package:doctor/features/login/ui/login_screen.dart';
import 'package:doctor/features/explore/data/models/all_doctors_response_model.dart';
import 'package:doctor/features/explore/ui/doctor_detail_screen.dart';
import 'package:doctor/features/main_layout/ui/main_layout_screen.dart';
import 'package:doctor/features/medical_records/ui/medical_records_screen.dart';
import 'package:doctor/features/medical_records/ui/pdf_viewer_screen.dart';
import 'package:doctor/features/onboarding/onboarding_screen.dart';
import 'package:doctor/features/profile/data/models/profile_response_model.dart';
import 'package:doctor/features/profile/logic/cubit/update_profile_cubit.dart';
import 'package:doctor/features/profile/ui/medical_id_screen.dart';
import 'package:doctor/features/profile/ui/personal_information_screen.dart';
import 'package:doctor/features/booking/logic/cubit/appointment_cubit.dart';
import 'package:doctor/features/booking/ui/book_appointment_screen.dart';
import 'package:doctor/features/booking/ui/booking_confirmed_screen.dart';
import 'package:doctor/features/my_appointments/data/models/appointments_list_response_model.dart';
import 'package:doctor/features/my_appointments/ui/reschedule_screen.dart';
import 'package:doctor/features/my_appointments/ui/rescheduled_confirmed_screen.dart';
import 'package:doctor/features/sign_up/logic/cubit/sign_up_cubit.dart';
import 'package:doctor/features/sign_up/ui/sign_up_screen.dart';
import 'package:doctor/features/offers/data/models/offer_item_model.dart';
import 'package:doctor/features/offers/ui/offer_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    // this is argument to be passed in any screen like this (arguments: 'class name')
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case Routes.loginScreen:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => getIt<LoginCubit>(),
                child: const LoginScreen(),
              ),
        );
      case Routes.signupScreen:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => getIt<SignUpCubit>(),
                child: const SignupScreen(),
              ),
        );
      case Routes.mainLayout:
        final initialTab = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => MainLayoutScreen(initialTabIndex: initialTab),
        );

      case Routes.homeScreen:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => getIt<HomeCubit>()..getSpecializations(),
                child: const HomeScreen(),
              ),
        );

      case Routes.personalInformation:
        final profileData = arguments as ProfileData?;
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => getIt<UpdateProfileCubit>(),
                child: PersonalInformationScreen(profileData: profileData),
              ),
        );

      case Routes.medicalId:
        return MaterialPageRoute(builder: (_) => const MedicalIdScreen());

      case Routes.doctorDetail:
        final doctorData = arguments as DoctorData?;
        return MaterialPageRoute(
          builder: (_) => DoctorDetailScreen(doctorData: doctorData),
        );

      case Routes.bookAppointment:
        final doctorData = arguments as DoctorData?;
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (_) => getIt<AppointmentCubit>(),
                child: BookAppointmentScreen(doctorData: doctorData),
              ),
        );

      case Routes.bookingConfirmed:
        final cubit = arguments as AppointmentCubit;
        return MaterialPageRoute(
          builder: (_) => BookingConfirmedScreen(cubit: cubit),
        );

      case Routes.rescheduleAppointment:
        final appointment = arguments as AppointmentItem;
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (_) => getIt<AppointmentCubit>(),
                child: RescheduleScreen(appointment: appointment),
              ),
        );

      case Routes.rescheduledConfirmed:
        final cubit = arguments as AppointmentCubit;
        return MaterialPageRoute(
          builder: (_) => RescheduledConfirmedScreen(cubit: cubit),
        );

      case Routes.medicalRecords:
        return MaterialPageRoute(builder: (_) => const MedicalRecordsScreen());

      case Routes.pdfViewer:
        final args = arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder:
              (_) => PdfViewerScreen(
                title: args['title'] as String,
                assetPath: args['assetPath'] as String,
                triggerDownload: args['download'] as bool? ?? false,
              ),
        );

      case Routes.offerDetails:
        final offer = arguments as OfferItem;
        return MaterialPageRoute(
          builder: (_) => OfferDetailsScreen(offer: offer),
        );

      default:
        return null;
    }
  }
}
