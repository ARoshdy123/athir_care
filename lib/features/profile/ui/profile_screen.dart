import 'dart:io';

import 'package:doctor/core/routing/routes.dart';
import 'package:doctor/core/theming/colors.dart';
import 'package:doctor/features/profile/data/models/profile_response_model.dart';
import 'package:doctor/features/profile/logic/cubit/logout_cubit.dart';
import 'package:doctor/features/profile/logic/cubit/logout_state.dart';
import 'package:doctor/features/profile/logic/cubit/profile_cubit.dart';
import 'package:doctor/features/profile/logic/cubit/profile_state.dart';
import 'package:doctor/features/profile/ui/widgets/profile_appointment_tabs.dart';
import 'package:doctor/features/profile/ui/widgets/profile_avatar.dart';
import 'package:doctor/features/profile/ui/widgets/profile_menu_items.dart';
import 'package:doctor/features/profile/ui/widgets/profile_name_and_email.dart';
import 'package:doctor/features/profile/ui/widgets/profile_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onNavigateToAppointments;

  const ProfileScreen({super.key, this.onBack, this.onNavigateToAppointments});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _pickedAvatarImage;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  Future<void> _pickAvatarImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedAvatarImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(Routes.loginScreen, (route) => false);
        } else if (state is LogoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorsManager.mainBlue,
        body: SafeArea(
          child: Column(
            children: [
              ProfileTopBar(onBack: widget.onBack),
              SizedBox(height: 50.h),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Avatar overlapping the blue-white boundary
                      Positioned(
                        top: -45.r,
                        left: 0,
                        right: 0,
                        child: BlocBuilder<ProfileCubit, ProfileState>(
                          buildWhen:
                              (previous, current) =>
                                  current is ProfileSuccess ||
                                  current is ProfileLoading,
                          builder: (context, state) {
                            final imageUrl = state.maybeWhen(
                              profileSuccess:
                                  (model) =>
                                      model.profileData?.firstOrNull?.image,
                              orElse: () => null,
                            );
                            return ProfileAvatar(
                              imageUrl: imageUrl,
                              localImage: _pickedAvatarImage,
                              onTap: _pickAvatarImage,
                            );
                          },
                        ),
                      ),
                      // Scrollable content below the avatar
                      Padding(
                        padding: EdgeInsets.only(top: 60.h),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: BlocBuilder<ProfileCubit, ProfileState>(
                            buildWhen:
                                (previous, current) =>
                                    current is ProfileLoading ||
                                    current is ProfileSuccess ||
                                    current is ProfileError,
                            builder: (context, state) {
                              return state.maybeWhen(
                                profileLoading:
                                    () => const Center(
                                      child: CircularProgressIndicator(
                                        color: ColorsManager.mainBlue,
                                      ),
                                    ),
                                profileError:
                                    (_) => Center(
                                      child: TextButton(
                                        onPressed:
                                            () =>
                                                context
                                                    .read<ProfileCubit>()
                                                    .getProfile(),
                                        child: const Text('Retry'),
                                      ),
                                    ),
                                profileSuccess:
                                    (profileModel) => _ProfileContent(
                                      name:
                                          profileModel
                                              .profileData
                                              ?.firstOrNull
                                              ?.name,
                                      email:
                                          profileModel
                                              .profileData
                                              ?.firstOrNull
                                              ?.email,
                                      profileData:
                                          profileModel.profileData?.firstOrNull,
                                      onNavigateToAppointments:
                                          widget.onNavigateToAppointments,
                                    ),
                                orElse: () => const SizedBox.shrink(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final String? name;
  final String? email;
  final ProfileData? profileData;
  final VoidCallback? onNavigateToAppointments;

  const _ProfileContent({
    this.name,
    this.email,
    this.profileData,
    this.onNavigateToAppointments,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileNameAndEmail(name: name, email: email),
        ProfileAppointmentTabs(
          onAppointmentTap: onNavigateToAppointments,
          onMedicalIdTap: () {
            Navigator.of(context).pushNamed(Routes.medicalId);
          },
        ),
        ProfileMenuItems(
          onLogout: () => context.read<LogoutCubit>().logout(),
          onPersonalInfo: () async {
            final result = await Navigator.of(
              context,
            ).pushNamed(Routes.personalInformation, arguments: profileData);
            if (result == true && context.mounted) {
              context.read<ProfileCubit>().getProfile();
            }
          },
          onMedicalId: () {
            Navigator.of(context).pushNamed(Routes.medicalRecords);
          },
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
