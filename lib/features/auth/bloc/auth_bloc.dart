
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_response.dart';
import '../repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<EmailResendRequested>(_onEmailResendRequested);
    on<OtpVerifyRequested>(_onOtpVerificationRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  Future<void> _onForgotPasswordRequested(
      ForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.forgotPassword(event.email);
      emit(AuthForgotPasswordSuccess());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.login(event.email, event.password);

      // Save tokens in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', result.accessToken);
      await prefs.setString('refreshToken', result.refreshToken);

      emit(AuthSuccess(vendorData: result.userInfo));
    } catch (e) {
      // print("this is the e.String ${e.toSt1ring()}");
      if (e.toString() == "Exception: [EmailUnverifiedException]") {
        emit(AuthEmailUnverified());
      } else {
        emit(AuthFailure(error: e.toString()));
      }
    }
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await authRepository.signup(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        phone: event.phone,
        password: event.password,
        address: event.address,
        city: event.city,
        state: event.state,
        zipCode: event.zipCode,
        latitude: event.latitude,
        longitude: event.longitude,
        licenseNumber: event.licenseNumber,
        licenseExpiry: event.licenseExpiry,
        vehicleType: event.vehicleType,
        vehiclePlate: event.vehiclePlate,
      );

      emit(AuthSignupSuccess());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onEmailResendRequested(
    EmailResendRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await authRepository.resendEmail(
        email: event.email,
      );

      emit(AuthEmailResendSuccess());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onOtpVerificationRequested(
    OtpVerifyRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await authRepository.verifyEmailByOtp(
        email: event.email,
        otp: event.otp,
      );

      emit(AuthOtpVerificationSuccess());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Clear tokens and user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthFailure(error: 'Failed to logout: ${e.toString()}'));
    }
  }
}
