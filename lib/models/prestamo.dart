class PlanPago {
  final int id;
  final int prestamo;
  final String? fechaPago;
  final String fechaVencimiento;
  final String? metodoPago;
  final double montoCuota;
  final double moraCuota;
  final String estado;
  final String? createdAt;
  final String? updatedAt;

  PlanPago({
    required this.id,
    required this.prestamo,
    this.fechaPago,
    required this.fechaVencimiento,
    this.metodoPago,
    required this.montoCuota,
    required this.moraCuota,
    required this.estado,
    this.createdAt,
    this.updatedAt,
  });

  factory PlanPago.fromJson(Map<String, dynamic> json) {
    return PlanPago(
      id: json['id'],
      prestamo: json['prestamo'],
      fechaPago: json['fecha_pago'],
      fechaVencimiento: json['fecha_vencimiento'],
      metodoPago: json['metodo_pago'],
      montoCuota: json['monto_cuota'] is num
          ? (json['monto_cuota'] as num).toDouble()
          : double.parse(json['monto_cuota'].toString()),
      moraCuota: json['mora_cuota'] is num
          ? (json['mora_cuota'] as num).toDouble()
          : double.parse(json['mora_cuota'].toString()),
      estado: json['estado'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  double get montoTotal => montoCuota + moraCuota;
}

class Prestamo {
  final int id;
  final int solicitud;
  final String? clienteNombre;
  final double? montoSolicitado;
  final double montoAprobado;
  final double montoRestante;
  final double interes;
  final int? plazoMeses;
  final String? fechaDesembolso;
  final String? fechaPlazo;
  final String estado;
  final List<PlanPago> planPagos;
  final String? createdAt;
  final String? updatedAt;

  Prestamo({
    required this.id,
    required this.solicitud,
    this.clienteNombre,
    this.montoSolicitado,
    required this.montoAprobado,
    required this.montoRestante,
    required this.interes,
    this.plazoMeses,
    this.fechaDesembolso,
    this.fechaPlazo,
    required this.estado,
    this.planPagos = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory Prestamo.fromJson(Map<String, dynamic> json) {
    return Prestamo(
      id: json['id'],
      solicitud: json['solicitud'],
      clienteNombre: json['cliente_nombre'],
      montoSolicitado: json['monto_solicitado'] != null
          ? (json['monto_solicitado'] is num
              ? (json['monto_solicitado'] as num).toDouble()
              : double.parse(json['monto_solicitado'].toString()))
          : null,
      montoAprobado: json['monto_aprobado'] is num
          ? (json['monto_aprobado'] as num).toDouble()
          : double.parse(json['monto_aprobado'].toString()),
      montoRestante: json['monto_restante'] is num
          ? (json['monto_restante'] as num).toDouble()
          : double.parse(json['monto_restante'].toString()),
      interes: json['interes'] is num
          ? (json['interes'] as num).toDouble()
          : double.parse(json['interes'].toString()),
      plazoMeses: json['plazo_meses'],
      fechaDesembolso: json['fecha_desembolso'],
      fechaPlazo: json['fecha_plazo'],
      estado: json['estado'],
      planPagos: json['plan_pagos'] != null
          ? (json['plan_pagos'] as List)
              .map((pago) => PlanPago.fromJson(pago))
              .toList()
          : [],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
