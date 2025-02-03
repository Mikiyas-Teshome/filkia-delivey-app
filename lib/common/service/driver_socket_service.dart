import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:zenbil_driver_app/common/contants/constants.dart';

class DriverSocketService {
  late io.Socket socket;

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
    socket.disconnect();
  }
}