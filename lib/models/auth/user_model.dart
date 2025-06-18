class UserModel {
  final int id;
  final String email;
  final String role;
  // Agrega más campos según necesites

  UserModel({required this.id, required this.email, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], email: json['correo'], role: json['rol']);
  }
}
