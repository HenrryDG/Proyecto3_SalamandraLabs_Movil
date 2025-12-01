/// Tipos de notificación disponibles en el sistema
enum TipoNotificacion {
  // Solicitudes
  nuevaSolicitud,
  solicitudAprobada,
  solicitudRechazada,
  cambioEstadoSolicitud,
  // Préstamos
  prestamoAprobado,
  prestamoDesembolsado,
  cambioEstadoPrestamo,
  prestamoEnMora,
  prestamoCompletado,
  // Plan de Pagos
  recordatorioCuota,
  cuotaProximaVencer,
  cuotaVenceHoy,
  cuotaVencida,
  pagoCompletado,
  moraAcumulada,
  // Generales
  advertencia,
  informativa,
}

/// Categorías de notificación
enum CategoriaNotificacion {
  emergente, // Alerta popup que debe mostrarse inmediatamente
  persistente, // Aparece en el historial/lista de notificaciones
  ambas, // Se muestra como emergente Y queda en historial
}

/// Niveles de prioridad
enum PrioridadNotificacion {
  baja,
  media,
  alta,
  urgente,
}

/// Estilos visuales para las notificaciones
enum EstiloNotificacion {
  info, // Informativa - color azul
  success, // Éxito - color verde
  warning, // Advertencia - color amarillo/naranja
  error, // Error/Urgente - color rojo
  reminder, // Recordatorio - color morado
}

class Notificacion {
  final String id;
  final String tipo;
  final String categoria;
  final String titulo;
  final String mensaje;
  final int clienteId;
  final int? solicitudId;
  final int? prestamoId;
  final int? planPagoId;
  final String prioridad;
  final String estilo;
  final String fechaGeneracion;
  final String? fechaEvento;
  final bool leida;
  final Map<String, dynamic> datosExtra;

  Notificacion({
    required this.id,
    required this.tipo,
    required this.categoria,
    required this.titulo,
    required this.mensaje,
    required this.clienteId,
    this.solicitudId,
    this.prestamoId,
    this.planPagoId,
    required this.prioridad,
    required this.estilo,
    required this.fechaGeneracion,
    this.fechaEvento,
    this.leida = false,
    this.datosExtra = const {},
  });

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
      id: json['id'] ?? '',
      tipo: json['tipo'] ?? '',
      categoria: json['categoria'] ?? 'persistente',
      titulo: json['titulo'] ?? '',
      mensaje: json['mensaje'] ?? '',
      clienteId: json['cliente_id'] ?? 0,
      solicitudId: json['solicitud_id'],
      prestamoId: json['prestamo_id'],
      planPagoId: json['plan_pago_id'],
      prioridad: json['prioridad'] ?? 'media',
      estilo: json['estilo'] ?? 'info',
      fechaGeneracion: json['fecha_generacion'] ?? '',
      fechaEvento: json['fecha_evento'],
      leida: json['leida'] ?? false,
      datosExtra: json['datos_extra'] ?? {},
    );
  }

  /// Verifica si la notificación es emergente
  bool get esEmergente => categoria == 'emergente' || categoria == 'ambas';

  /// Verifica si la notificación es persistente
  bool get esPersistente => categoria == 'persistente' || categoria == 'ambas';

  /// Verifica si es urgente
  bool get esUrgente => prioridad == 'urgente';

  /// Verifica si es de alta prioridad
  bool get esAlta => prioridad == 'alta' || prioridad == 'urgente';
}

class ResumenNotificaciones {
  final int total;
  final int urgentes;
  final int altas;
  final bool requiereAtencion;
  final Map<String, dynamic> tipos;

  ResumenNotificaciones({
    required this.total,
    required this.urgentes,
    required this.altas,
    required this.requiereAtencion,
    this.tipos = const {},
  });

  factory ResumenNotificaciones.fromJson(Map<String, dynamic> json) {
    return ResumenNotificaciones(
      total: json['total'] ?? 0,
      urgentes: json['urgentes'] ?? 0,
      altas: json['altas'] ?? 0,
      requiereAtencion: json['requiere_atencion'] ?? false,
      tipos: json['tipos'] ?? {},
    );
  }
}
