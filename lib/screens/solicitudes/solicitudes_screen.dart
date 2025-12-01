import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../models/solicitud.dart';
import '../../services/api_service.dart';
import 'solicitud_detalle_screen.dart';

class SolicitudesScreen extends StatefulWidget {
  static String routeName = "/solicitudes";

  const SolicitudesScreen({super.key});

  @override
  State<SolicitudesScreen> createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen> {
  late Future<List<Solicitud>> _solicitudesFuture;

  @override
  void initState() {
    super.initState();
    _solicitudesFuture = ApiService().obtenerSolicitudesCliente();
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'Aprobada':
        return Colors.green;
      case 'Rechazada':
        return Colors.red;
      case 'Pendiente':
      default:
        return Colors.orange;
    }
  }

  String _formatearFecha(String fecha) {
    try {
      final DateTime parsedDate = DateTime.parse(fecha);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return fecha;
    }
  }

  String _formatearMonto(double monto) {
    final formatter = NumberFormat('#,##0.00', 'es_BO');
    return 'Bs. ${formatter.format(monto)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mis Solicitudes",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Solicitud>>(
          future: _solicitudesFuture,
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
                        "Error al cargar las solicitudes",
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
                            _solicitudesFuture =
                                ApiService().obtenerSolicitudesCliente();
                          });
                        },
                        child: const Text("Reintentar"),
                      ),
                    ],
                  ),
                ),
              );
            }

            final solicitudes = snapshot.data!;

            if (solicitudes.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        color: kSecondaryColor,
                        size: 80,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No tienes solicitudes",
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Aún no has realizado ninguna solicitud de préstamo",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _solicitudesFuture = ApiService().obtenerSolicitudesCliente();
                });
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: solicitudes.length,
                itemBuilder: (context, index) {
                  final solicitud = solicitudes[index];
                  return _SolicitudCard(
                    solicitud: solicitud,
                    formatearFecha: _formatearFecha,
                    formatearMonto: _formatearMonto,
                    getEstadoColor: _getEstadoColor,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        SolicitudDetalleScreen.routeName,
                        arguments: solicitud.id,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SolicitudCard extends StatelessWidget {
  final Solicitud solicitud;
  final String Function(String) formatearFecha;
  final String Function(double) formatearMonto;
  final Color Function(String) getEstadoColor;
  final VoidCallback onTap;

  const _SolicitudCard({
    required this.solicitud,
    required this.formatearFecha,
    required this.formatearMonto,
    required this.getEstadoColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      solicitud.proposito,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: getEstadoColor(solicitud.estado).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      solicitud.estado,
                      style: TextStyle(
                        color: getEstadoColor(solicitud.estado),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.attach_money,
                    size: 18,
                    color: kPrimaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatearMonto(solicitud.montoSolicitado),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: kSecondaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formatearFecha(solicitud.fechaSolicitud),
                          style: const TextStyle(
                            fontSize: 14,
                            color: kSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: kSecondaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
