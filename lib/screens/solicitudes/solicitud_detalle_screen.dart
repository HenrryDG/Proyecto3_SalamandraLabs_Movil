import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../models/solicitud.dart';
import '../../services/api_service.dart';

class SolicitudDetalleScreen extends StatefulWidget {
  static String routeName = "/solicitud_detalle";

  const SolicitudDetalleScreen({super.key});

  @override
  State<SolicitudDetalleScreen> createState() => _SolicitudDetalleScreenState();
}

class _SolicitudDetalleScreenState extends State<SolicitudDetalleScreen> {
  late Future<Solicitud> _solicitudFuture;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final solicitudId = ModalRoute.of(context)!.settings.arguments as int;
      _solicitudFuture = ApiService().obtenerSolicitudDetalle(solicitudId);
      _initialized = true;
    }
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

  String _formatearFecha(String? fecha) {
    if (fecha == null) return 'No disponible';
    try {
      final DateTime parsedDate = DateTime.parse(fecha);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return fecha;
    }
  }

  String _formatearMonto(double? monto) {
    if (monto == null) return 'No disponible';
    final formatter = NumberFormat('#,##0.00', 'es_BO');
    return 'Bs. ${formatter.format(monto)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de Solicitud"),
      ),
      body: SafeArea(
        child: FutureBuilder<Solicitud>(
          future: _solicitudFuture,
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
                        "Error al cargar el detalle",
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
                          Navigator.pop(context);
                        },
                        child: const Text("Volver"),
                      ),
                    ],
                  ),
                ),
              );
            }

            final solicitud = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado con ID y estado
                  _buildHeader(solicitud),
                  const SizedBox(height: 24),

                  // Sección de montos
                  const Text(
                    "Información del Préstamo",
                    style: headingStyle,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.attach_money,
                      "Monto Solicitado",
                      _formatearMonto(solicitud.montoSolicitado),
                    ),
                    if (solicitud.montoAprobado != null)
                      _buildInfoRow(
                        Icons.check_circle_outline,
                        "Monto Aprobado",
                        _formatearMonto(solicitud.montoAprobado),
                      ),
                    if (solicitud.plazoMeses != null)
                      _buildInfoRow(
                        Icons.calendar_month,
                        "Plazo",
                        "${solicitud.plazoMeses} meses",
                      ),
                  ]),
                  const SizedBox(height: 24),

                  // Sección de fechas
                  const Text(
                    "Fechas",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.calendar_today,
                      "Fecha de Solicitud",
                      _formatearFecha(solicitud.fechaSolicitud),
                    ),
                    if (solicitud.fechaAprobacion != null)
                      _buildInfoRow(
                        Icons.event_available,
                        "Fecha de Aprobación",
                        _formatearFecha(solicitud.fechaAprobacion),
                      ),
                    if (solicitud.fechaPlazo != null)
                      _buildInfoRow(
                        Icons.event,
                        "Fecha Límite",
                        _formatearFecha(solicitud.fechaPlazo),
                      ),
                  ]),
                  const SizedBox(height: 24),

                  // Propósito
                  const Text(
                    "Propósito",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6F9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      solicitud.proposito,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Observaciones (si existen)
                  if (solicitud.observaciones != null &&
                      solicitud.observaciones!.isNotEmpty) ...[
                    const Text(
                      "Observaciones",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6F9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        solicitud.observaciones!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Documentos (si existen)
                  if (solicitud.documentos.isNotEmpty) ...[
                    const Text(
                      "Documentos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...solicitud.documentos.map(
                      (doc) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6F9),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.description,
                                color: kPrimaryColor,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  doc.tipoDocumento,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(Solicitud solicitud) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: _getEstadoColor(solicitud.estado).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            solicitud.estado,
            style: TextStyle(
              color: _getEstadoColor(solicitud.estado),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: kPrimaryColor,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: kSecondaryColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
