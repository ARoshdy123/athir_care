import 'package:doctor/core/helpers/constants.dart';
import 'package:doctor/core/helpers/shared_pref_helper.dart';
import 'package:doctor/core/networking/dio_factory.dart';
import 'package:doctor/features/login/data/models/login_request_body.dart';
import 'package:doctor/features/login/data/repos/login_repo.dart';
import 'package:doctor/features/login/logic/cubit/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  LoginCubit(this._loginRepo) : super(LoginState.initial());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool rememberMe = false;

  Future<void> loadRememberedCredentials() async {
    rememberMe =
        await SharedPrefHelper.getBool(SharedPrefKeys.rememberMe) ?? false;

    if (!rememberMe) {
      return;
    }

    emailController.text =
        await SharedPrefHelper.getString(SharedPrefKeys.savedEmail) ?? '';
    passwordController.text =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.savedPassword) ??
        '';
  }

  Future<void> setRememberMe(bool value) async {
    rememberMe = value;
    await SharedPrefHelper.setBool(SharedPrefKeys.rememberMe, value);

    if (!value) {
      await SharedPrefHelper.removeData(SharedPrefKeys.savedEmail);
      await SharedPrefHelper.removeSecuredData(SharedPrefKeys.savedPassword);
    }
  }

  Future<String?> loginWithFingerprint() async {
    final savedEmail =
        await SharedPrefHelper.getString(SharedPrefKeys.savedEmail) ?? '';
    final savedPassword =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.savedPassword) ??
        '';

    if (savedEmail.isEmpty || savedPassword.isEmpty) {
      return 'Please login first and enable Remember me to activate fingerprint login.';
    }

    final canAuthenticate = await _canUseFingerprint();
    if (!canAuthenticate) {
      return 'Fingerprint is not available on this device.';
    }

    try {
      final didAuthenticate = await _localAuthentication.authenticate(
        localizedReason: 'Use your fingerprint to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (!didAuthenticate) {
        return 'Fingerprint authentication was cancelled.';
      }
    } on PlatformException catch (error) {
      return error.message ?? 'Fingerprint authentication failed.';
    }

    emailController.text = savedEmail;
    passwordController.text = savedPassword;
    await emitLoginState();
    return null;
  }

  Future<void> emitLoginState() async {
    emit(LoginState.loading());

    final response = await _loginRepo.login(
      LoginRequestBody(
        email: emailController.text,
        password: passwordController.text,
      ),
    );

    response.when(
      success: (data) async {
        await _saveUserToken(data.userData?.token ?? '');
        await SharedPrefHelper.setString(
          SharedPrefKeys.userName,
          data.userData?.userName ?? '',
        );
        await _persistRememberedCredentials();
        emit(LoginState.success(data));
      },
      failure: (errorHandler) {
        emit(LoginState.error(errorHandler.apiErrorModel.message ?? ''));
      },
    );
  }

  Future<bool> _canUseFingerprint() async {
    try {
      final canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      final isSupported = await _localAuthentication.isDeviceSupported();

      if (!canCheckBiometrics || !isSupported) {
        return false;
      }

      final availableBiometrics =
          await _localAuthentication.getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } on PlatformException {
      return false;
    }
  }

  Future<void> _persistRememberedCredentials() async {
    if (rememberMe) {
      await SharedPrefHelper.setString(
        SharedPrefKeys.savedEmail,
        emailController.text.trim(),
      );
      await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.savedPassword,
        passwordController.text,
      );
      return;
    }

    await SharedPrefHelper.removeData(SharedPrefKeys.savedEmail);
    await SharedPrefHelper.removeSecuredData(SharedPrefKeys.savedPassword);
  }

  Future<void> _saveUserToken(String token) async {
    await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, token);
    DioFactory.setTokenIntoHeaderAfterLogin(token);
  }
}
