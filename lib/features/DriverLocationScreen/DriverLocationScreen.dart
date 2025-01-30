// import 'package:flutter/material.dart';
//
// import '../../common/service/driver_socket_service.dart';
//
// class DriverLocationScreen extends StatefulWidget {
//   final String driverId;
//
//   const DriverLocationScreen({super.key, required this.driverId});
//
//   @override
//   _DriverLocationScreenState createState() => _DriverLocationScreenState();
// }
//
// class _DriverLocationScreenState extends State<DriverLocationScreen> {
//   late DriverSocketService socketService;
//
//   @override
//   void initState() {
//     super.initState();
//     socketService = DriverSocketService();
//     socketService.connect(widget.driverId);
//   }
//
//   @override
//   void dispose() {
//     socketService.disconnect();
//     super.dispose();
//   }
//
//   void _updateLocation() {
//     // Example location data
//     const latitude = 40.7128; // Replace with actual latitude
//     const longitude = -74.0060; // Replace with actual longitude
//     socketService.updateLocation(latitude, longitude);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Driver Location Tracker'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Driver: ${widget.driverId}'),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _updateLocation,
//               child: const Text('Update Location'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
