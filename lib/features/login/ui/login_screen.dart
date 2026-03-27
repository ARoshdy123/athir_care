import 'package:doctor/core/helpers/responsive_helper.dart';
import 'package:doctor/core/helpers/spacing.dart';
import 'package:doctor/core/theming/colors.dart';
import 'package:doctor/core/theming/styles.dart';
import 'package:doctor/core/widgets/app_text_button.dart';
import 'package:doctor/features/login/logic/cubit/login_cubit.dart';
import 'package:doctor/features/login/ui/widgets/dont_have_account_text.dart';
import 'package:doctor/features/login/ui/widgets/email_and_password.dart';
import 'package:doctor/features/login/ui/widgets/terms_and_conditions_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'widgets/login_bloc_listener.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.rw, vertical: 20.rh),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/svgs/athir_logo1.svg'),
                verticalSpace(25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome Back', style: TextStyles.font24BlueBold),
                    verticalSpace(8),
                    Text(
                      'We\'re excited to have you back, can\'t wait to see what you\'ve been up to since you last logged in.',
                      style: TextStyles.font14GrayRegular,
                    ),
                    verticalSpace(28),
                    const EmailAndPassword(),
                    verticalSpace(20),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextButton(
                            buttonText: 'Login',
                            textStyle: TextStyles.font16WhiteSemiBold,
                            onPressed: () {
                              validateThenDoLogin(context);
                            },
                          ),
                        ),
                        horizontalSpace(8),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: ColorsManager.lightBlue,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: IconButton(
                            tooltip: 'Login with fingerprint',
                            onPressed: () {
                              activateFingerprintLogin(context);
                            },
                            icon: const Icon(Icons.fingerprint),
                            color: ColorsManager.mainBlue,
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(16),
                    const Center(child: TermsAndConditionsText()),
                    verticalSpace(28),
                    const Center(child: DontHaveAccountText()),
                    const LoginBlocListener(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> activateFingerprintLogin(BuildContext context) async {
  final message = await context.read<LoginCubit>().loginWithFingerprint();

  if (message != null && context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

void validateThenDoLogin(BuildContext context) {
  if (context.read<LoginCubit>().formKey.currentState!.validate()) {
    context.read<LoginCubit>().emitLoginState();
  }
}
