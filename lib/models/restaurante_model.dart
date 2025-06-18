class Restaurante {
  final int id;
  final int idUsuario;
  final String nombreRestaurante;
  final String direccion;
  final String telefono;
  final String categoria;
  final String horarioApertura;
  final String horarioCierre;
  final String tipoRestaurante;
  final String calificacion;
  final String? rutaImagenRestaurante;
  final String? imagenBase64;

  Restaurante({
    required this.id,
    required this.idUsuario,
    required this.nombreRestaurante,
    required this.direccion,
    required this.telefono,
    required this.categoria,
    required this.horarioApertura,
    required this.horarioCierre,
    required this.tipoRestaurante,
    required this.calificacion,
    this.rutaImagenRestaurante,
    this.imagenBase64,
  });

  factory Restaurante.fromJson(Map<String, dynamic> json) {
    return Restaurante(
      id: json['id'],
      idUsuario: json['id_usuario'],
      nombreRestaurante: json['nombre_restaurante'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      categoria: json['categoria'],
      horarioApertura: json['horario_apertura'],
      horarioCierre: json['horario_cierre'],
      tipoRestaurante: json['tipo_restaurante'],
      calificacion: json['calificacion'],
      rutaImagenRestaurante: json['ruta_imagen_restaurante'],
      imagenBase64: json['imagen_base64'],
    );
  }
}
