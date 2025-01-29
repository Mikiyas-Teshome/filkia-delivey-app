import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenbil_driver_app/common/network/dio_client.dart';
import 'package:zenbil_driver_app/common/widgets/SuccessDialog.dart';
import 'package:zenbil_driver_app/common/widgets/custom_text_form_field.dart';
import 'package:zenbil_driver_app/common/widgets/error_dialog.dart';
import 'package:zenbil_driver_app/features/auth/bloc/auth_bloc.dart';
import 'package:zenbil_driver_app/features/auth/repository/auth_repository.dart';
import 'package:zenbil_driver_app/features/auth/screens/login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
    final dioClient = DioClient();
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthForgotPasswordSuccess) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RepositoryProvider(
                    create: (context) => AuthRepository(dioClient),
                    child: BlocProvider(
                      create: (context) => AuthBloc(
                          RepositoryProvider.of<AuthRepository>(context)),
                      child: LoginScreen(),
                    ),
                  ),
                ));
                _showSucess(
              context,
              message:
                  "Check your email for a password reset link and instructions.  After resetting, you can sign in with your new password.",
              icon: 'assets/images/forgotSuccessful.svg',
              title: "Reset Link Sent!",
            );

          } else if (state is AuthFailure) {
            _showError(context, message: state.error);
          }

        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                          ),
                          SvgPicture.asset(
                            theme.brightness == Brightness.light
                                ? 'assets/images/logo.svg'
                                : 'assets/images/logoDark.svg',
                            height: 80,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Forgot Password?',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Form(
                            key: _formKey,
                            child: CustomTextField(
                              labelText: 'Email',
                              prefixIcon: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              validator: _validateEmail,
                            ),
                          ),
                          const SizedBox(height: 30),
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
                                BlocProvider.of<AuthBloc>(context).add(
                                  ForgotPasswordRequested(
                                      email: _emailController.text),
                                );
                              }
                            },
                            child: const Text(
                              'Reset Password',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.09,
                          ),
                          Text(
                            "By continuing, you agree to our Terms and Privacy Policy.",
                            style: GoogleFonts.inter(
                              fontSize: 15.0,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withValues(alpha: 0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                if(state is AuthLoading)
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withValues( alpha: 0.8),
                    child: const SpinKitCircle(
                      color: Colors.white,
                      size: 60,
                    ),
                  ),


                ],
              ),
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

  void _showSucess(BuildContext context,
      {required String message, required String icon, required String title}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(
          title: title,
          message: message,
          icon: icon,
        );
      },
    );
  }
}
