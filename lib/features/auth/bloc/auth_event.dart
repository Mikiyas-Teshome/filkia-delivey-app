part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class EmailResendRequested extends AuthEvent {
  final String email;

  EmailResendRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class OtpVerifyRequested extends AuthEvent {
  final String email;
  final String otp;

  OtpVerifyRequested({
    required this.email,
    required this.otp,
  });

  @override
  List<Object> get props => [email, otp];
}

class SignupRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String licenseNumber;
  final String licenseExpiry;
  final String vehicleType;
  final String vehiclePlate;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final double latitude;
  final double longitude;

  SignupRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.licenseNumber,
    required this.licenseExpiry,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.latitude,
    required this.longitude
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        email,
        phone,
        password,
    licenseNumber,
    licenseExpiry,
    vehicleType,
    vehiclePlate,
        address,
        city,
        state,
        zipCode,
        latitude,
        longitude
      ];
}

class LogoutRequested extends AuthEvent {}
