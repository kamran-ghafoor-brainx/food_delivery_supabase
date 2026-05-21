import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/screens/auth/login_screen.dart';
import 'package:food_delivery/presentation/screens/auth/signup_screen.dart';
import 'package:food_delivery/presentation/screens/main/main_shell.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
      main: (context) => const MainShell(),
    };
  }
}
