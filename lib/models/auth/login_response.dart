import 'user_model.dart';

class LoginResponse {
  final String accessToken; // Cambiado de token a accessToken
  final String tokenType;
  final int expiresIn;
  final UserModel user;

  LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] as String, // Usa access_token
      tokenType: json['token_type'] as String,
      expiresIn: json['expires_in'] as int,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  // Método para obtener el token (si prefieres mantener la propiedad "token")
  String get token => accessToken;
}
