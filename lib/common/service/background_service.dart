import 'driver_socket_service.dart';

class BackgroundLocationService {
  final DriverSocketService socketService;

  BackgroundLocationService(this.socketService);
  @pragma('vm:entry-point')
  void backgroundCallback() {
    // BackgroundLocationTrackerManager.handleBackgroundUpdated(
    //   // (data) async => Repo().update(data),
    // );
  }

  // Future<void> stopLocationTracking() async {
  //   await BackgroundLocationTrackerManager.stopLocationService();
  //   print("Location tracking stopped.");
  // }
}
