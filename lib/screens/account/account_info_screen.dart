import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/cliente.dart';
import '../../services/api_service.dart';
import 'components/account_info_item.dart';
import 'components/account_info_row.dart';

class AccountInfoScreen extends StatefulWidget {
  static String routeName = "/account_info";

  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  late Future<Cliente> _clienteFuture;

  @override
  void initState() {
    super.initState();
    _clienteFuture = ApiService().obtenerPerfil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mi Cuenta",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<Cliente>(
          future: _clienteFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Error al cargar la información",
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.error.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _clienteFuture = ApiService().obtenerPerfil();
                          });
                        },
                        child: const Text("Reintentar"),
                      ),
                    ],
                  ),
                ),
              );
            }

            final cliente = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Información Personal",
                    style: headingStyle,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Datos de tu cuenta",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  AccountInfoItem(
                    icon: "assets/icons/User.svg",
                    label: "Usuario",
                    value: cliente.user ?? "No disponible",
                  ),
                  AccountInfoRow(
                    icon: "assets/icons/Carnet.svg",
                    label1: "Carnet",
                    value1: cliente.carnet,
                    label2: "Complemento",
                    value2: cliente.complemento ?? "S/C",
                  ),
                  AccountInfoItem(
                    icon: "assets/icons/User.svg",
                    label: "Nombre",
                    value: cliente.nombre,
                  ),
                  AccountInfoRow(
                    icon: "assets/icons/User.svg",
                    label1: "A. Paterno",
                    value1: cliente.apellidoPaterno ?? "No especificado",
                    label2: "A. Materno",
                    value2: cliente.apellidoMaterno ?? "No especificado",
                  ),
                  AccountInfoItem(
                    icon: "assets/icons/Briefcase.svg",
                    label: "Lugar de Trabajo",
                    value: cliente.lugarTrabajo,
                  ),
                  AccountInfoItem(
                    icon: "assets/icons/Employee.svg",
                    label: "Ocupación",
                    value: cliente.tipoTrabajo,
                  ),
                  AccountInfoItem(
                    icon: "assets/icons/Location point.svg",
                    label: "Dirección",
                    value: cliente.direccion,
                  ),
                  AccountInfoItem(
                    icon: "assets/icons/Email.svg",
                    label: "Correo",
                    value: cliente.correo ?? "No especificado",
                  ),
                  AccountInfoItem(
                    icon: "assets/icons/Cellphone.svg",
                    label: "Teléfono",
                    value: cliente.telefono.toString(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
