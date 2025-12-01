import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../models/dashboard_cliente.dart';
import '../../../models/cliente.dart';

/// Banner de bienvenida con el nombre del cliente
class WelcomeBanner extends StatelessWidget {
  final Cliente cliente;

  const WelcomeBanner({Key? key, required this.cliente}) : super(key: key);

  String _obtenerSaludo() {
    final hora = DateTime.now().hour;
    if (hora < 12) {
      return '¡Buenos días';
    } else if (hora < 18) {
      return '¡Buenas tardes';
    } else {
      return '¡Buenas noches';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_obtenerSaludo()}, ${cliente.nombre}!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Bienvenido a tu panel de control',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de próxima cuota a pagar
class ProximaCuotaCard extends StatelessWidget {
  final ProximaCuota? proximaCuota;

  const ProximaCuotaCard({Key? key, this.proximaCuota}) : super(key: key);

  String _formatearMonto(double monto) {
    final formatter = NumberFormat('#,##0.00', 'es_BO');
    return 'Bs. ${formatter.format(monto)}';
  }

  String _formatearFecha(String fecha) {
    try {
      final DateTime parsedDate = DateTime.parse(fecha);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return fecha;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (proximaCuota == null) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 48,
            ),
            const SizedBox(height: 12),
            const Text(
              'Sin cuotas pendientes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'No tienes pagos programados',
              style: TextStyle(
                fontSize: 14,
                color: kSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    final estaVencida = proximaCuota!.estaVencida;
    final estaProxima = proximaCuota!.estaProximaAVencer;

    Color cardColor;
    Color accentColor;
    String estadoTexto;
    IconData estadoIcon;

    if (estaVencida) {
      cardColor = Colors.red.shade50;
      accentColor = Colors.red;
      estadoTexto = 'VENCIDA';
      estadoIcon = Icons.warning;
    } else if (estaProxima) {
      cardColor = Colors.orange.shade50;
      accentColor = Colors.orange;
      estadoTexto = 'PRÓXIMA A VENCER';
      estadoIcon = Icons.access_time;
    } else {
      cardColor = const Color(0xFFF5F6F9);
      accentColor = kPrimaryColor;
      estadoTexto = 'PENDIENTE';
      estadoIcon = Icons.schedule;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(estadoIcon, color: accentColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Próximo Pago',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  estadoTexto,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Monto a pagar
          Text(
            _formatearMonto(proximaCuota!.totalAPagar),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          // Detalles
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  Icons.tag,
                  'Cuota #${proximaCuota!.numeroCuota}',
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  Icons.calendar_today,
                  _formatearFecha(proximaCuota!.fechaVencimiento),
                ),
              ),
            ],
          ),
          if (proximaCuota!.moraCuota > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Mora: ${_formatearMonto(proximaCuota!.moraCuota)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          if (estaVencida) ...[
            const SizedBox(height: 8),
            Text(
              '${proximaCuota!.diasParaVencer.abs()} días de atraso',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else if (proximaCuota!.diasParaVencer > 0) ...[
            const SizedBox(height: 8),
            Text(
              'Vence en ${proximaCuota!.diasParaVencer} días',
              style: TextStyle(
                fontSize: 13,
                color: accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: kSecondaryColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: kSecondaryColor,
          ),
        ),
      ],
    );
  }
}

/// Tarjetas de resumen rápido (solicitudes, préstamos, cuotas)
class ResumenCards extends StatelessWidget {
  final DashboardCliente dashboard;
  final Function(int)? onNavigateToTab;

  const ResumenCards({
    Key? key,
    required this.dashboard,
    this.onNavigateToTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          // Tarjeta de Préstamos con más info
          _ResumenExpandidoCard(
            title: 'Préstamos',
            icon: Icons.account_balance,
            color: kPrimaryColor,
            items: _buildPrestamosItems(),
            onTap: () {
              if (onNavigateToTab != null) {
                onNavigateToTab!(2); // Índice de Préstamos
              }
            },
          ),
          const SizedBox(height: 12),
          // Tarjeta de Solicitudes con más info
          _ResumenExpandidoCard(
            title: 'Solicitudes',
            icon: Icons.description,
            color: Colors.orange,
            items: _buildSolicitudesItems(),
            onTap: () {
              if (onNavigateToTab != null) {
                onNavigateToTab!(1); // Índice de Solicitudes
              }
            },
          ),
          const SizedBox(height: 12),
          // Tarjeta de progreso de pago
          _ProgresoCard(
            titulo: 'Progreso de Pagos',
            pagado: dashboard.planPagos.resumen.montoPagado,
            total: dashboard.planPagos.resumen.montoTotalCuotas,
            pendiente: dashboard.planPagos.resumen.montoPendiente,
            cuotasPagadas: dashboard.planPagos.resumen.cuotasPagadas,
            totalCuotas: dashboard.planPagos.resumen.totalCuotas,
          ),
        ],
      ),
    );
  }

  List<_ResumenItem> _buildPrestamosItems() {
    final items = <_ResumenItem>[];
    final p = dashboard.prestamos;

    if (p.total > 0) {
      items.add(
          _ResumenItem(label: 'Total', value: p.total, color: kPrimaryColor));
    }
    if (p.enCurso > 0) {
      items.add(_ResumenItem(
          label: 'En curso', value: p.enCurso, color: Colors.blue));
    }
    if (p.enMora > 0) {
      items.add(
          _ResumenItem(label: 'En mora', value: p.enMora, color: Colors.red));
    }
    if (p.completados > 0) {
      items.add(_ResumenItem(
          label: 'Completados', value: p.completados, color: Colors.green));
    }

    return items;
  }

  List<_ResumenItem> _buildSolicitudesItems() {
    final items = <_ResumenItem>[];
    final s = dashboard.solicitudes;

    if (s.pendientes > 0) {
      items.add(_ResumenItem(
          label: 'Pendientes', value: s.pendientes, color: Colors.orange));
    }
    if (s.aprobadas > 0) {
      items.add(_ResumenItem(
          label: 'Aprobadas', value: s.aprobadas, color: Colors.green));
    }
    if (s.rechazadas > 0) {
      items.add(_ResumenItem(
          label: 'Rechazadas', value: s.rechazadas, color: Colors.red));
    }

    return items;
  }
}

class _ResumenItem {
  final String label;
  final int value;
  final Color color;

  const _ResumenItem({
    required this.label,
    required this.value,
    required this.color,
  });
}

class _ResumenExpandidoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<_ResumenItem> items;
  final VoidCallback? onTap;

  const _ResumenExpandidoCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: kSecondaryColor),
              ],
            ),
            if (items.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: items.map((item) => _buildItemBadge(item)).toList(),
              ),
            ] else ...[
              const SizedBox(height: 12),
              Text(
                'Sin registros',
                style: TextStyle(
                  fontSize: 13,
                  color: kSecondaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItemBadge(_ResumenItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: item.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${item.value}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: item.color,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12,
              color: item.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _MiniCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: kSecondaryColor),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: kSecondaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  subtitle,
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
    );
  }
}

