/// Modelo para el dashboard del cliente
/// Mapea la respuesta del endpoint /api/dashboard/cliente/<id>/

class DashboardCliente {
  final SolicitudesResumen solicitudes;
  final PrestamosResumen prestamos;
  final PlanPagosInfo planPagos;
  final String fechaConsulta;

  DashboardCliente({
    required this.solicitudes,
    required this.prestamos,
    required this.planPagos,
    required this.fechaConsulta,
  });

  factory DashboardCliente.fromJson(Map<String, dynamic> json) {
    return DashboardCliente(
      solicitudes: SolicitudesResumen.fromJson(json['solicitudes'] ?? {}),
      prestamos: PrestamosResumen.fromJson(json['prestamos'] ?? {}),
      planPagos: PlanPagosInfo.fromJson(json['plan_pagos'] ?? {}),
      fechaConsulta: json['fecha_consulta'] ?? '',
    );
  }
}

class SolicitudesResumen {
  final int total;
  final int pendientes;
  final int aprobadas;
  final int rechazadas;
  final double montoTotalSolicitado;

  SolicitudesResumen({
    required this.total,
    required this.pendientes,
    required this.aprobadas,
    required this.rechazadas,
    required this.montoTotalSolicitado,
  });

  factory SolicitudesResumen.fromJson(Map<String, dynamic> json) {
    return SolicitudesResumen(
      total: json['total'] ?? 0,
      pendientes: json['pendientes'] ?? 0,
      aprobadas: json['aprobadas'] ?? 0,
      rechazadas: json['rechazadas'] ?? 0,
      montoTotalSolicitado: (json['monto_total_solicitado'] ?? 0).toDouble(),
    );
  }
}

class PrestamosResumen {
  final int total;
  final int enCurso;
  final int enMora;
  final int completados;
  final double montoTotalAprobado;
  final double montoTotalRestante;
  final double montoTotalPagado;

  PrestamosResumen({
    required this.total,
    required this.enCurso,
    required this.enMora,
    required this.completados,
    required this.montoTotalAprobado,
    required this.montoTotalRestante,
    required this.montoTotalPagado,
  });

  factory PrestamosResumen.fromJson(Map<String, dynamic> json) {
    return PrestamosResumen(
      total: json['total'] ?? 0,
      enCurso: json['en_curso'] ?? 0,
      enMora: json['en_mora'] ?? 0,
      completados: json['completados'] ?? 0,
      montoTotalAprobado: (json['monto_total_aprobado'] ?? 0).toDouble(),
      montoTotalRestante: (json['monto_total_restante'] ?? 0).toDouble(),
      montoTotalPagado: (json['monto_total_pagado'] ?? 0).toDouble(),
    );
  }

  /// Porcentaje de progreso de pago
  double get porcentajePagado {
    if (montoTotalAprobado <= 0) return 0;
    return (montoTotalPagado / montoTotalAprobado) * 100;
  }
}

class PlanPagosInfo {
  final PlanPagosResumen resumen;
  final ProximaCuota? proximaCuota;
  final UltimoPago? ultimoPago;

  PlanPagosInfo({
    required this.resumen,
    this.proximaCuota,
    this.ultimoPago,
  });

  factory PlanPagosInfo.fromJson(Map<String, dynamic> json) {
    return PlanPagosInfo(
      resumen: PlanPagosResumen.fromJson(json['resumen'] ?? {}),
      proximaCuota: json['proxima_cuota'] != null
          ? ProximaCuota.fromJson(json['proxima_cuota'])
          : null,
      ultimoPago: json['ultimo_pago'] != null
          ? UltimoPago.fromJson(json['ultimo_pago'])
          : null,
    );
  }
}

class PlanPagosResumen {
  final int totalCuotas;
  final int cuotasPagadas;
  final int cuotasPendientes;
  final int cuotasVencidas;
  final double montoTotalCuotas;
  final double montoPagado;
  final double montoPendiente;
  final double moraAcumulada;
  final double moraPendiente;

