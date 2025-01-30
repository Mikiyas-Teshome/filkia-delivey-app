import 'driver_socket_service.dart';

class BackgroundLocationService {
  final DriverSocketService socketService;

  BackgroundLocationService(this.socketService);
  @pragma('vm:entry-point')
  void backgroundCallback() {
    socketService.location.changeSettings(interval: 1000);
    socketService.locationSubscription = socketService.location.onLocationChanged.listen((locationData) {
      socketService.updateLocation(locationData.latitude!, locationData.longitude!);
    });
  }

  @pragma('vm:entry-point')
  void stopBackgroundCallback() {
    socketService.locationSubscription?.cancel();
  }

  @pragma('vm:entry-point')
  void registerDriver(String driverId) {
    socketService.socket.emit('driver:register', {'driverId': driverId});
  }
}
