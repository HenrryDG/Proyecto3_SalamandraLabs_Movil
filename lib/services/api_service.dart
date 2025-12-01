import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cliente.dart';
import '../models/solicitud.dart';
import '../models/prestamo.dart';
import '../models/notificacion.dart';
import '../models/dashboard_cliente.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // URL base de tu API (ajusta según tu IP/host)
  // final String baseUrl = 'http://192.168.0.15:8000/api/clientes/';

  final String baseUrl = 'https://api-esetel.vercel.app/api/clientes/';
  final String baseUrlLogin = 'https://api-esetel.vercel.app/api/login/';
  final String baseUrlPerfil =
      'https://api-esetel.vercel.app/api/clientes/perfil/';
  final String baseUrlSolicitudes =
      'https://api-esetel.vercel.app/api/cliente/';

  /// Obtener el perfil del cliente autenticado (GET)
  Future<Cliente> obtenerPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access");

    if (accessToken == null) {
      throw Exception('No hay token de acceso');
    }

    final response = await http.get(
      Uri.parse(baseUrlPerfil),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Cliente.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada');
    } else {
      throw Exception('Error al obtener perfil: ${response.body}');
    }
  }

  /// Obtener las solicitudes del cliente autenticado (GET)
  Future<List<Solicitud>> obtenerSolicitudesCliente() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access");

    if (accessToken == null) {
      throw Exception('No hay token de acceso');
    }

    // Primero obtenemos el perfil para obtener el ID del cliente
    final cliente = await obtenerPerfil();

    if (cliente.id == null) {
      throw Exception('No se pudo obtener el ID del cliente');
    }

    final response = await http.get(
      Uri.parse('${baseUrlSolicitudes}${cliente.id}/solicitudes/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Solicitud.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada');
    } else {
      throw Exception('Error al obtener solicitudes: ${response.body}');
    }
  }

  /// Obtener el detalle de una solicitud específica (GET)
  Future<Solicitud> obtenerSolicitudDetalle(int solicitudId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access");

    if (accessToken == null) {
      throw Exception('No hay token de acceso');
    }

    final response = await http.get(
      Uri.parse('https://api-esetel.vercel.app/api/solicitudes/$solicitudId/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Solicitud.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada');
    } else {
      throw Exception(
          'Error al obtener detalle de solicitud: ${response.body}');
    }
  }

  /// Registrar cliente (POST)
  /// Recibe un objeto Cliente y los campos username y password
  Future<void> registrarCliente({
    required Cliente cliente,
    required String username,
    required String password,
  }) async {
    final jsonBody = json.encode(cliente.toJson(
      username: username,
      password: password,
    ));

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    if (response.statusCode != 201) {
      // Captura errores de la API
      throw Exception('Error al registrar cliente: ${response.body}');
    }
    // Si llega aquí, se registró correctamente
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrlLogin),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("access", data["access"]);
      await prefs.setString("refresh", data["refresh"]);

      return true; // login OK
    } else {
      return false; // credenciales incorrectas
    }
  }

  /// Obtener los préstamos del cliente autenticado (GET)
  Future<List<Prestamo>> obtenerPrestamosCliente() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access");

    if (accessToken == null) {
      throw Exception('No hay token de acceso');
    }

    // Primero obtenemos el perfil para obtener el ID del cliente
    final cliente = await obtenerPerfil();

    if (cliente.id == null) {
      throw Exception('No se pudo obtener el ID del cliente');
    }

    final response = await http.get(
      Uri.parse('${baseUrlSolicitudes}${cliente.id}/prestamos/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Prestamo.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada');
    } else {
      throw Exception('Error al obtener préstamos: ${response.body}');
    }
  }

  /// Obtener el plan de pagos de un préstamo específico (GET)
  Future<List<PlanPago>> obtenerPlanPagos(int prestamoId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access");

    if (accessToken == null) {
      throw Exception('No hay token de acceso');
    }

    final response = await http.get(
      Uri.parse(
          'https://api-esetel.vercel.app/api/prestamos/$prestamoId/plan-pagos/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PlanPago.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada');
    } else {
      throw Exception('Error al obtener plan de pagos: ${response.body}');
    }
  }

  // =========================================================================
  // NOTIFICACIONES
  // =========================================================================

  final String baseUrlNotificaciones =
      'https://api-esetel.vercel.app/api/notificaciones/';

  /// Obtener todas las notificaciones del cliente autenticado (GET)
  Future<List<Notificacion>> obtenerMisNotificaciones() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access");

    if (accessToken == null) {
      throw Exception('No hay token de acceso');
    }

    final response = await http.get(
      Uri.parse('${baseUrlNotificaciones}mis-notificaciones/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> notificaciones = data['notificaciones'] ?? [];
      return notificaciones.map((json) => Notificacion.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada');
    } else {
      throw Exception('Error al obtener notificaciones: ${response.body}');
    }
  }

  /// Obtener alertas emergentes del cliente autenticado (GET)
  Future<List<Notificacion>> obtenerMisAlertas() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access");

    if (accessToken == null) {
      throw Exception('No hay token de acceso');
    }

    final response = await http.get(
      Uri.parse('${baseUrlNotificaciones}mis-alertas/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> alertas = data['alertas'] ?? [];
      return alertas.map((json) => Notificacion.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada');
    } else {
      throw Exception('Error al obtener alertas: ${response.body}');
    }
  }

  /// Obtener historial de notificaciones del cliente autenticado (GET)
  Future<List<Notificacion>> obtenerMiHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access");

    if (accessToken == null) {
      throw Exception('No hay token de acceso');
    }

    final response = await http.get(
      Uri.parse('${baseUrlNotificaciones}mi-historial/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> notificaciones = data['notificaciones'] ?? [];
      return notificaciones.map((json) => Notificacion.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada');
    } else {
      throw Exception('Error al obtener historial: ${response.body}');
    }
  }

  /// Obtener resumen de notificaciones del cliente autenticado (GET)
  Future<ResumenNotificaciones> obtenerResumenNotificaciones() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access");

    if (accessToken == null) {
      throw Exception('No hay token de acceso');
    }

    final response = await http.get(
      Uri.parse('${baseUrlNotificaciones}mi-resumen/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ResumenNotificaciones.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada');
    } else {
      throw Exception('Error al obtener resumen: ${response.body}');
    }
  }

  // =========================================================================
  // DASHBOARD CLIENTE
  // =========================================================================

  final String baseUrlDashboard = 'https://api-esetel.vercel.app/api/';

  /// Obtener el dashboard completo del cliente autenticado (GET)
  Future<DashboardCliente> obtenerDashboardCliente() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access");

    if (accessToken == null) {
      throw Exception('No hay token de acceso');
    }

    // Primero obtenemos el perfil para obtener el ID del cliente
    final cliente = await obtenerPerfil();

    if (cliente.id == null) {
      throw Exception('No se pudo obtener el ID del cliente');
    }

    final response = await http.get(
      Uri.parse('${baseUrlDashboard}dashboard/cliente/${cliente.id}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DashboardCliente.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada');
    } else {
      throw Exception('Error al obtener dashboard: ${response.body}');
    }
  }
}
