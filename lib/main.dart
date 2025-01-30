import 'dart:ui';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:workmanager/workmanager.dart';
import 'package:zenbil_driver_app/common/service/background_service.dart';
import 'package:zenbil_driver_app/common/service/driver_socket_service.dart';
import 'package:zenbil_driver_app/features/DriverLocationScreen/DriverLocationScreen.dart';
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
//initialize work manager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
Workmanager().registerPeriodicTask(
 'locationTracking',
 'backgroundTask',
 frequency: const Duration(minutes: 15),
 );
  // Check login state before building the app
  final AuthService authService = AuthService(context: null);
  final bool isLoggedIn = await authService.isLoggedIn();

  // Get current system brightness
  final Brightness systemBrightness =
      PlatformDispatcher.instance.platformBrightness;

  runApp(
    //TODO: Comment this before final release
    //! added only for dx purposes, between this
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => VendorApp(
    //     isLoggedIn: isLoggedIn,
    //     systemBrightness: systemBrightness,
    //   ),
    // ),
    //! and this
    //? real one is this one, uncomment this and comment the above one
    VendorApp(
      isLoggedIn: isLoggedIn,
      systemBrightness: systemBrightness,
    ),
  );
}

void callbackDispatcher() {
 Workmanager().executeTask((task, inputData) {
  if (task == 'backgroundTask') {
    final DriverSocketService socketService = DriverSocketService();
    final BackgroundLocationService backgroundLocationService =
        BackgroundLocationService(socketService);
    backgroundLocationService.backgroundCallback();
 }
 return Future.value(true);
 });
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
            //TODO: Comment this before final release
            //! added only for dx purposes, between this
            // useInheritedMediaQuery: true,
            // locale: DevicePreview.locale(context),
            // builder: DevicePreview.appBuilder,
            //! and this
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
            // locale: const Locale('en'),
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
                      // child: const ForgotPasswordScreen(),
                      // child: LoginScreen(),
                      child: const DriverLocationScreen(driverId: 'driver1'),
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
