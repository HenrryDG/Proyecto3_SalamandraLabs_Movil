import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/screens/sign_in/auth_wrapper.dart';
import 'package:shop_app/services/notificacion_service.dart';
import 'constants.dart';
import 'routes.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  // Inicializar notificaciones
  await NotificacionService().init();

  // Verificar si la app fue cerrada completamente
  // Si la bandera 'app_running' no existe o es false, significa que la app
  // fue cerrada y debemos limpiar la sesión
  final appWasRunning = prefs.getBool('app_running') ?? false;

  if (!appWasRunning) {
    // La app fue cerrada, limpiar tokens
    await prefs.remove('access');
    await prefs.remove('refresh');
  }

  // Marcar que la app está corriendo
  await prefs.setBool('app_running', true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Iniciar polling si hay sesión (esto se maneja mejor en AuthWrapper o LoginSuccess,
    // pero para asegurar que arranque si ya estaba logueado:
    _checkSessionAndStartPolling();
  }

  void _checkSessionAndStartPolling() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('access') != null) {
      NotificacionService().iniciarPolling();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    final prefs = await SharedPreferences.getInstance();

    if (state == AppLifecycleState.paused) {
      // App va a segundo plano - marcar como no corriendo
      // Si la app es cerrada desde aquí, al reiniciar detectará que no estaba corriendo
      await prefs.setBool('app_running', false);
    } else if (state == AppLifecycleState.resumed) {
      // App vuelve del segundo plano - marcar como corriendo
      await prefs.setBool('app_running', true);
      // Refrescar notificaciones al volver
      NotificacionService().actualizarAhora();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'ESETEL',
      theme: AppTheme.lightTheme(context),
      initialRoute: AuthWrapper.routeName,
      routes: routes,
    );
  }
}
