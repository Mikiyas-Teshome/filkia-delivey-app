import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenbil_driver_app/common/blocs/theme_bloc/theme_bloc.dart';
import 'package:zenbil_driver_app/features/home/screens/home_view_screen.dart';
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
              // return const HomeViewScreen(data: info);
              return FutureBuilder<LoginResponse?>(
                future: data,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(child: Text('Failed to load  data'));
                  }

                  final info = snapshot.data!;
                  return HomeViewScreen(
                    data: info,
                  );
                },
              );
            },
          );
        }),
      ),
    );
  }
}
