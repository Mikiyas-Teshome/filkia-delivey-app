import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/network/dio_client.dart';
import '../../../common/widgets/custom_text_form_field.dart';
import '../../../common/widgets/error_dialog.dart';
import '../bloc/auth_bloc.dart';
import '../repository/auth_repository.dart';
import '../widgets/address_input.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_phone_text_field.dart';
import 'otp_email_verification.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _licenseNumber = TextEditingController();
  final TextEditingController _vehiclePlate = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _licenseExpiryController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  String? _selectedVehicleType;
  DateTime? _selectedlicenseExpiry = null;

  double? latitude;
  double? longitude;

  void _onCoordinatesChanged(double lat, double lng) {
    setState(() {
      latitude = lat;
      longitude = lng;
    });
  }

  final List<DropdownMenuItem<String>> _businessTypeItems = [
    const DropdownMenuItem(value: 'BIKE', child: Text('BIKE')),
    const DropdownMenuItem(value: 'CAR', child: Text('CAR')),
    const DropdownMenuItem(value: 'TRUCK', child: Text('TRUCK')),
    const DropdownMenuItem(value: 'SCOOTER', child: Text('SCOOTER')),
    const DropdownMenuItem(value: 'VAN', child: Text('VAN')),
  ];
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null; // Valid email
  }

  /// Function to validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null; // Valid password
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dioClient = DioClient();

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSignupSuccess) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RepositoryProvider(
                    create: (context) => AuthRepository(dioClient),
                    child: BlocProvider(
                      create: (context) => AuthBloc(
                          RepositoryProvider.of<AuthRepository>(context)),
                      child: OtpEmailVerification(email: _emailController.text),
                    ),
                  ),
                ));
          } else if (state is AuthFailure) {
            _showError(context, message: state.error);
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Login Failed: ${state.error}')),
            // );
          }
        },
        builder: (context, state) {
          // if (state is AuthLoading) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30.0,
                        ),
                        SvgPicture.asset(
                          theme.brightness == Brightness.light
                              ? 'assets/images/logo.svg'
                              : 'assets/images/logoDark.svg',
                          height: 80.0,
                        ),
                        const SizedBox(height: 10),
                        Text("Welcome!",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0,
                                )),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              CustomTextField(
                                controller: _firstNameController,
                                labelText: 'First Name',
                                prefixIcon: Icons.person_outlined,
                                validator: (value) => value!.isEmpty
                                    ? 'First name is required'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: _lastNameController,
                                labelText: 'Last Name',
                                prefixIcon: Icons.person_outlined,
                                validator: (value) => value!.isEmpty
                                    ? 'Last name is required'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                labelText: "Email",
                                prefixIcon: Icons.mail_outline_rounded,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: _validateEmail,
                              ),
                              const SizedBox(height: 20),
                              CustomPhoneTextFormField(
                                controller: _phoneController,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: _licenseNumber,
                                labelText: 'License Number',
                                prefixIcon: Icons.emoji_transportation,
                                validator: (value) => value!.isEmpty
                                    ? 'License Number is required'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: _vehiclePlate,
                                labelText: 'Vehicle Plate',
                                prefixIcon: Icons.emoji_transportation,
                                validator: (value) => value!.isEmpty
                                    ? 'License Number is required'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              CustomDropdown<String>(
                                labelText: 'Vehicle Type',
                                prefixIcon: Icons.emoji_transportation,
                                value: _selectedVehicleType,
                                items: _businessTypeItems,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedVehicleType = value;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Please select your business type'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              CustomDatePicker(
                                labelText: 'License Expiry Date',
                                prefixIcon: Icons.calendar_today,
                                selectedDate:
                                    _selectedlicenseExpiry, // Pass a DateTime object or null
                                onDateChanged: (pickedDate) {
                                  setState(() {
                                    _selectedlicenseExpiry =
                                        pickedDate; // Update the selected date
                                  });
                                },
                                validator: (date) {
                                  if (_licenseExpiryController.text == null) {
                                    return 'Please select license expiry date';
                                  }
                                  return null;
                                },
                                dateController: _licenseExpiryController,
                              ),
                              const SizedBox(height: 20),
                              AddressInputWidget(
                                apiKey:
                                    "AIzaSyC2i-kNKBh5fFJV0h9cZiRxntbrz-rn5uI",
                                addressController: _addressController,
                                cityController: _cityController,
                                stateController: _stateController,
                                zipCodeController: _zipCodeController,
                                onCoordinatesChanged: _onCoordinatesChanged,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                labelText: "Password",
                                prefixIcon: Icons.lock_outline_rounded,
                                isPassword: true,
                                controller: _passwordController,
                                validator: _validatePassword,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: _confirmPasswordController,
                                labelText: 'Confirm Password',
                                prefixIcon: Icons.lock_outline_rounded,
                                isPassword: true,
                                validator: (value) =>
                                    value != _passwordController.text
                                        ? 'Passwords do not match'
                                        : null,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // backgroundColor: Colors.amber,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (latitude != null && longitude != null) {
                                context.read<AuthBloc>().add(
                                      SignupRequested(
                                        firstName: _firstNameController.text,
                                        lastName: _lastNameController.text,
                                        email: _emailController.text,
                                        phone: _phoneController.text,
                                        password: _passwordController.text,
                                        licenseExpiry:
                                            _selectedlicenseExpiry!.toString(),
                                        licenseNumber: _licenseNumber.text,
                                        vehicleType: _selectedVehicleType!,
                                        vehiclePlate: _vehiclePlate.text,
                                        address: _addressController.text,
                                        city: _cityController.text,
                                        state: _stateController.text,
                                        zipCode: _zipCodeController.text,
                                        latitude: latitude!,
                                        longitude: longitude!,
                                      ),
                                    );
                              } else {
                                _showError(context,
                                    message: "Please enter a valid address");
                              }
                            }
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 35),
                        RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: GoogleFonts.inter(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withOpacity(0.7)),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pop(context);
                                  },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Text(
                          "By continuing, you agree to our Terms and Privacy Policy.",
                          style: GoogleFonts.inter(
                            fontSize: 15.0,
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                        ),
                      ],
                    ),
                  ),
                ),
                if (state is AuthLoading)
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(0.8),
                    child: const SpinKitCircle(
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showError(BuildContext context, {required String message}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(
          title: 'Error',
          message: message,
        );
      },
    );
  }
}
