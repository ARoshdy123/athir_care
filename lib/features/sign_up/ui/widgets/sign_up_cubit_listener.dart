import 'package:doctor/core/helpers/extensions.dart';
import 'package:doctor/features/sign_up/logic/cubit/sign_up_cubit.dart';
import 'package:doctor/features/sign_up/logic/cubit/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class SignupCubitListener extends StatelessWidget {
  const SignupCubitListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignupState>(
      listenWhen:
          (previous, current) =>
              current is SignupLoading ||
              current is SignupSuccess ||
              current is SignupError,
      listener: (context, state) {
        state.whenOrNull(
          signupLoading: () {
            showDialog(
              context: context,
              builder:
                  (context) => const Center(
                    child: CircularProgressIndicator(
                      color: ColorsManager.mainBlue,
                    ),
                  ),
            );
          },
          signupSuccess: (signupResponse) {
            context.pop();
            showSuccessDialog(context);
          },
          signupError: (error) {
            // Dismiss the loading dialog, then show the error
            context.pop();
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    icon: const Icon(Icons.error, color: Colors.red, size: 32),
                    content: Text(
                      error,
                      style: TextStyles.font15DarkBlueMedium,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: Text(
                          'Got it',
                          style: TextStyles.font14BlueSemiBold,
                        ),
                      ),
                    ],
                  ),
            );
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Account Created Successfully',
            style: TextStyle(color: ColorsManager.green),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Congratulations, you have signed up successfully!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                disabledForegroundColor: Colors.grey.withOpacity(0.38),
              ),
              onPressed: () {
                context.pushNamed(Routes.loginScreen);
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }
}
