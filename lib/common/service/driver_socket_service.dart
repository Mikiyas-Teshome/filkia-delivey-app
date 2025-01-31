import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:zenbil_driver_app/common/contants/constants.dart';

class DriverSocketService {
  late io.Socket socket;
  final Location location = Location();
  StreamSubscription<LocationData>? locationSubscription;

  void connect(String driverId) {
    socket = io.io(
      AppConstants.baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setQuery({'driverId': driverId})
          .build(),
    );

    socket.onConnect((_) {
      debugPrint('Connected to the socket server as driver $driverId');
      registerDriver(driverId);
    });

    socket.onDisconnect((_) {
      debugPrint('Disconnected from the socket server, attempting to reconnect...');
      retryConnection(driverId);
    });

    socket.on('location:update', (data) {
      debugPrint('Location Update: $data');
    });
  }

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
      distanceFilter: 100,
    );

    locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        debugPrint('Location Changed: ${currentLocation.latitude}, ${currentLocation.longitude}');
        updateLocation(currentLocation.latitude!, currentLocation.longitude!);
      }
    });
  }

  void stopLocationTracking() {
    locationSubscription?.cancel();
  }

  void updateLocation(double latitude, double longitude) {
    socket.emit('driver:updateLocation', {
      'location': {'latitude': latitude, 'longitude': longitude}
    });
  }

  void registerDriver(String driverId) {
    socket.emit('driver:register', {'driverId': driverId});
  }

  void retryConnection(String driverId) {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!socket.connected) {
        debugPrint('Retrying connection...');
        connect(driverId);
      } else {
        timer.cancel();
      }
    });
  }

  void disconnect() {
    stopLocationTracking();
    socket.disconnect();
  }
}