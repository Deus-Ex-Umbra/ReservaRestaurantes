import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui';

class AppColors {
  static const Color primaryDark = Color(0xFF0c0f14);
  static const Color cardDark = Color(0xFF1A1F2E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8B9AAB);
  static const Color accent = Color(0xFF4ECDC4);
  static const Color accentLight = Color(0xFF7DFFED);
  static const Color orange = Color(0xFFd17842);
  static const Color yellow = Color(0xFFFFD700);
  static const Color darkGray = Color(0xFF52555a);
  static const Color gray = Color(0xFFaeaeae);
  static const Color navBarIconActive = Color(0xFFd17842);
  static const Color navBarIconInactive = Color(0xFF52555a);
}

class AppTextStyles {
  static const TextStyle caption = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );
}

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<AnimationController> _hoverControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _marginAnimations;
  late List<Animation<double>> _indicatorAnimations;
  late List<Animation<double>> _hoverOpacityAnimations;
  late List<Animation<Color?>> _hoverColorAnimations;

  List<bool> _isHovering = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      5,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _hoverControllers = List.generate(
      5,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _scaleAnimations =
        _controllers
            .map(
              (controller) => Tween<double>(begin: 1.0, end: 1.2).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut),
              ),
            )
            .toList();

    _marginAnimations =
        _controllers
            .map(
              (controller) => Tween<double>(begin: 0.0, end: -5.0).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut),
              ),
            )
            .toList();

    _indicatorAnimations =
        _controllers
            .map(
              (controller) => Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut),
              ),
            )
            .toList();

    _hoverOpacityAnimations =
        _hoverControllers
            .map(
              (controller) => Tween<double>(begin: 1.0, end: 0.6).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut),
              ),
            )
            .toList();

    _hoverColorAnimations =
        _hoverControllers
            .map(
              (controller) => ColorTween(
                begin: AppColors.gray,
                end: AppColors.orange,
              ).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut),
              ),
            )
            .toList();

    if (widget.currentIndex >= 0 && widget.currentIndex < 5) {
      _controllers[widget.currentIndex].forward();
    }
  }

  @override
  void didUpdateWidget(BottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      if (oldWidget.currentIndex >= 0 && oldWidget.currentIndex < 5) {
        _controllers[oldWidget.currentIndex].reverse();
      }
      if (widget.currentIndex >= 0 && widget.currentIndex < 5) {
        _controllers[widget.currentIndex].forward();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var controller in _hoverControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  final Map<int, String> _navigationRoutes = {
    0: '/home',
    1: '/buscar',
    2: '/reservas',
    3: '/favoritos',
    4: '/perfil',
  };

  void _handleTap(int index, BuildContext context) {
    if (widget.currentIndex != index) {
      widget.onTap(index);
      Navigator.of(context).pushReplacementNamed(_navigationRoutes[index]!);
    }
  }

  void _handleHover(int index, bool isHovering) {
    setState(() {
      _isHovering[index] = isHovering;
    });

    if (widget.currentIndex != index) {
      if (isHovering) {
        _hoverControllers[index].forward();
      } else {
        _hoverControllers[index].reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      margin: const EdgeInsets.all(10),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 60,
          decoration: BoxDecoration(
            // Cambio del background: usar color sólido como en el CSS
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                Icons.home_outlined,
                Icons.home_filled,
                0,
                context,
              ), // Inicio
              _buildNavItem(
                Icons.search_outlined,
                Icons.search,
                1,
                context,
              ), // Buscar
              _buildNavItem(
                Icons.calendar_today_outlined,
                Icons.calendar_month,
                2,
                context,
              ), // Reservas
              _buildNavItem(
                Icons.favorite_outline,
                Icons.favorite,
                3,
                context,
              ), // Favoritos
              _buildNavItem(
                Icons.person_outline,
                Icons.person,
                4,
                context,
              ), // Perfil
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData outlineIcon,
    IconData filledIcon,
    int index,
    BuildContext context,
  ) {
    final isSelected = widget.currentIndex == index;

    return Expanded(
      child: MouseRegion(
        onEnter: (_) => _handleHover(index, true),
        onExit: (_) => _handleHover(index, false),
        child: GestureDetector(
          onTap: () => _handleTap(index, context),
          behavior: HitTestBehavior.translucent,
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _controllers[index],
              _hoverControllers[index],
            ]),
            builder: (context, child) {
              // Determinar el color del icono
              Color iconColor;
              double opacity = 1.0;

              if (isSelected) {
                iconColor = AppColors.navBarIconActive;
              } else if (_isHovering[index]) {
                iconColor =
                    _hoverColorAnimations[index].value ?? AppColors.gray;
                opacity = _hoverOpacityAnimations[index].value;
              } else {
                iconColor = AppColors.navBarIconInactive;
              }

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0, _marginAnimations[index].value),
                      child: Transform.scale(
                        scale: _scaleAnimations[index].value,
                        child: Opacity(
                          opacity: opacity,
                          child: Icon(
                            isSelected ? filledIcon : outlineIcon,
                            color: iconColor,
                            size: 18, // Tamaño igual al CSS (14px)
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _indicatorAnimations[index].value * 11,
                      height: 2,
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
