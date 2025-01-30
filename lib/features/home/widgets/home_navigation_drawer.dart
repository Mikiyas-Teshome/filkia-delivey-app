import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenbil_driver_app/features/DriverLocationScreen/DriverLocationScreen.dart';
import 'package:zenbil_driver_app/features/auth/models/login_response.dart';
import 'package:zenbil_driver_app/features/home/screens/home_view_screen.dart';

import '../../../common/contants/constants.dart';
import '../blocs/home_navigation/home_navigation_bloc.dart';

class HomeNavigationDrawer extends StatelessWidget {
  final String driverName;
  final String driverEmail;
  final LoginResponse data;
  final VoidCallback onLogout;

  const HomeNavigationDrawer({
    super.key,
    required this.driverName,
    required this.driverEmail,
    required this.onLogout,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(driverName),
            accountEmail: Text(driverEmail),
            decoration: const BoxDecoration(color: AppConstants.primaryColor),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                driverName[0], // Display the first letter of the driver's name
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              context.read<HomeNavigationBloc>().add(
                    HomeMenuSelected(
                      screen: HomeViewScreen(
                        data: data,
                      ),
                      title: 'Dashboard',
                    ),
                  );
              Navigator.of(context).pop(); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Products'),
            onTap: () {
              // context.read<HomeNavigationBloc>().add(
              //   HomeMenuSelected(
              //     screen: DriverLocationScreen(
              //       driverId: data.userInfo.driver!.id,
              //     ),
              //     title: 'Products',
              //   ),
              // );
              Navigator.of(context).pop(); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
