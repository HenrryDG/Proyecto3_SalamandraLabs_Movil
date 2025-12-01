import 'dart:async';
import 'package:flutter/material.dart';
import '../models/notificacion.dart';
import '../services/api_service.dart';
import '../constants.dart';

/// Servicio para manejar las notificaciones emergentes y el estado global
class NotificacionService {
  static final NotificacionService _instance = NotificacionService._internal();
  factory NotificacionService() => _instance;
  NotificacionService._internal();

  Timer? _timer;
  final _resumenController =
      StreamController<ResumenNotificaciones>.broadcast();
  final _alertasController = StreamController<List<Notificacion>>.broadcast();

  Stream<ResumenNotificaciones> get resumenStream => _resumenController.stream;
  Stream<List<Notificacion>> get alertasStream => _alertasController.stream;

  ResumenNotificaciones? _ultimoResumen;
  ResumenNotificaciones? get ultimoResumen => _ultimoResumen;

  /// Inicia el polling de notificaciones (cada 60 segundos)
  void iniciarPolling({Duration intervalo = const Duration(seconds: 60)}) {
    _timer?.cancel();

    // Verificar inmediatamente
    _verificarNotificaciones();

    // Configurar el timer
    _timer = Timer.periodic(intervalo, (_) {
      _verificarNotificaciones();
    });
  }

  /// Detiene el polling
  void detenerPolling() {
    _timer?.cancel();
    _timer = null;
  }

  /// Verifica las notificaciones y emite actualizaciones
  Future<void> _verificarNotificaciones() async {
    try {
      final apiService = ApiService();

      // Obtener resumen
      final resumen = await apiService.obtenerResumenNotificaciones();
      _ultimoResumen = resumen;
      _resumenController.add(resumen);

      // Obtener alertas emergentes
      final alertas = await apiService.obtenerMisAlertas();
      if (alertas.isNotEmpty) {
        _alertasController.add(alertas);
      }
    } catch (e) {
      // Silenciar errores de polling para no interrumpir la app
      debugPrint('Error al verificar notificaciones: $e');
    }
  }

  /// Fuerza una actualización inmediata
  Future<void> actualizarAhora() async {
    await _verificarNotificaciones();
  }

  /// Limpia los recursos
  void dispose() {
    _timer?.cancel();
    _resumenController.close();
    _alertasController.close();
  }
}

/// Widget para mostrar alertas emergentes como SnackBar o Dialog
class AlertaNotificacionWidget {
  static void mostrarAlerta(BuildContext context, Notificacion notificacion) {
    final color = _getEstiloColor(notificacion.estilo);
    final icon = _getEstiloIcon(notificacion.estilo);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notificacion.titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notificacion.mensaje,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: color,
        duration: notificacion.esUrgente
            ? const Duration(seconds: 8)
            : const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'VER',
          textColor: Colors.white,
          onPressed: () {
            // Navegar a notificaciones
            Navigator.pushNamed(context, '/notificaciones');
          },
        ),
      ),
    );
  }

  static void mostrarDialogoUrgente(
      BuildContext context, Notificacion notificacion) {
    final color = _getEstiloColor(notificacion.estilo);
    final icon = _getEstiloIcon(notificacion.estilo);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                notificacion.titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notificacion.mensaje,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),
            if (notificacion.datosExtra.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildDatosExtraDialog(notificacion.datosExtra, color),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CERRAR'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/notificaciones');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'VER DETALLES',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDatosExtraDialog(
      Map<String, dynamic> datos, Color color) {
    final items = <Widget>[];

    if (datos['monto_cuota'] != null) {
      items.add(_buildItem('Cuota:', 'Bs ${datos['monto_cuota']}'));
    }
    if (datos['mora'] != null && datos['mora'] > 0) {
      items.add(_buildItem('Mora:', 'Bs ${datos['mora']}', isError: true));
    }
    if (datos['dias_atraso'] != null && datos['dias_atraso'] > 0) {
      items.add(_buildItem('Días de atraso:', '${datos['dias_atraso']}',
          isError: true));
    }
    if (datos['fecha_vencimiento'] != null) {
      items.add(_buildItem('Vencimiento:', '${datos['fecha_vencimiento']}'));
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }

  static Widget _buildItem(String label, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: kSecondaryColor,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isError ? Colors.red : Colors.black87,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  static Color _getEstiloColor(String estilo) {
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

  static IconData _getEstiloIcon(String estilo) {
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
}

/// Widget de badge para mostrar el contador de notificaciones
class NotificacionBadge extends StatelessWidget {
  final Widget child;
  final int count;
  final bool showBadge;
  final Color? badgeColor;

  const NotificacionBadge({
    super.key,
    required this.child,
    this.count = 0,
    this.showBadge = true,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!showBadge || count == 0) {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: -6,
          top: -6,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: badgeColor ?? Colors.red,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(
              minWidth: 18,
              minHeight: 18,
            ),
            child: Center(
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget de icono de notificaciones con badge para usar en AppBar
class NotificacionIconButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const NotificacionIconButton({super.key, this.onPressed});

  @override
  State<NotificacionIconButton> createState() => _NotificacionIconButtonState();
}

class _NotificacionIconButtonState extends State<NotificacionIconButton> {
  final _service = NotificacionService();
  int _count = 0;
  bool _requiereAtencion = false;

  @override
  void initState() {
    super.initState();
    _service.resumenStream.listen((resumen) {
      if (mounted) {
        setState(() {
          _count = resumen.total;
          _requiereAtencion = resumen.requiereAtencion;
        });
      }
    });

    // Cargar resumen inicial
    _cargarResumen();
  }

  Future<void> _cargarResumen() async {
    try {
      final resumen = await ApiService().obtenerResumenNotificaciones();
      if (mounted) {
        setState(() {
          _count = resumen.total;
          _requiereAtencion = resumen.requiereAtencion;
        });
      }
    } catch (e) {
      // Ignorar errores
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onPressed ??
          () {
            Navigator.pushNamed(context, '/notificaciones');
          },
      icon: NotificacionBadge(
        count: _count,
        badgeColor: _requiereAtencion ? Colors.red : kPrimaryColor,
        child: const Icon(
          Icons.notifications_outlined,
          size: 28,
        ),
      ),
    );
  }
}