class _ProgresoCard extends StatelessWidget {
  final String titulo;
  final double pagado;
  final double total;
  final double pendiente;
  final int cuotasPagadas;
  final int totalCuotas;

  const _ProgresoCard({
    required this.titulo,
    required this.pagado,
    required this.total,
    required this.pendiente,
    required this.cuotasPagadas,
    required this.totalCuotas,
  });

  String _formatearMonto(double monto) {
    final formatter = NumberFormat('#,##0.00', 'es_BO');
    return 'Bs. ${formatter.format(monto)}';
  }

  @override
  Widget build(BuildContext context) {
    final porcentaje = total > 0 ? (pagado / total) : 0.0;

    return Container(
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
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${(porcentaje * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Barra de progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: porcentaje,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pagado',
                    style: TextStyle(fontSize: 11, color: kSecondaryColor),
                  ),
                  Text(
                    _formatearMonto(pagado),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Cuotas',
                    style: TextStyle(fontSize: 11, color: kSecondaryColor),
                  ),
                  Text(
                    '$cuotasPagadas / $totalCuotas',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Pendiente',
                    style: TextStyle(fontSize: 11, color: kSecondaryColor),
                  ),
                  Text(
                    _formatearMonto(pendiente),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de último pago realizado
class UltimoPagoCard extends StatelessWidget {
  final UltimoPago? ultimoPago;

  const UltimoPagoCard({Key? key, this.ultimoPago}) : super(key: key);

  String _formatearMonto(double monto) {
    final formatter = NumberFormat('#,##0.00', 'es_BO');
    return 'Bs. ${formatter.format(monto)}';
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

  @override
  Widget build(BuildContext context) {
    if (ultimoPago == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Último Pago',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatearMonto(ultimoPago!.totalPagado),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cuota #${ultimoPago!.numeroCuota} • ${_formatearFecha(ultimoPago!.fechaPago)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: kSecondaryColor,
                        ),
                      ),
                    ],
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

/// Tarjeta de alerta de mora
class AlertaMoraCard extends StatelessWidget {
  final PlanPagosResumen resumen;

  const AlertaMoraCard({Key? key, required this.resumen}) : super(key: key);

  String _formatearMonto(double monto) {
    final formatter = NumberFormat('#,##0.00', 'es_BO');
    return 'Bs. ${formatter.format(monto)}';
  }

  @override
  Widget build(BuildContext context) {
    if (resumen.cuotasVencidas == 0 && resumen.moraPendiente <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.warning_amber,
              color: Colors.red,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tienes cuotas vencidas',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${resumen.cuotasVencidas} cuota(s) vencida(s) • Mora: ${_formatearMonto(resumen.moraPendiente)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
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
