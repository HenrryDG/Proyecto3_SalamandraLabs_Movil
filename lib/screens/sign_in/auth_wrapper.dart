import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/screens/init_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

/// AuthWrapper: revisa si existe token de acceso.
/// Si no hay token, manda al SignInScreen.
/// Si hay token, manda a InitScreen (o cualquier pantalla protegida).
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  static String routeName = "/authWrapper"; // <- necesario para routes.dart

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  String? token;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  /// Obtiene token de SharedPreferences
  Future<void> checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("access"); // <- coincide con tu login
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Si no hay token, ir a SignIn
    if (token == null) {
      return const SignInScreen();
    }

    // Si hay token, ir a InitScreen
    return const InitScreen();
  }
}
