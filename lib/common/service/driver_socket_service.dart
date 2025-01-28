import 'dart:async';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:zenbil_driver_app/common/contants/constants.dart';

class DriverSocketService {
  late IO.Socket socket;
  final Location location = Location();
  StreamSubscription<LocationData>? locationSubscription;

  // Initialize the socket connection
  void connect(String driverId) {
    socket = IO.io(
      AppConstants.baseUrl, // Replace with your backend IP
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setQuery({'driverId': driverId})
          .build(),
    );

    // Handle socket events
    socket.onConnect((_) {
      print('Connected to the socket server as driver $driverId');
      registerDriver(driverId);
    });

    socket.onDisconnect((_) {
      print('Disconnected from the socket server, attempting to reconnect...');
      retryConnection(driverId);
    });

    socket.on('location:update', (data) {
      print('Location Update: $data');
    });
  }

  // Retry socket connection
  void retryConnection(String driverId) {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!socket.connected) {
        print('Retrying connection...');
        connect(driverId);
      } else {
        timer.cancel();
      }
    });
  }

  // Register the driver
  void registerDriver(String driverId) {
    socket.emit('driver:register', {'driverId': driverId});
  }

  // Update the driver's location
  void updateLocation(double latitude, double longitude) {
    socket.emit('driver:updateLocation', {
      'location': {'latitude': latitude, 'longitude': longitude}
    });
  }

  // Start location tracking
  void startLocationTracking(String driverId) async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    location.changeSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100, // Update only if the location changes by 100 meters
    );

    locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) async {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        print(
            'Location Changed: ${currentLocation.latitude}, ${currentLocation.longitude}');
        updateLocation(currentLocation.latitude!, currentLocation.longitude!);
      }
    });
  }

  // Stop location tracking
  void stopLocationTracking() {
    locationSubscription?.cancel();
  }

  // Disconnect the socket
  void disconnect() {
    stopLocationTracking();
    socket.disconnect();
  }
}
