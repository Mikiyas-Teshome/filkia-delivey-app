import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zenbil_driver_app/features/auth/screens/forgot_password_screen.dart';
import 'common/blocs/theme_bloc/theme_bloc.dart';
import 'common/localization/app_localizations.dart';
import 'common/navigation_service.dart';
import 'common/network/dio_client.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/services/auth_service.dart';
import 'features/auth/repository/auth_repository.dart';
import 'features/home/blocs/home_navigation/home_navigation_bloc.dart';
import 'features/home/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check login state before building the app
  final AuthService authService = AuthService(context: null);
  final bool isLoggedIn = await authService.isLoggedIn();

  // Get current system brightness
  final Brightness systemBrightness =
      PlatformDispatcher.instance.platformBrightness;

  runApp(VendorApp(isLoggedIn: isLoggedIn, systemBrightness: systemBrightness));
}

class VendorApp extends StatefulWidget {
  final bool isLoggedIn;
  final Brightness systemBrightness;

  const VendorApp({
    required this.isLoggedIn,
    required this.systemBrightness,
    super.key,
  });

  @override
  State<VendorApp> createState() => _VendorAppState();
}

class _VendorAppState extends State<VendorApp> with WidgetsBindingObserver {
  late ThemeBloc _themeBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize ThemeBloc with the system theme.
    _themeBloc = ThemeBloc(widget.systemBrightness);
  }

  @override
  void didChangePlatformBrightness() {
    // Notify ThemeBloc of system theme changes using PlatformDispatcher.
    final Brightness newBrightness =
        PlatformDispatcher.instance.platformBrightness;
    _themeBloc.add(SystemThemeChangedEvent(newBrightness));
  }

  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    final dioClient = DioClient();
    return BlocProvider(
      create: (_) => _themeBloc,
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Flikia Delivery',
            theme: themeState.themeData,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('ar', ''),
            ],
            navigatorKey: navigatorKey,
            locale: const Locale('en'),
            routes: {
              // When navigating to the "/second" route, build the SecondScreen widget.
              '/login': (context) => RepositoryProvider(
                    create: (context) => AuthRepository(dioClient),
                    child: BlocProvider(
                      create: (context) => AuthBloc(
                          RepositoryProvider.of<AuthRepository>(context)),
                      child: LoginScreen(),
                    ),
                  ),
            },
            home: widget.isLoggedIn
                ? BlocProvider(
                    create: (_) => HomeNavigationBloc(),
                    child: const HomeScreen(),
                  )
                // : const ForgotPasswordScreen(),
                : RepositoryProvider(
                    create: (context) => AuthRepository(dioClient),
                    child: BlocProvider(
                      create: (context) => AuthBloc(
                          RepositoryProvider.of<AuthRepository>(context)),
                      child: LoginScreen(),
                    ),
                  ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _themeBloc.close();
    super.dispose();
  }
}
