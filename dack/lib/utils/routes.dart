import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screen/home_screen.dart';
import '../screen/login_screen.dart';
import '../screen/profile_screen.dart';
import '../screen/seatselection_screen.dart';
import '../screen/signup_screen.dart';
import '../screen/splash_screen.dart';

class Routes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String profile = '/profile';
  static const String seatSelection = '/seatSelection';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case home:
        final currentUser = FirebaseAuth.instance.currentUser;
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case profile:
        if (settings.arguments is User) {
          final user = settings.arguments as User;
          return MaterialPageRoute(builder: (_) => ProfileScreen(user: user));
        }
        return _errorRoute('Invalid arguments for ProfileScreen');
      case seatSelection:
        final time = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => SeatSelectionScreen(time: time));
      default:
        return _errorRoute('Page not found');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
