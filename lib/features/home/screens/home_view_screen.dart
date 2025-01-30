import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:location/location.dart';
import 'package:zenbil_driver_app/features/auth/models/login_response.dart';

import '../../../common/service/driver_socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zenbil_driver_app/common/blocs/theme_bloc/theme_bloc.dart';
import 'package:zenbil_driver_app/common/contants/constants.dart';
import 'package:zenbil_driver_app/features/home/widgets/delivery_status_card_widget.dart';
import 'package:zenbil_driver_app/features/home/widgets/order_card_widget.dart';
import '../../auth/services/auth_service.dart';
import '../../auth/models/login_response.dart';
import '../blocs/home_navigation/home_navigation_bloc.dart';
import '../widgets/home_navigation_drawer.dart';

class HomeViewScreen extends StatefulWidget {
  final LoginResponse data;
  const HomeViewScreen({super.key, required this.data});

  @override
  State<HomeViewScreen> createState() => _HomeViewScreenState();
}

class _HomeViewScreenState extends State<HomeViewScreen> {
  // final DriverSocketService socketService = DriverSocketService();
  final location = Location();

  late DriverSocketService socketService;

  @override
  void initState() {
    super.initState();
    initializeLocationService();
    socketService = DriverSocketService();
    socketService.connect(widget.data.userInfo.id);
  }

  @override
  void dispose() {
    socketService.disconnect();
    super.dispose();
  }

  void _updateLocation() {
    // Example location data
    const latitude = 40.7128; // Replace with actual latitude
    const longitude = -74.0060; // Replace with actual longitude
    socketService.updateLocation(latitude, longitude);
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

  // @override
  // void dispose() {
  //   socketService.disconnect();
  //   super.dispose();
  // }
  void _logout() async {
    final authService = AuthService();
    await authService.clearAuthData();
    await authService.setLoggedIn(false);
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Container(
            margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: isDarkTheme
                  ? Colors.amber.withValues(alpha: 0.3)
                  : Colors.amber.shade100,
              borderRadius: const BorderRadius.all(
                Radius.circular(35.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, size: 30),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 36,
                )
              ],
            ),
          ),
        ),
        drawer: HomeNavigationDrawer(
          driverName:
              '${widget.data.userInfo.firstName} ${widget.data.userInfo.lastName}',
          driverEmail: widget.data.userInfo.email,
          data: widget.data,
          onLogout: _logout,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              //app bar

              //body
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      //available balance card
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppConstants.primaryColor,
                              Color(0xff342500),
                            ],
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Avail. Balance',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const Text(
                                '\$ 200.00',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: SvgPicture.asset(
                                  'assets/images/logoDark.svg',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ]),
                      ),
                      //status cards
                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 2.5,
                        children: const [
                          DeliveryStatusCardWidget(
                            text: "Completed",
                            color: Colors.green,
                            amount: 20,
                          ),
                          DeliveryStatusCardWidget(
                            text: "Pending",
                            color: Colors.orange,
                            amount: 20,
                          ),
                          DeliveryStatusCardWidget(
                            text: "Canceled",
                            color: Colors.red,
                            amount: 20,
                          ),
                          DeliveryStatusCardWidget(
                            text: "Ongoing",
                            color: Colors.lightBlue,
                            amount: 20,
                          ),
                        ],
                      ),
                      //orders cards
                      const Text(
                        'Orders',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          OrderCardWidget(
                              borderColor: Colors.yellow, isPending: true),
                          OrderCardWidget(borderColor: Colors.green),
                          OrderCardWidget(borderColor: Colors.red),
                          OrderCardWidget(borderColor: Colors.green),
                          OrderCardWidget(borderColor: Colors.red),
                          OrderCardWidget(
                              borderColor: Colors.yellow, isPending: true),
                          OrderCardWidget(
                              borderColor: Colors.yellow, isPending: true),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
