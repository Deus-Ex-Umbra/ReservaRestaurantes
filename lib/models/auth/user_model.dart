class UserModel {
  final int id;
  final String email;
  final String role;

  UserModel({required this.id, required this.email, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['correo'] as String,
      role: json['rol'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'correo': email, 'rol': role};
}
