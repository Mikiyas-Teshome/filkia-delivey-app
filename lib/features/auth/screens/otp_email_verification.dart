import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../../../common/contants/constants.dart';
import '../../../common/network/dio_client.dart';
import '../../../common/widgets/SuccessDialog.dart';
import '../../../common/widgets/error_dialog.dart';
import '../bloc/auth_bloc.dart';
import '../repository/auth_repository.dart';
import 'login_screen.dart';

class OtpEmailVerification extends StatelessWidget {
  final String email;
  OtpEmailVerification({Key? key, required this.email}) : super(key: key);

  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dioClient = DioClient();
    final theme = Theme.of(context);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: AppConstants.primaryColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(6),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppConstants.primaryColor),
      borderRadius: BorderRadius.circular(10),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color(0xFFEDDEB1),
        borderRadius: BorderRadius.circular(10),
      ),
    );
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthEmailResendSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text("We have sucessfully sent an email to ${email}.")),
            );
          } else if (state is AuthFailure) {
            _showError(context, message: state.error);
            _otpController.clear();
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Login Failed: ${state.error}')),
            // );
          } else if (state is AuthOtpVerificationSuccess) {
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
                  "You have successfully verified u’r account, now Sign In to continue.",
              icon: 'assets/images/authSuccessful.svg',
              title: "Congratulations!",
            );
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
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          height: 30.0,
                        ),
                        SvgPicture.asset(
                          theme.brightness == Brightness.light
                              ? 'assets/images/logo.svg'
                              : 'assets/images/logoDark.svg',
                          height: 70.0,
                        ),
                        const SizedBox(height: 30),
                        SvgPicture.asset(
                          'assets/images/sendEmail.svg',
                          height: 80.0,
                        ),
                        const SizedBox(height: 30),
                        Text("enter verification code".toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0,
                                )),
                        const SizedBox(height: 30),
                        Pinput(
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          controller: _otpController,
                          // validator: (s) {
                          //   return s == '2222' ? null : 'Pin is incorrect';
                          // },
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          onCompleted: (pin) {
                            context.read<AuthBloc>().add(
                                  OtpVerifyRequested(
                                    email: email,
                                    otp: pin,
                                  ),
                                );
                          },
                          length: 5,
                        ),
                        const SizedBox(height: 35),
                        RichText(
                          text: TextSpan(
                            text: 'Didn\'t get an email? ',
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
                                text: 'Send Again',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.read<AuthBloc>().add(
                                          EmailResendRequested(
                                            email: email,
                                          ),
                                        );
                                  },
                              ),
                            ],
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
                            // 'assets/images/sendEmail.svg',
                            context.read<AuthBloc>().add(
                                  OtpVerifyRequested(
                                    email: email,
                                    otp: _otpController.text,
                                  ),
                                );
                          },
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),
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
