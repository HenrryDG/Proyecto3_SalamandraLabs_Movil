import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../models/notificacion.dart';
import '../../services/api_service.dart';

class NotificacionesScreen extends StatefulWidget {
  static String routeName = "/notificaciones";

  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  late Future<List<Notificacion>> _notificacionesFuture;

  @override
  void initState() {
    super.initState();
    _notificacionesFuture = ApiService().obtenerMisNotificaciones();
  }

  Color _getEstiloColor(String estilo) {
    switch (estilo) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'error':
        return Colors.red;
      case 'reminder':
        return Colors.purple;
      case 'info':
      default:
        return kPrimaryColor;
    }
  }

  IconData _getEstiloIcon(String estilo) {
    switch (estilo) {
      case 'success':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning_amber;
      case 'error':
        return Icons.error;
      case 'reminder':
        return Icons.alarm;
      case 'info':
      default:
        return Icons.info;
    }
  }

  IconData _getTipoIcon(String tipo) {
    if (tipo.contains('solicitud')) {
      return Icons.description;
    } else if (tipo.contains('prestamo')) {
      return Icons.account_balance;
    } else if (tipo.contains('cuota') || tipo.contains('pago')) {
      return Icons.payments;
    } else if (tipo.contains('mora')) {
      return Icons.warning;
    }
    return Icons.notifications;
  }

  String _formatearFecha(String fecha) {
    try {
      final DateTime parsedDate = DateTime.parse(fecha);
      final now = DateTime.now();
      final difference = now.difference(parsedDate);

      if (difference.inMinutes < 60) {
        return 'Hace ${difference.inMinutes} min';
      } else if (difference.inHours < 24) {
        return 'Hace ${difference.inHours} horas';
      } else if (difference.inDays < 7) {
        return 'Hace ${difference.inDays} días';
      } else {
        return DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);
      }
    } catch (e) {
      return fecha;
    }
  }

  String _getPrioridadLabel(String prioridad) {
    switch (prioridad) {
      case 'urgente':
        return 'URGENTE';
      case 'alta':
        return 'ALTA';
      case 'media':
        return 'MEDIA';
      case 'baja':
        return 'BAJA';
      default:
        return prioridad.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificaciones"),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Notificacion>>(
          future: _notificacionesFuture,
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
                        "Error al cargar las notificaciones",
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
                            _notificacionesFuture =
                                ApiService().obtenerMisNotificaciones();
                          });
                        },
                        child: const Text("Reintentar"),
                      ),
                    ],
                  ),
                ),
              );
            }

            final notificaciones = snapshot.data!;

            if (notificaciones.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        color: kSecondaryColor,
                        size: 80,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Sin notificaciones",
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "No tienes notificaciones en este momento",
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
                  _notificacionesFuture =
                      ApiService().obtenerMisNotificaciones();
                });
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notificaciones.length,
                itemBuilder: (context, index) {
                  final notificacion = notificaciones[index];
                  return _NotificacionCard(
                    notificacion: notificacion,
                    formatearFecha: _formatearFecha,
                    getEstiloColor: _getEstiloColor,
                    getEstiloIcon: _getEstiloIcon,
                    getTipoIcon: _getTipoIcon,
                    getPrioridadLabel: _getPrioridadLabel,
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

class _NotificacionCard extends StatelessWidget {
  final Notificacion notificacion;
  final String Function(String) formatearFecha;
  final Color Function(String) getEstiloColor;
  final IconData Function(String) getEstiloIcon;
  final IconData Function(String) getTipoIcon;
  final String Function(String) getPrioridadLabel;

  const _NotificacionCard({
    required this.notificacion,
    required this.formatearFecha,
    required this.getEstiloColor,
    required this.getEstiloIcon,
    required this.getTipoIcon,
    required this.getPrioridadLabel,
  });

  @override
  Widget build(BuildContext context) {
    final color = getEstiloColor(notificacion.estilo);
    final esUrgente = notificacion.esUrgente;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F9),
          borderRadius: BorderRadius.circular(15),
          border: esUrgente
              ? Border.all(color: Colors.red.withOpacity(0.5), width: 2)
              : Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado: Ícono + Título + Prioridad
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ícono del estilo
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    getEstiloIcon(notificacion.estilo),
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Título y tipo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notificacion.titulo,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            getTipoIcon(notificacion.tipo),
                            size: 14,
                            color: kSecondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatearFecha(notificacion.fechaGeneracion),
                            style: TextStyle(
                              fontSize: 12,
                              color: kSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Badge de prioridad
                if (notificacion.esAlta)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: esUrgente
                          ? Colors.red.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      getPrioridadLabel(notificacion.prioridad),
                      style: TextStyle(
                        color: esUrgente ? Colors.red : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Mensaje
            Text(
              notificacion.mensaje,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            // Datos extra si existen
            if (notificacion.datosExtra.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildDatosExtra(notificacion.datosExtra, color),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDatosExtra(Map<String, dynamic> datos, Color color) {
    final widgets = <Widget>[];

    // Monto
    if (datos['monto'] != null) {
      widgets.add(_buildDatoItem(
        Icons.attach_money,
        'Monto: Bs ${datos['monto']}',
        color,
      ));
    }

    // Monto cuota
    if (datos['monto_cuota'] != null) {
      widgets.add(_buildDatoItem(
        Icons.payments,
        'Cuota: Bs ${datos['monto_cuota']}',
        color,
      ));
    }

    // Mora
    if (datos['mora'] != null && datos['mora'] > 0) {
      widgets.add(_buildDatoItem(
        Icons.warning,
        'Mora: Bs ${datos['mora']}',
        Colors.red,
      ));
    }

    // Días de atraso
    if (datos['dias_atraso'] != null && datos['dias_atraso'] > 0) {
      widgets.add(_buildDatoItem(
        Icons.schedule,
        '${datos['dias_atraso']} días de atraso',
        Colors.red,
      ));
    }

    // Fecha vencimiento
    if (datos['fecha_vencimiento'] != null) {
      widgets.add(_buildDatoItem(
        Icons.event,
        'Vence: ${datos['fecha_vencimiento']}',
        kSecondaryColor,
      ));
    }

    // Número de cuota
    if (datos['numero_cuota'] != null) {
      widgets.add(_buildDatoItem(
        Icons.tag,
        'Cuota #${datos['numero_cuota']}',
        kSecondaryColor,
      ));
    }

    if (widgets.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: widgets,
    );
  }

  Widget _buildDatoItem(IconData icon, String texto, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          texto,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
