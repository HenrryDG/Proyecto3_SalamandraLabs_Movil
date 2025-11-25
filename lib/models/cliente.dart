class Cliente {
  final int? id;
  final String carnet;
  final String? complemento;
  final String nombre;
  final String? apellidoPaterno;
  final String? apellidoMaterno;
  final String lugarTrabajo;
  final String tipoTrabajo;
  final double ingresoMensual;
  final String direccion;
  final String? correo;
  final int telefono; // Ahora como int
  final bool activo;
  final String? createdAt;
  final String? updatedAt;

  Cliente({
    this.id,
    required this.carnet,
    this.complemento,
    required this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    required this.lugarTrabajo,
    required this.tipoTrabajo,
    required this.ingresoMensual,
    required this.direccion,
    this.correo,
    required this.telefono,
    this.activo = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      carnet: json['carnet'],
      complemento: json['complemento'],
      nombre: json['nombre'],
      apellidoPaterno: json['apellido_paterno'],
      apellidoMaterno: json['apellido_materno'],
      lugarTrabajo: json['lugar_trabajo'],
      tipoTrabajo: json['tipo_trabajo'],
      ingresoMensual: (json['ingreso_mensual'] as num).toDouble(),
      direccion: json['direccion'],
      correo: json['correo'],
      telefono: json['telefono'] is int
          ? json['telefono']
          : int.parse(json['telefono'].toString()),
      activo: json['activo'] ?? true,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson({String? username, String? password}) {
    final data = {
      'carnet': carnet,
      'complemento': complemento,
      'nombre': nombre,
      'apellido_paterno': apellidoPaterno,
      'apellido_materno': apellidoMaterno,
      'lugar_trabajo': lugarTrabajo,
      'tipo_trabajo': tipoTrabajo,
      'ingreso_mensual': ingresoMensual,
      'direccion': direccion,
      'correo': correo,
      'telefono': telefono,
      'activo': activo,
    };
    if (username != null) data['username'] = username;
    if (password != null) data['password'] = password;
    return data;
  }
}
