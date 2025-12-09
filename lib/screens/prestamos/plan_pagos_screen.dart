import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../models/prestamo.dart';
import '../../services/api_service.dart';

class PlanPagosScreen extends StatefulWidget {
  static String routeName = "/plan-pagos";

  const PlanPagosScreen({super.key});

  @override
  State<PlanPagosScreen> createState() => _PlanPagosScreenState();
}

class _PlanPagosScreenState extends State<PlanPagosScreen> {
  late Future<List<PlanPago>> _planPagosFuture;
  int? _prestamoId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;

    if (_prestamoId == null) {
      if (args is Prestamo) {
        _prestamoId = args.id;
      } else if (args is int) {
        _prestamoId = args;
      }

      if (_prestamoId != null) {
        _planPagosFuture = ApiService().obtenerPlanPagos(_prestamoId!);
      }
    }
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'Pagada':
        return Colors.green;
      case 'Vencida':
        return Colors.red;
      case 'Pendiente':
      default:
        return Colors.orange;
    }
  }

  String _formatearFecha(String? fecha) {
    if (fecha == null) return '-';
    try {
      final DateTime parsedDate = DateTime.parse(fecha);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return fecha;
    }
  }

  String _formatearFechaHora(String? fecha) {
    if (fecha == null) return '-';
    try {
      final DateTime parsedDate = DateTime.parse(fecha);
      return DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);
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
        title: const Text("Plan de Pagos"),
      ),
      body: SafeArea(
        child: _prestamoId == null
            ? const Center(child: Text("No se encontró el préstamo"))
            : FutureBuilder<List<PlanPago>>(
                future: _planPagosFuture,
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
                              "Error al cargar el plan de pagos",
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
                                  _planPagosFuture = ApiService()
                                      .obtenerPlanPagos(_prestamoId!);
                                });
                              },
                              child: const Text("Reintentar"),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final planPagos = snapshot.data!;

                  if (planPagos.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_note_outlined,
                              color: kSecondaryColor,
                              size: 80,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Sin cuotas",
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "No hay cuotas registradas para este préstamo",
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
                        _planPagosFuture =
                            ApiService().obtenerPlanPagos(_prestamoId!);
                      });
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: planPagos.length,
                      itemBuilder: (context, index) {
                        final cuota = planPagos[index];
                        return _CuotaCard(
                          cuota: cuota,
                          numeroCuota: index + 1,
                          formatearFecha: _formatearFecha,
                          formatearFechaHora: _formatearFechaHora,
                          formatearMonto: _formatearMonto,
                          getEstadoColor: _getEstadoColor,
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

class _CuotaCard extends StatelessWidget {
  final PlanPago cuota;
  final int numeroCuota;
  final String Function(String?) formatearFecha;
  final String Function(String?) formatearFechaHora;
  final String Function(double) formatearMonto;
  final Color Function(String) getEstadoColor;

  const _CuotaCard({
    required this.cuota,
    required this.numeroCuota,
    required this.formatearFecha,
    required this.formatearFechaHora,
    required this.formatearMonto,
    required this.getEstadoColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F9),
          borderRadius: BorderRadius.circular(15),
          border: cuota.estado == 'Vencido'
              ? Border.all(color: Colors.red.withOpacity(0.5), width: 1)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cuota $numeroCuota",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getEstadoColor(cuota.estado).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    cuota.estado,
                    style: TextStyle(
                      color: getEstadoColor(cuota.estado),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Monto cuota
            Row(
              children: [
                const Icon(
                  Icons.payments_outlined,
                  size: 18,
                  color: kPrimaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  "Cuota: ${formatearMonto(cuota.montoCuota)}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // Mora (si existe)
            if (cuota.moraCuota > 0) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.warning_amber_outlined,
                    size: 18,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Mora: ${formatearMonto(cuota.moraCuota)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    size: 18,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Total: ${formatearMonto(cuota.montoTotal)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            // Fecha vencimiento
            Row(
              children: [
                const Icon(
                  Icons.event,
                  size: 18,
                  color: kSecondaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  "Vence: ${formatearFecha(cuota.fechaVencimiento)}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: kSecondaryColor,
                  ),
                ),
              ],
            ),
            // Fecha de pago (si existe)
            if (cuota.fechaPago != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Pagado: ${formatearFecha(cuota.fechaPago)}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
            // Método de pago (si existe)
            if (cuota.metodoPago != null && cuota.metodoPago!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.payment,
                    size: 18,
                    color: kSecondaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Método: ${cuota.metodoPago}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: kSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
