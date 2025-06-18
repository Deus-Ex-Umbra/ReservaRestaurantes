import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: ProfileSettingsPage()));
}

// Background reusable - Versión simplificada sin fondo amarillo ni íconos de comida
class FoodieBackground extends StatelessWidget {
  final Widget? child;

  const FoodieBackground({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo blanco simple
        Container(color: Colors.white),

        // Main content with 80% width constraint
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: child,
          ),
        ),
      ],
    );
  }
}

// Página principal de Profile Settings
class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  // Datos del usuario (simulados)
  final String userEmail = 'micheal.jonathon@email.com';
  final String userRole = 'administrador';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FoodieBackground(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Profile Section
                    _buildProfileSection(),
                    const SizedBox(height: 25),
                    // Settings Options Card
                    _buildSettingsCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            // Profile Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                  ),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: const Color(0xFF5353FF), width: 3),
              ),
            ),
            const SizedBox(height: 15),
            // Name
            const Text(
              'Micheal Jonathon',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Email
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            // Rol del usuario con estilo según el tipo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getRoleColor(userRole),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                userRole.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          // First Group
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 8),
                _buildSettingsItem(
                  icon: Icons.person_outline,
                  iconColor: const Color(0xFF7E8590),
                  title: 'Cambiar Nombre',
                  subtitle: 'Puedes cambiar tu nombre y apellido',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangeNamePage(),
                        ),
                      ),
                ),
                const SizedBox(height: 8),
                _buildSettingsItem(
                  icon: Icons.lock_outline,
                  iconColor: const Color(0xFF7E8590),
                  title: 'Cambiar Contraseña',
                  subtitle: 'Cambia tu contraseña fácilmente',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordPage(),
                        ),
                      ),
                ),
              ],
            ),
          ),

          // Separator
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            height: 1,
            color: Colors.grey[200],
          ),

          // Second Group
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 8),
                _buildSettingsItem(
                  icon: Icons.email_outlined,
                  iconColor: const Color(0xFF7E8590),
                  title: 'Cambiar Email',
                  subtitle: 'Puedes cambiar tu correo electrónico',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangeEmailPage(),
                        ),
                      ),
                ),
                const SizedBox(height: 8),
                _buildSettingsItem(
                  icon: Icons.phone_outlined,
                  iconColor: const Color(0xFF7E8590),
                  title: 'Cambiar Número Móvil',
                  subtitle: 'Cambia tu número de teléfono móvil',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangeMobilePage(),
                        ),
                      ),
                ),
                const SizedBox(height: 8),
                _buildSettingsItem(
                  icon: Icons.calendar_today_outlined,
                  iconColor: const Color(0xFF7E8590),
                  title: 'Cambiar Fecha de Nacimiento',
                  subtitle: 'Cambia tu fecha de nacimiento',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangeDateOfBirthPage(),
                        ),
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Logout Button
          Container(
            margin: const EdgeInsets.all(20),
            width: double.infinity,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _showLogoutDialog(context),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8E2A2A), Color(0xFFC53A3A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'CERRAR SESIÓN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isSpecial = false,
  }) {
    return HoverWidget(
      builder: (context, isHovered) {
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:
                  isHovered
                      ? (isSpecial
                          ? const Color(0xFF382D47).withOpacity(0.1)
                          : Colors.grey[100])
                      : Colors.transparent,
              border:
                  isSpecial
                      ? Border.all(
                        color: const Color(0xFFBD89FF).withOpacity(0.3),
                        width: 1,
                      )
                      : null,
            ),
            child: Row(
              children: [
                // Icon
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        isHovered
                            ? (isSpecial
                                ? const Color(0xFF382D47).withOpacity(0.2)
                                : Colors.grey[200])
                            : (isSpecial
                                ? const Color(0xFF382D47).withOpacity(0.1)
                                : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color:
                        isHovered
                            ? (isSpecial
                                ? const Color(0xFFBD89FF)
                                : Colors.black87)
                            : iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 15),
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              isHovered
                                  ? (isSpecial
                                      ? const Color(0xFFBD89FF)
                                      : Colors.black87)
                                  : (isSpecial
                                      ? const Color(0xFFBD89FF)
                                      : Colors.black87),
                        ),
                        child: Text(title),
                      ),
                      const SizedBox(height: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        style: TextStyle(
                          fontSize: 13,
                          color:
                              isHovered
                                  ? (isSpecial
                                      ? const Color(0xFFBD89FF).withOpacity(0.8)
                                      : Colors.black54)
                                  : Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                        child: Text(subtitle),
                      ),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    key: ValueKey<bool>(isHovered),
                    color:
                        isHovered
                            ? (isSpecial
                                ? const Color(0xFFBD89FF)
                                : Colors.black54)
                            : Colors.grey,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'administrador':
        return const Color(0xFF5353FF);
      case 'restaurante':
        return const Color(0xFF2ECC71);
      case 'cliente':
        return const Color(0xFFF39C12);
      default:
        return const Color(0xFF7E8590);
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.exit_to_app,
                  color: Color(0xFF8E2A2A),
                  size: 50,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  '¿Estás seguro de que quieres cerrar sesión?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: const Color(0xFF8E2A2A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Cerrar Sesión',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _performLogout(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _performLogout(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}

// Widget para manejar el estado de hover con animaciones suaves
class HoverWidget extends StatefulWidget {
  final Widget Function(BuildContext context, bool isHovered) builder;

  const HoverWidget({Key? key, required this.builder}) : super(key: key);

  @override
  _HoverWidgetState createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<HoverWidget>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.builder(context, isHovered),
      ),
    );
  }
}

// Base class for form pages
abstract class BaseFormPage extends StatelessWidget {
  const BaseFormPage({Key? key}) : super(key: key);

  Widget buildForm(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FoodieBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black87,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                getTitle(),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              pinned: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              sliver: SliverToBoxAdapter(child: buildForm(context)),
            ),
          ],
        ),
      ),
    );
  }

  String getTitle();
}

