import 'package:flutter/material.dart';

import 'components/profile_menu.dart';
import 'components/profile_pic.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/screens/account/account_info_screen.dart';
import 'package:shop_app/services/api_service.dart';
import 'package:shop_app/models/cliente.dart';
import 'package:shop_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Cliente> _clienteFuture;

  @override
  void initState() {
    super.initState();
    _clienteFuture = ApiService().obtenerPerfil();
  }

  String _obtenerNombreCompleto(Cliente cliente) {
    final partes = <String>[];
    partes.add(cliente.nombre);
    if (cliente.apellidoPaterno != null &&
        cliente.apellidoPaterno!.isNotEmpty) {
      partes.add(cliente.apellidoPaterno!);
    }
    if (cliente.apellidoMaterno != null &&
        cliente.apellidoMaterno!.isNotEmpty) {
      partes.add(cliente.apellidoMaterno!);
    }
    return partes.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Perfil",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<Cliente>(
        future: _clienteFuture,
        builder: (context, snapshot) {
          String inicial = "?";
          String nombreCompleto = "Cargando...";

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            );
          }

          if (snapshot.hasData) {
            final cliente = snapshot.data!;
            inicial = cliente.nombre.isNotEmpty ? cliente.nombre[0] : "?";
            nombreCompleto = _obtenerNombreCompleto(cliente);
          } else if (snapshot.hasError) {
            inicial = "!";
            nombreCompleto = "Error al cargar";
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                ProfilePic(
                  inicial: inicial,
                  nombreCompleto: nombreCompleto,
                ),
                const SizedBox(height: 20),
                ProfileMenu(
                  text: "Mi Cuenta",
                  icon: "assets/icons/User Icon.svg",
                  press: () {
                    Navigator.pushNamed(context, AccountInfoScreen.routeName);
                  },
                ),
                /*ProfileMenu(
                  text: "Notificaciones",
                  icon: "assets/icons/Bell.svg",
                  press: () {},
                ),
                
                ProfileMenu(
                  text: "Configuración",
                  icon: "assets/icons/Settings.svg",
                  press: () {},
                ),
                ProfileMenu(
                  text: "Centro de Ayuda",
                  icon: "assets/icons/Question mark.svg",
                  press: () {},
                ),*/
                ProfileMenu(
                  text: "Cerrar Sesión",
                  icon: "assets/icons/Log out.svg",
                  press: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove("access");
                    await prefs.remove("refresh");

                    // Navegar directamente al login y borrar historial
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      SignInScreen.routeName,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
