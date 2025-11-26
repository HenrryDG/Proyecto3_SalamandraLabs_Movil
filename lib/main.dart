import 'package:flutter/material.dart';
import 'package:shop_app/screens/sign_in/auth_wrapper.dart';
import 'routes.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Flutter Way - Template',
      theme: AppTheme.lightTheme(context),
      initialRoute: AuthWrapper.routeName, // <-- Cambiado aquí
      routes: routes,
    );
  }
}
