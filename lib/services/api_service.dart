import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cliente.dart';

class ApiService {
  // URL base de tu API (ajusta según tu IP/host)
  // final String baseUrl = 'http://192.168.0.15:8000/api/clientes/';

  final String baseUrl = 'https://api-esetel.vercel.app/api/clientes/';

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
}
