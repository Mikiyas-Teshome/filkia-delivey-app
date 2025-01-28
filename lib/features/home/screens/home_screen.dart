import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
        child: BlocBuilder<HomeNavigationBloc, HomeNavigationState>(
          builder: (context, state) {
            if (state is HomeNavigationLoaded) {
              return state.screen;
            }
            return Column(children: [
              const SizedBox(
                height: 10,
              ),
              //custom app bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, size: 30),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  const Spacer(),
                  const Center(
                      child: Text(
                    ' Dashboard',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  const Spacer(),
                ]),
              ),
              //available balance card
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 150,
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
                          'assets/images/logo.svg',
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ]),
              ),
              //status cards
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  crossAxisCount: 2,
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
                  text: "Cancelled",
                  color: Colors.red,
                  amount: 20,
                ),
                DeliveryStatusCardWidget(
                  text: "Ongoing",
                  color: Colors.blue,
                  amount: 20,
                ),
              ])
            ]);
          },
        ),
      ),
    );
  }
}

class DeliveryStatusCardWidget extends StatelessWidget {
  const DeliveryStatusCardWidget({
    super.key,
    required this.color,
    required this.text,
    required this.amount,
  });
  final Color color;
  final String text;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: color.withValues(alpha: 0.2),
      leading: Icon(Icons.delivery_dining, color: color),
      title: Text("$text Deliveries"),
      subtitle: Text(amount.toString()),
    );
  }
}
