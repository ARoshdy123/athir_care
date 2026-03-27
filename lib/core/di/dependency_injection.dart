import 'package:doctor/core/services/download_service.dart';
import 'package:dio/dio.dart';
import 'package:doctor/core/networking/dio_factory.dart';
import 'package:doctor/features/home/data/data_sources/home_api_service.dart';
import 'package:doctor/features/home/data/repos/home_repo.dart';
import 'package:doctor/features/home/logic/home_cubit.dart';
import 'package:doctor/features/login/data/data_sources/login_api_service.dart';
import 'package:doctor/features/login/data/repos/login_repo.dart';
import 'package:doctor/features/login/logic/cubit/login_cubit.dart';
import 'package:doctor/features/profile/data/data_sources/profile_api_service.dart';
import 'package:doctor/features/profile/data/repos/profile_repo.dart';
import 'package:doctor/features/profile/logic/cubit/logout_cubit.dart';
import 'package:doctor/features/profile/logic/cubit/profile_cubit.dart';
import 'package:doctor/features/profile/logic/cubit/update_profile_cubit.dart';
import 'package:doctor/features/explore/data/data_sources/explore_api_service.dart';
import 'package:doctor/features/explore/data/repos/explore_repo.dart';
import 'package:doctor/features/explore/logic/explore_cubit.dart';
import 'package:doctor/features/booking/data/data_sources/booking_api_service.dart';
import 'package:doctor/features/booking/data/repos/appointment_repo.dart';
import 'package:doctor/features/booking/logic/cubit/appointment_cubit.dart';
import 'package:doctor/features/my_appointments/data/data_sources/my_appointments_api_service.dart';
import 'package:doctor/features/my_appointments/data/repos/my_appointments_repo.dart';
import 'package:doctor/features/my_appointments/logic/cubit/my_appointments_cubit.dart';
import 'package:doctor/features/sign_up/data/data_sources/sign_up_api_service.dart';
import 'package:doctor/features/sign_up/data/repo/sign_up_repo.dart';
import 'package:doctor/features/sign_up/logic/cubit/sign_up_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Dio & ApiService
  Dio dio = await DioFactory.getDio();
  // Register Dio  one instance
  getIt.registerLazySingleton<LoginApiService>(() => LoginApiService(dio));
  getIt.registerLazySingleton<SignUpApiService>(() => SignUpApiService(dio));
  // Download service (shared singleton)
  getIt.registerLazySingleton<DownloadService>(() => DownloadService(dio));

  //login
  getIt.registerLazySingleton<LoginRepo>(
    () => LoginRepo(getIt()),
  ); //create noskha whda for all app (dispose will lead crash)
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(getIt()),
  ); // kool ma ahtgha create noskha gdeda
  //Register
  getIt.registerLazySingleton<SignUpRepo>(() => SignUpRepo(getIt()));
  getIt.registerFactory<SignUpCubit>(() => SignUpCubit(getIt()));
  //Home
  getIt.registerLazySingleton<HomeApiService>(() => HomeApiService(dio));
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt()));
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt()));
  //Explore
  getIt.registerLazySingleton<ExploreApiService>(() => ExploreApiService(dio));
  getIt.registerLazySingleton<ExploreRepo>(() => ExploreRepo(getIt()));
  getIt.registerFactory<ExploreCubit>(() => ExploreCubit(getIt()));
  //Profile
  getIt.registerLazySingleton<ProfileApiService>(() => ProfileApiService(dio));
  getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepo(getIt()));
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt()));
  getIt.registerFactory<LogoutCubit>(() => LogoutCubit(getIt()));
  getIt.registerFactory<UpdateProfileCubit>(() => UpdateProfileCubit(getIt()));
  //Appointment
  getIt.registerLazySingleton<BookingApiService>(() => BookingApiService(dio));
  getIt.registerLazySingleton<AppointmentRepo>(() => AppointmentRepo(getIt()));
  getIt.registerFactory<AppointmentCubit>(() => AppointmentCubit(getIt()));
  //My Appointments
  getIt.registerLazySingleton<MyAppointmentsApiService>(
    () => MyAppointmentsApiService(dio),
  );
  getIt.registerLazySingleton<MyAppointmentsRepo>(
    () => MyAppointmentsRepo(getIt()),
  );
  getIt.registerFactory<MyAppointmentsCubit>(
    () => MyAppointmentsCubit(getIt()),
  );
}
