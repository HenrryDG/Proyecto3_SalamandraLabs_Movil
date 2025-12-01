class Solicitud {
  final int id;
  final String? empleadoNombre;
  final String? clienteNombre;
  final double? clienteIngresoMensual;
  final double montoSolicitado;
  final double? montoAprobado;
  final int? plazoMeses;
  final String proposito;
  final String fechaSolicitud;
  final String? fechaAprobacion;
  final String? fechaPlazo;
  final String estado;
  final String? observaciones;
  final int empleado;
  final int cliente;
  final List<Documento> documentos;
  final String? createdAt;
  final String? updatedAt;

  Solicitud({
    required this.id,
    this.empleadoNombre,
    this.clienteNombre,
    this.clienteIngresoMensual,
    required this.montoSolicitado,
    this.montoAprobado,
    this.plazoMeses,
    required this.proposito,
    required this.fechaSolicitud,
    this.fechaAprobacion,
    this.fechaPlazo,
    required this.estado,
    this.observaciones,
    required this.empleado,
    required this.cliente,
    this.documentos = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory Solicitud.fromJson(Map<String, dynamic> json) {
    return Solicitud(
      id: json['id'],
      empleadoNombre: json['empleado_nombre'],
      clienteNombre: json['cliente_nombre'],
      clienteIngresoMensual: json['cliente_ingreso_mensual'] != null
          ? (json['cliente_ingreso_mensual'] is num
              ? (json['cliente_ingreso_mensual'] as num).toDouble()
              : double.parse(json['cliente_ingreso_mensual'].toString()))
          : null,
      montoSolicitado: json['monto_solicitado'] is num
          ? (json['monto_solicitado'] as num).toDouble()
          : double.parse(json['monto_solicitado'].toString()),
      montoAprobado: json['monto_aprobado'] != null
          ? (json['monto_aprobado'] is num
              ? (json['monto_aprobado'] as num).toDouble()
              : double.parse(json['monto_aprobado'].toString()))
          : null,
      plazoMeses: json['plazo_meses'],
      proposito: json['proposito'],
      fechaSolicitud: json['fecha_solicitud'],
      fechaAprobacion: json['fecha_aprobacion'],
      fechaPlazo: json['fecha_plazo'],
      estado: json['estado'],
      observaciones: json['observaciones'],
      empleado: json['empleado'],
      cliente: json['cliente'],
      documentos: json['documentos'] != null
          ? (json['documentos'] as List)
              .map((doc) => Documento.fromJson(doc))
              .toList()
          : [],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Documento {
  final int id;
  final String tipoDocumento;
  final String? urlDocumento;
  final String? createdAt;

  Documento({
    required this.id,
    required this.tipoDocumento,
    this.urlDocumento,
    this.createdAt,
  });

  factory Documento.fromJson(Map<String, dynamic> json) {
    return Documento(
      id: json['id'],
      tipoDocumento: json['tipo_documento'] ?? '',
      urlDocumento: json['url_documento'],
      createdAt: json['created_at'],
    );
  }
}
