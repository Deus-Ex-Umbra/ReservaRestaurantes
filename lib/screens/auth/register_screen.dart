import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../shared/home.dart';
import 'login_screen.dart';
import '../restaurante/admin_home.dart';
import '../admin/admin_main.dart';
import '../shared/navegacion.dart';
import '../../widgets/comida.dart';
import '../../utils/store.dart'; // Para manejar el almacenamiento local
import '../../api/api_client.dart'; // Para hacer las peticiones HTTP
import '../welcome_screen.dart';
import '../../models/auth/user_model.dart'; // Asegúrate de que la ruta sea correcta

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Las contraseñas no coinciden';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dio = ApiClient.dio;
      final response = await dio.post(
        '/api/autenticacion/registrarse',
        data: {
          'nombres': _nameController.text,
          'apellidos': _lastNameController.text,
          'email': _emailController.text,
          'telefono': _phoneController.text,
          'password': _passwordController.text,
          'tipo_usuario':
              'cliente', // Tipo de usuario fijo para este formulario
        },
      );

      if (response.statusCode == 201) {
        // Guardar el token y datos del usuario
        final token = response.data['token'];
        final userData = response.data['usuario'];

        //await SecureStorage.saveToken(token);
        await SecureStorage.saveUser(UserModel.fromJson(userData));

        // Navegar a la pantalla principal del cliente
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
        );
      } else {
        throw Exception('Error en el registro: ${response.data['message']}');
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Error en el registro';
      setState(() {
        _errorMessage = errorMessage;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error inesperado: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FoodBackgroundWidget(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AppBar personalizado
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Color(0xFFFF6B35),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Logo y título
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Únete a',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                          Text(
                            'Foodie',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6B35),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Crea tu cuenta para descubrir comida increíble',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF757575),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40),

                    // Mostrar mensaje de error si existe
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Campos de entrada
                    _buildInputField(
                      controller: _nameController,
                      hintText: 'Nombres',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tus nombres';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildInputField(
                      controller: _lastNameController,
                      hintText: 'Apellidos',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tus apellidos';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildInputField(
                      controller: _emailController,
                      hintText: 'Correo electrónico',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu correo';
                        }
                        if (!value.contains('@')) {
                          return 'Ingresa un correo válido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildInputField(
                      controller: _phoneController,
                      hintText: 'Teléfono (opcional)',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    _buildInputField(
                      controller: _passwordController,
                      hintText: 'Contraseña',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa una contraseña';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildInputField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirmar contraseña',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 30),

                    // Botón de registro
                    Container(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFD54F),
                          foregroundColor: Color(0xFF2D2D2D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child:
                            _isLoading
                                ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF2D2D2D),
                                  ),
                                )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'REGISTRARSE',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        size: 16,
                                        color: Color(0xFFFFD54F),
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),

                    SizedBox(height: 30),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "¿Ya tienes una cuenta? ",
                            style: TextStyle(color: Color(0xFF757575)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Iniciar sesión',
                              style: TextStyle(
                                color: Color(0xFFFF6B35),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(color: Color(0xFF2D2D2D)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
          prefixIcon: Icon(icon, color: Color(0xFFFFD54F)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(20),
          errorStyle: TextStyle(
            height: 0,
          ), // Para no ocupar espacio cuando no hay error
        ),
      ),
    );
  }
}
