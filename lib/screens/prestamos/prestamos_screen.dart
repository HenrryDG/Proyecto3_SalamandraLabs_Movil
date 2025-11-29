import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../models/prestamo.dart';
import '../../services/api_service.dart';
import 'plan_pagos_screen.dart';

class PrestamosScreen extends StatefulWidget {
  static String routeName = "/prestamos";

  const PrestamosScreen({super.key});

  @override
  State<PrestamosScreen> createState() => _PrestamosScreenState();
}

class _PrestamosScreenState extends State<PrestamosScreen> {
  late Future<List<Prestamo>> _prestamosFuture;

  @override
  void initState() {
    super.initState();
    _prestamosFuture = ApiService().obtenerPrestamosCliente();
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'Completado':
        return Colors.green;
      case 'Mora':
        return Colors.red;
      case 'En Curso':
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

  String _formatearMonto(double monto) {
    final formatter = NumberFormat('#,##0.00', 'es_BO');
    return 'Bs. ${formatter.format(monto)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Préstamos"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Prestamo>>(
          future: _prestamosFuture,
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
                        "Error al cargar los préstamos",
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
                            _prestamosFuture =
                                ApiService().obtenerPrestamosCliente();
                          });
                        },
                        child: const Text("Reintentar"),
                      ),
                    ],
                  ),
                ),
              );
            }

            final prestamos = snapshot.data!;

            if (prestamos.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        color: kSecondaryColor,
                        size: 80,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No tienes préstamos",
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Aún no tienes préstamos activos",
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
                  _prestamosFuture = ApiService().obtenerPrestamosCliente();
                });
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: prestamos.length,
                itemBuilder: (context, index) {
                  final prestamo = prestamos[index];
                  return _PrestamoCard(
                    prestamo: prestamo,
                    formatearFecha: _formatearFecha,
                    formatearMonto: _formatearMonto,
                    getEstadoColor: _getEstadoColor,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PlanPagosScreen.routeName,
                        arguments: prestamo,
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

class _PrestamoCard extends StatelessWidget {
  final Prestamo prestamo;
  final String Function(String?) formatearFecha;
  final String Function(double) formatearMonto;
  final Color Function(String) getEstadoColor;
  final VoidCallback onTap;

  const _PrestamoCard({
    required this.prestamo,
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
              // Título: Monto aprobado + Estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      formatearMonto(prestamo.montoAprobado),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
                      color: getEstadoColor(prestamo.estado).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      prestamo.estado,
                      style: TextStyle(
                        color: getEstadoColor(prestamo.estado),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Monto restante
              Row(
                children: [
                  const Icon(
                    Icons.account_balance,
                    size: 18,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Restante: ${formatearMonto(prestamo.montoRestante)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Interés y Plazo
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.percent,
                          size: 18,
                          color: kSecondaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Interés: ${prestamo.interes}%",
                          style: const TextStyle(
                            fontSize: 14,
                            color: kSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 18,
                          color: kSecondaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Plazo: ${prestamo.plazoMeses ?? '-'} meses",
                          style: const TextStyle(
                            fontSize: 14,
                            color: kSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Fecha desembolso
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: kSecondaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Desembolso: ${formatearFecha(prestamo.fechaDesembolso)}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: kSecondaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Fecha vencimiento
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.event,
                          size: 18,
                          color: kSecondaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Vencimiento: ${formatearFecha(prestamo.fechaPlazo)}",
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
