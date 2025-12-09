import 'dart:async';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/cliente.dart';
import '../../models/dashboard_cliente.dart';
import '../../services/api_service.dart';
import '../../services/notificacion_service.dart';
import 'components/dashboard_widgets.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  final Function(int)? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> _dataFuture;
  StreamSubscription? _notifSubscription;

  @override
  void initState() {
    super.initState();
    _dataFuture = _cargarDatos();

    // Escuchar nuevas notificaciones para actualizar dashboard
    _notifSubscription = NotificacionService().nuevasAlertasStream.listen((_) {
      _recargarDatosSilenciosamente();
    });
  }

  @override
  void dispose() {
    _notifSubscription?.cancel();
    super.dispose();
  }

  Future<void> _recargarDatosSilenciosamente() async {
    if (!mounted) return;
    setState(() {
      _dataFuture = _cargarDatos();
    });
  }

  Future<Map<String, dynamic>> _cargarDatos() async {
    final api = ApiService();
    final cliente = await api.obtenerPerfil();
    final dashboard = await api.obtenerDashboardCliente();
    return {
      'cliente': cliente,
      'dashboard': dashboard,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
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
                        "Error al cargar el dashboard",
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
                            _dataFuture = _cargarDatos();
                          });
                        },
                        child: const Text("Reintentar"),
                      ),
                    ],
                  ),
                ),
              );
            }

            final cliente = snapshot.data!['cliente'] as Cliente;
            final dashboard = snapshot.data!['dashboard'] as DashboardCliente;

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _dataFuture = _cargarDatos();
                });
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    WelcomeBanner(cliente: cliente),
                    // Alerta de mora si existe
                    AlertaMoraCard(resumen: dashboard.planPagos.resumen),
                    if (dashboard.planPagos.resumen.cuotasVencidas > 0)
                      const SizedBox(height: 16),
                    // Próxima cuota a pagar
                    ProximaCuotaCard(
                        proximaCuota: dashboard.planPagos.proximaCuota),
                    const SizedBox(height: 20),
                    // Resumen general
                    ResumenCards(
                      dashboard: dashboard,
                      onNavigateToTab: widget.onNavigateToTab,
                    ),
                    const SizedBox(height: 20),
                    // Último pago
                    UltimoPagoCard(ultimoPago: dashboard.planPagos.ultimoPago),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
