import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

/// Widget que protege rutas que requieren autenticación.
/// Si no hay token válido, redirige al login.
class AuthGuard extends StatefulWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access");

    if (mounted) {
      setState(() {
        _isAuthenticated = token != null && token.isNotEmpty;
        _isLoading = false;
      });

      // Si no está autenticado, redirigir al login
      if (!_isAuthenticated) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          SignInScreen.routeName,
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isAuthenticated) {
      return const SizedBox.shrink();
    }

    return widget.child;
  }
}
