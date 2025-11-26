import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cliente.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // URL base de tu API (ajusta según tu IP/host)
  // final String baseUrl = 'http://192.168.0.15:8000/api/clientes/';

  final String baseUrl = 'https://api-esetel.vercel.app/api/clientes/';
  final String baseUrlLogin = 'https://api-esetel.vercel.app/api/login/';

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
}
