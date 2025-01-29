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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<LoginResponse?> data;

  @override
  void initState() {
    super.initState();
    data = AuthService().getAuthData();
  }

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
    return Scaffold(
      // appBar: AppBar(
      //   title: BlocBuilder<HomeNavigationBloc, HomeNavigationState>(
      //     builder: (context, state) {
      //       if (state is HomeNavigationLoaded) {
      //         return Text(state.title);
      //       }
      //       return const Text(' Dashboard');
      //     },
      //   ),
      // ),
      drawer: FutureBuilder<LoginResponse?>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Drawer(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Drawer(
              child: Center(child: Text('Failed to load  data')),
            );
          }

          final info = snapshot.data!;
          return HomeNavigationDrawer(
            driverName: '${info.userInfo.firstName} ${info.userInfo.lastName}',
            driverEmail: info.userInfo.email,
            data: info,
            onLogout: _logout,
          );
        },
      ),
      body: SafeArea(
        child:
            BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) {
          bool isDarkTheme = themeState is DarkThemeState;

          return BlocBuilder<HomeNavigationBloc, HomeNavigationState>(
            builder: (context, state) {
              if (state is HomeNavigationLoaded) {
                return state.screen;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    //app bar
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: isDarkTheme
                            ? Colors.amber.withValues(alpha: 0.3)
                            : Colors.amber.shade100,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(35.0),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Builder(
                              builder: (context) => IconButton(
                                icon: const Icon(Icons.menu, size: 30),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              ),
                            ),
                          ),
                          const Center(
                            child: Text(
                              'Dashboard',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                    borderColor: Colors.yellow,
                                    isPending: true),
                                OrderCardWidget(borderColor: Colors.green),
                                OrderCardWidget(borderColor: Colors.red),
                                OrderCardWidget(borderColor: Colors.green),
                                OrderCardWidget(borderColor: Colors.red),
                                OrderCardWidget(
                                    borderColor: Colors.yellow,
                                    isPending: true),
                                OrderCardWidget(
                                    borderColor: Colors.yellow,
                                    isPending: true),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
