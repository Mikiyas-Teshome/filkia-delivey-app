import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/services/auth_service.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/models/login_response.dart';
import '../blocs/home_navigation/home_navigation_bloc.dart';
import '../widgets/home_navigation_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<LoginResponse?> Data;

  @override
  void initState() {
    super.initState();
    Data = AuthService().getAuthData();
  }

  void _logout() async {
    final authService = AuthService();
    await authService.clearAuthData();
    await authService.setLoggedIn(false);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<HomeNavigationBloc, HomeNavigationState>(
          builder: (context, state) {
            if (state is HomeNavigationLoaded) {
              return Text(state.title);
            }
            return const Text(' Dashboard');
          },
        ),
      ),
      drawer: FutureBuilder<LoginResponse?>(
        future: Data,
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

          final Info = snapshot.data!;
          return HomeNavigationDrawer(
            driverName: Info.userInfo.firstName + ' ' + Info.userInfo.lastName,
            driverEmail: Info.userInfo.email,
            data: Info,
            onLogout: _logout,
          );
        },
      ),
      body: BlocBuilder<HomeNavigationBloc, HomeNavigationState>(
        builder: (context, state) {
          if (state is HomeNavigationLoaded) {
            return state.screen;
          }
          return const Center(child: Text('Welcome to the  App!'));
        },
      ),
    );
  }
}
