part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthEmailUnverified extends AuthState {}

class AuthSuccess extends AuthState {
  final UserInfo vendorData;

  AuthSuccess({required this.vendorData});

  @override
  List<Object> get props => [vendorData];
}

class AuthSignupSuccess extends AuthState {}

class AuthEmailResendSuccess extends AuthState {}

class AuthOtpVerificationSuccess extends AuthState {}

class AuthForgotPasswordSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class AuthLoggedOut extends AuthState {}