// Form input field widget
class FoodieInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? hintText;

  const FoodieInputField({
    Key? key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// Form submit button
class FoodieSubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const FoodieSubmitButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5353FF), Color(0xFF8A53FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1,
              ),
              child: Text(text.toUpperCase()),
            ),
          ),
        ),
      ),
    );
  }
}

// Página para cambiar nombre
class ChangeNamePage extends BaseFormPage {
  const ChangeNamePage({Key? key}) : super(key: key);

  @override
  String getTitle() => 'Cambiar Nombre';

  @override
  Widget buildForm(BuildContext context) {
    final _firstNameController = TextEditingController(text: 'Micheal');
    final _lastNameController = TextEditingController(text: 'Jonathon');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FoodieInputField(label: 'Nombre', controller: _firstNameController),
        FoodieInputField(label: 'Apellido', controller: _lastNameController),
        const SizedBox(height: 20),
        FoodieSubmitButton(
          text: 'Actualizar Nombre',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

// Página para cambiar contraseña
class ChangePasswordPage extends BaseFormPage {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  String getTitle() => 'Cambiar Contraseña';

  @override
  Widget buildForm(BuildContext context) {
    final _currentPasswordController = TextEditingController();
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    bool _obscureCurrentPassword = true;
    bool _obscureNewPassword = true;
    bool _obscureConfirmPassword = true;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FoodieInputField(
              label: 'Contraseña Actual',
              controller: _currentPasswordController,
              obscureText: _obscureCurrentPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureCurrentPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: const Color(0xFF7E8590),
                ),
                onPressed:
                    () => setState(
                      () => _obscureCurrentPassword = !_obscureCurrentPassword,
                    ),
              ),
            ),
            FoodieInputField(
              label: 'Nueva Contraseña',
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF7E8590),
                ),
                onPressed:
                    () => setState(
                      () => _obscureNewPassword = !_obscureNewPassword,
                    ),
              ),
            ),
            FoodieInputField(
              label: 'Confirmar Contraseña',
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: const Color(0xFF7E8590),
                ),
                onPressed:
                    () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            FoodieSubmitButton(
              text: 'Actualizar Contraseña',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}

// Página para cambiar email
class ChangeEmailPage extends BaseFormPage {
  const ChangeEmailPage({Key? key}) : super(key: key);

  @override
  String getTitle() => 'Cambiar Email';

  @override
  Widget buildForm(BuildContext context) {
    final _emailController = TextEditingController(
      text: 'micheal.jonathon@email.com',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FoodieInputField(
          label: 'Correo Electrónico',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        FoodieSubmitButton(
          text: 'Actualizar Email',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

// Página para cambiar número móvil
class ChangeMobilePage extends BaseFormPage {
  const ChangeMobilePage({Key? key}) : super(key: key);

  @override
  String getTitle() => 'Cambiar Número Móvil';

  @override
  Widget buildForm(BuildContext context) {
    final _mobileController = TextEditingController(text: '+1 234 567 8900');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FoodieInputField(
          label: 'Número Móvil',
          controller: _mobileController,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),
        FoodieSubmitButton(
          text: 'Actualizar Número',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

// Página para cambiar fecha de nacimiento
class ChangeDateOfBirthPage extends BaseFormPage {
  const ChangeDateOfBirthPage({Key? key}) : super(key: key);

  @override
  String getTitle() => 'Cambiar Fecha de Nacimiento';

  @override
  Widget buildForm(BuildContext context) {
    final _dateController = TextEditingController(text: 'Enero 15, 1990');
    DateTime selectedDate = DateTime(1990, 1, 15);

    String _formatDate(DateTime date) {
      const months = [
        'Enero',
        'Febrero',
        'Marzo',
        'Abril',
        'Mayo',
        'Junio',
        'Julio',
        'Agosto',
        'Septiembre',
        'Octubre',
        'Noviembre',
        'Diciembre',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF5353FF),
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black87,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        },
      );
      if (picked != null && picked != selectedDate) {
        selectedDate = picked;
        _dateController.text = _formatDate(picked);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: FoodieInputField(
              label: 'Fecha de Nacimiento',
              controller: _dateController,
              suffixIcon: const Icon(
                Icons.calendar_today,
                color: Color(0xFF7E8590),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        FoodieSubmitButton(
          text: 'Actualizar Fecha',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
