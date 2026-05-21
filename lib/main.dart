import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_theme.dart';
import 'package:food_delivery/core/routes/app_routes.dart';
import 'package:food_delivery/di/dependency_injection_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main() async{
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_PROJECT_URL']!,
    anonKey: dotenv.env['SUPABASE_PUBLISHER_KEY']!,
  );
  DependencyInjectionContainer.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.getRoutes(),
    );
  }
}