  PlanPagosResumen({
    required this.totalCuotas,
    required this.cuotasPagadas,
    required this.cuotasPendientes,
    required this.cuotasVencidas,
    required this.montoTotalCuotas,
    required this.montoPagado,
    required this.montoPendiente,
    required this.moraAcumulada,
    required this.moraPendiente,
  });

  factory PlanPagosResumen.fromJson(Map<String, dynamic> json) {
    return PlanPagosResumen(
      totalCuotas: json['total_cuotas'] ?? 0,
      cuotasPagadas: json['cuotas_pagadas'] ?? 0,
      cuotasPendientes: json['cuotas_pendientes'] ?? 0,
      cuotasVencidas: json['cuotas_vencidas'] ?? 0,
      montoTotalCuotas: (json['monto_total_cuotas'] ?? 0).toDouble(),
      montoPagado: (json['monto_pagado'] ?? 0).toDouble(),
      montoPendiente: (json['monto_pendiente'] ?? 0).toDouble(),
      moraAcumulada: (json['mora_acumulada'] ?? 0).toDouble(),
      moraPendiente: (json['mora_pendiente'] ?? 0).toDouble(),
    );
  }

  /// Porcentaje de cuotas pagadas
  double get porcentajeCuotasPagadas {
    if (totalCuotas <= 0) return 0;
    return (cuotasPagadas / totalCuotas) * 100;
  }
}

class ProximaCuota {
  final int id;
  final int prestamoId;
  final int numeroCuota;
  final double montoCuota;
  final double moraCuota;
  final double totalAPagar;
  final String fechaVencimiento;
  final String estado;
  final int diasParaVencer;
  final String? metodoPago;

  ProximaCuota({
    required this.id,
    required this.prestamoId,
    required this.numeroCuota,
    required this.montoCuota,
    required this.moraCuota,
    required this.totalAPagar,
    required this.fechaVencimiento,
    required this.estado,
    required this.diasParaVencer,
    this.metodoPago,
  });

  factory ProximaCuota.fromJson(Map<String, dynamic> json) {
    return ProximaCuota(
      id: json['id'] ?? 0,
      prestamoId: json['prestamo_id'] ?? 0,
      numeroCuota: json['numero_cuota'] ?? 0,
      montoCuota: (json['monto_cuota'] ?? 0).toDouble(),
      moraCuota: (json['mora_cuota'] ?? 0).toDouble(),
      totalAPagar: (json['total_a_pagar'] ?? 0).toDouble(),
      fechaVencimiento: json['fecha_vencimiento'] ?? '',
      estado: json['estado'] ?? '',
      diasParaVencer: json['dias_para_vencer'] ?? 0,
      metodoPago: json['metodo_pago'],
    );
  }

  /// Indica si la cuota está vencida
  bool get estaVencida => diasParaVencer < 0;

  /// Indica si la cuota está próxima a vencer (menos de 5 días)
  bool get estaProximaAVencer => diasParaVencer >= 0 && diasParaVencer <= 5;
}

class UltimoPago {
  final int id;
  final int prestamoId;
  final int numeroCuota;
  final double montoCuota;
  final double moraCuota;
  final double totalPagado;
  final String? fechaPago;
  final String fechaVencimiento;
  final String? metodoPago;

  UltimoPago({
    required this.id,
    required this.prestamoId,
    required this.numeroCuota,
    required this.montoCuota,
    required this.moraCuota,
    required this.totalPagado,
    this.fechaPago,
    required this.fechaVencimiento,
    this.metodoPago,
  });

  factory UltimoPago.fromJson(Map<String, dynamic> json) {
    return UltimoPago(
      id: json['id'] ?? 0,
      prestamoId: json['prestamo_id'] ?? 0,
      numeroCuota: json['numero_cuota'] ?? 0,
      montoCuota: (json['monto_cuota'] ?? 0).toDouble(),
      moraCuota: (json['mora_cuota'] ?? 0).toDouble(),
      totalPagado: (json['total_pagado'] ?? 0).toDouble(),
      fechaPago: json['fecha_pago'],
      fechaVencimiento: json['fecha_vencimiento'] ?? '',
      metodoPago: json['metodo_pago'],
    );
  }
}
