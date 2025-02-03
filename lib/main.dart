import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location/location.dart';
import 'package:zenbil_driver_app/common/service/driver_socket_service.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  final AuthService authService = AuthService(context: null);
  final bool isLoggedIn = await authService.isLoggedIn();
  final Brightness systemBrightness = PlatformDispatcher.instance.platformBrightness;

  runApp(VendorApp(
    isLoggedIn: isLoggedIn,
    systemBrightness: systemBrightness,
  ));
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      // notificationChannelId: 'driver_location_tracker',
      initialNotificationTitle: 'Driver Location Tracking',
      initialNotificationContent: 'Tracking driver location in real-time',
      foregroundServiceTypes: [AndroidForegroundType.location],
      // foregroundServiceNotificationId: 1212,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final socketService = DriverSocketService();
  final location = Location();

  // Initialize location settings
  await location.changeSettings(
    accuracy: LocationAccuracy.high,
    interval: 1000, // 1 second
    // distanceFilter: 10, // Update every 10 meters
  );

  // Ensure location services are enabled
  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) return;
  }

  // Ensure location permissions are granted
  PermissionStatus permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) return;
  }

  // Enable background location mode
  location.enableBackgroundMode(enable: true);

  // Listen to location updates
  location.onLocationChanged.listen((LocationData currentLocation) async {
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      debugPrint('Location Update: ${currentLocation.latitude}, ${currentLocation.longitude}');
      // Update location via socket
      socketService.updateLocation(currentLocation.latitude!, currentLocation.longitude!);

      // Send data to the UI (optional)
      service.invoke('update', {
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  });

  // Handle service stop event
  service.on('stopService').listen((event) {
    location.enableBackgroundMode(enable: false);
    service.stopSelf();
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
    _themeBloc = ThemeBloc(widget.systemBrightness);
  }

  @override
  void didChangePlatformBrightness() {
    final Brightness newBrightness = PlatformDispatcher.instance.platformBrightness;
    _themeBloc.add(SystemThemeChangedEvent(newBrightness));
  }

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
            routes: {
              '/login': (context) => RepositoryProvider(
                    create: (context) => AuthRepository(dioClient),
                    child: BlocProvider(
                      create: (context) => AuthBloc(RepositoryProvider.of<AuthRepository>(context)),
                      child: LoginScreen(),
                    ),
                  ),
            },
            home: widget.isLoggedIn
                ? BlocProvider(
                    create: (_) => HomeNavigationBloc(),
                    child: const HomeScreen(),
                  )
                : RepositoryProvider(
                    create: (context) => AuthRepository(dioClient),
                    child: BlocProvider(
                      create: (context) => AuthBloc(RepositoryProvider.of<AuthRepository>(context)),
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