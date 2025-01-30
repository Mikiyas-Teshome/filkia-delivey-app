import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:location/location.dart';
import 'package:zenbil_driver_app/features/auth/models/login_response.dart';

import '../../../common/service/driver_socket_service.dart';

class HomeViewScreen extends StatefulWidget {
  final LoginResponse data;
  const HomeViewScreen({super.key, required this.data});

  @override
  State<HomeViewScreen> createState() => _HomeViewScreenState();
}

class _HomeViewScreenState extends State<HomeViewScreen> {
  final DriverSocketService socketService = DriverSocketService();
  final location = Location();
  @override
  void initState() {
    super.initState();

    initializeLocationService();

    // Initialize background service
  }

  Future<void> initializeLocationService() async {
    // Check and request location permissions
    await ensureLocationServiceEnabled();

    FlutterBackgroundService().startService();
    String driverId = widget.data.userInfo.driver!.id;
    socketService.connect(driverId);
    socketService.startLocationTracking(driverId);
    // await BackgroundService().initialize();
    FlutterBackgroundService().invoke('driverId', {'driverId': driverId});
  }

  Future<void> ensureLocationServiceEnabled() async {
    final location = Location();

    // Ensure the location service is enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }
    }

    // Ensure location permissions are granted
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permission not granted.');
      }
    }

    print('Location services and permissions are enabled.');
  }

  @override
  void dispose() {
    socketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Driver: ${widget.data.userInfo.driver!.id}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Example location data
                const latitude = 40.7128; // Replace with actual latitude
                const longitude = -74.0060; // Replace with actual longitude
                socketService.updateLocation(latitude, longitude);
              },
              child: const Text('Update Location'),
            ),
          ],
        ),
      ),
    );
  }
}
