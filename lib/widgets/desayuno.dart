import 'package:flutter/material.dart';
import 'dart:math' as math;

class BreakfastBackground extends StatefulWidget {
  final Widget? child;
  final int floatingItemsCount;

  const BreakfastBackground({
    Key? key,
    this.child,
    this.floatingItemsCount = 12,
  }) : super(key: key);

  @override
  _BreakfastBackgroundState createState() => _BreakfastBackgroundState();
}

class _BreakfastBackgroundState extends State<BreakfastBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<Offset> _positions = [];
  final List<double> _sizes = [];
  final List<double> _speeds = [];
  final List<double> _rotations = [];
  final List<int> _types = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller);

    final random = math.Random();
    for (int i = 0; i < widget.floatingItemsCount; i++) {
      // Distribución más dispersa evitando el área del plato
      double x, y;
      do {
        x = random.nextDouble();
        y = random.nextDouble();
      } while (_isNearPlate(x, y)); // Evita el área del plato

      _positions.add(Offset(x, y));
      _sizes.add(random.nextDouble() * 30 + 40); // Tamaños más grandes
      _speeds.add(random.nextDouble() * 0.4 + 0.3);
      _rotations.add(random.nextDouble() * math.pi * 2);
      _types.add(random.nextInt(3)); // 0: huevo, 1: tocino, 2: salchicha
    }
  }

  bool _isNearPlate(double x, double y) {
    // Evita el área donde está el plato (esquina superior derecha)
    return (x > 0.4 && y < 0.6);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF8DC), Color(0xFFFFF5E6), Color(0xFFFFFAF0)],
        ),
      ),
      child: Stack(
        children: [
          // Plato redondo más grande en esquina superior derecha
          Positioned(
            top: size.height * 0.02,
            right: size.width * 0.02,
            child: _buildBreakfastPlate(size.width * 0.65), // Más grande
          ),

          // Elementos flotantes
          ...List.generate(widget.floatingItemsCount, (index) {
            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final offsetX =
                    math.sin(_animation.value * _speeds[index] + index) * 0.08;
                final offsetY =
                    math.cos(_animation.value * _speeds[index] + index) * 0.08;
                final rotation =
                    _rotations[index] + _animation.value * _speeds[index] * 0.2;

                return Positioned(
                  left:
                      _positions[index].dx * size.width + offsetX * size.width,
                  top:
                      _positions[index].dy * size.height +
                      offsetY * size.height,
                  child: Transform.rotate(
                    angle: rotation,
                    child: Opacity(
                      opacity: 0.3,
                      child: _buildFloatingFoodItem(
                        _types[index],
                        _sizes[index],
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }

  Widget _buildBreakfastPlate(double diameter) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            spreadRadius: 3,
            offset: const Offset(8, 15),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            blurRadius: 20,
            spreadRadius: 3,
            offset: const Offset(-8, -8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Plato interior con sombra más profunda
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.all(diameter * 0.04),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),

          // Huevos más grandes y realistas
          Positioned(
            left: diameter * 0.15,
            top: diameter * 0.2,
            child: _buildRealisticEgg(diameter * 0.35),
          ),
          Positioned(
            right: diameter * 0.15,
            top: diameter * 0.2,
            child: _buildRealisticEgg(diameter * 0.35),
          ),

          // Más tiras de tocino con diferentes ángulos
          Positioned(
            left: diameter * 0.12,
            bottom: diameter * 0.25,
            child: _buildRealisticBacon(diameter * 0.3),
          ),
          Positioned(
            left: diameter * 0.32,
            bottom: diameter * 0.28,
            child: Transform.rotate(
              angle: -math.pi / 8,
              child: _buildRealisticBacon(diameter * 0.28),
            ),
          ),
          Positioned(
            right: diameter * 0.18,
            bottom: diameter * 0.25,
            child: Transform.rotate(
              angle: math.pi / 6,
              child: _buildRealisticBacon(diameter * 0.32),
            ),
          ),
          Positioned(
            right: diameter * 0.35,
            bottom: diameter * 0.22,
            child: Transform.rotate(
              angle: -math.pi / 4,
              child: _buildRealisticBacon(diameter * 0.26),
            ),
          ),

          // Salchichas más grandes y realistas
          Positioned(
            left: diameter * 0.2,
            top: diameter * 0.58,
            child: _buildRealisticSausage(diameter * 0.45),
          ),
          Positioned(
            right: diameter * 0.2,
            top: diameter * 0.58,
            child: _buildRealisticSausage(diameter * 0.45),
          ),
        ],
      ),
    );
  }

  Widget _buildRealisticEgg(double size) {
    return Container(
      width: size,
      height: size * 0.85,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          colors: [
            const Color(0xFFFFFFF0),
            const Color(0xFFFFF8E1),
            const Color(0xFFFFF0E6),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size * 0.5),
          topRight: Radius.circular(size * 0.5),
          bottomLeft: Radius.circular(size * 0.25),
          bottomRight: Radius.circular(size * 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(3, 6),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 8,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Yema más realista
          Positioned(
            left: size * 0.2,
            top: size * 0.18,
            child: Container(
              width: size * 0.6,
              height: size * 0.5,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  colors: [
                    const Color(0xFFFFE082),
                    const Color(0xFFFFD54F),
                    const Color(0xFFFFB74D),
                  ],
                ),
                borderRadius: BorderRadius.circular(size * 0.3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          // Brillo en la yema
          Positioned(
            left: size * 0.25,
            top: size * 0.22,
            child: Container(
              width: size * 0.15,
              height: size * 0.15,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Textura de clara
          Positioned(
            right: size * 0.08,
            top: size * 0.12,
            child: Container(
              width: size * 0.18,
              height: size * 0.18,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealisticBacon(double size) {
    return Container(
      width: size,
      height: size * 0.28,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF8B4513),
            const Color(0xFFD2691E),
            const Color(0xFFA0522D),
            const Color(0xFF8B4513),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
          transform: const GradientRotation(math.pi / 6),
        ),
        borderRadius: BorderRadius.circular(size * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(3, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Múltiples vetas de grasa
          Positioned(
            left: size * 0.15,
            top: 0,
            bottom: 0,
            child: Container(
              width: size * 0.08,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1).withOpacity(0.9),
                borderRadius: BorderRadius.circular(size * 0.04),
              ),
            ),
          ),
          Positioned(
            left: size * 0.4,
            top: 0,
            bottom: 0,
            child: Container(
              width: size * 0.12,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1).withOpacity(0.8),
                borderRadius: BorderRadius.circular(size * 0.04),
              ),
            ),
          ),
          Positioned(
            left: size * 0.65,
            top: 0,
            bottom: 0,
            child: Container(
              width: size * 0.06,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1).withOpacity(0.7),
                borderRadius: BorderRadius.circular(size * 0.04),
              ),
            ),
          ),
          // Textura crujiente en los bordes
          Positioned(
            left: 0,
            right: 0,
            top: size * 0.02,
            child: Container(
              height: size * 0.03,
              decoration: BoxDecoration(
                color: const Color(0xFF654321).withOpacity(0.6),
                borderRadius: BorderRadius.circular(size * 0.02),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: size * 0.02,
            child: Container(
              height: size * 0.03,
              decoration: BoxDecoration(
                color: const Color(0xFF654321).withOpacity(0.6),
                borderRadius: BorderRadius.circular(size * 0.02),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealisticSausage(double length) {
    return Container(
      width: length,
      height: length * 0.18,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFD2691E),
            const Color(0xFFCD853F),
            const Color(0xFFF4A460),
            const Color(0xFFD2691E),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
        borderRadius: BorderRadius.circular(length * 0.09),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(3, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Múltiples rayas de parrilla
          ...List.generate(5, (index) {
            return Positioned(
              top: length * 0.02 + (index * length * 0.025),
              left: length * 0.1,
              right: length * 0.1,
              child: Container(
                height: 1.5,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          }),
          // Extremos más realistas
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: length * 0.12,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [const Color(0xFFA0522D), const Color(0xFF8B4513)],
                ),
                borderRadius: BorderRadius.circular(length * 0.09),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: length * 0.12,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [const Color(0xFFA0522D), const Color(0xFF8B4513)],
                ),
                borderRadius: BorderRadius.circular(length * 0.09),
              ),
            ),
          ),
          // Brillo superior
          Positioned(
            top: length * 0.02,
            left: length * 0.2,
            right: length * 0.2,
            child: Container(
              height: length * 0.04,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(length * 0.02),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingFoodItem(int type, double size) {
    switch (type) {
      case 0:
        return _buildFloatingRealisticEgg(size);
      case 1:
        return _buildFloatingRealisticBacon(size);
      case 2:
        return _buildFloatingRealisticSausage(size);
      default:
        return _buildFloatingRealisticEgg(size);
    }
  }

  Widget _buildFloatingRealisticEgg(double size) {
    return Container(
      width: size,
      height: size * 0.8,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          colors: [
            const Color(0xFFFFFFF0).withOpacity(0.9),
            const Color(0xFFFFF8E1).withOpacity(0.8),
            const Color(0xFFFFF0E6).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size * 0.5),
          topRight: Radius.circular(size * 0.5),
          bottomLeft: Radius.circular(size * 0.25),
          bottomRight: Radius.circular(size * 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Yema flotante
          Positioned(
            left: size * 0.2,
            top: size * 0.15,
            child: Container(
              width: size * 0.6,
              height: size * 0.5,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFE082).withOpacity(0.9),
                    const Color(0xFFFFD54F).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(size * 0.3),
              ),
            ),
          ),
          // Brillo
          Positioned(
            left: size * 0.25,
            top: size * 0.18,
            child: Container(
              width: size * 0.12,
              height: size * 0.12,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingRealisticBacon(double size) {
    return Transform.rotate(
      angle: math.pi / 8,
      child: Container(
        width: size,
        height: size * 0.25,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF8B4513).withOpacity(0.9),
              const Color(0xFFD2691E).withOpacity(0.8),
              const Color(0xFFA0522D).withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(size * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Vetas de grasa flotantes
            Positioned(
              left: size * 0.2,
              top: 0,
              bottom: 0,
              child: Container(
                width: size * 0.08,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(size * 0.04),
                ),
              ),
            ),
            Positioned(
              left: size * 0.5,
              top: 0,
              bottom: 0,
              child: Container(
                width: size * 0.1,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(size * 0.04),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingRealisticSausage(double size) {
    return Container(
      width: size,
      height: size * 0.18,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFD2691E).withOpacity(0.9),
            const Color(0xFFCD853F).withOpacity(0.8),
            const Color(0xFFF4A460).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.09),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Rayas de parrilla flotantes
          Positioned(
            top: size * 0.03,
            left: size * 0.1,
            right: size * 0.1,
            child: Container(height: 1, color: Colors.black.withOpacity(0.3)),
          ),
          Positioned(
            top: size * 0.08,
            left: size * 0.1,
            right: size * 0.1,
            child: Container(height: 1, color: Colors.black.withOpacity(0.3)),
          ),
          Positioned(
            top: size * 0.13,
            left: size * 0.1,
            right: size * 0.1,
            child: Container(height: 1, color: Colors.black.withOpacity(0.3)),
          ),
          // Extremos redondeados
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: size * 0.1,
              decoration: BoxDecoration(
                color: const Color(0xFFA0522D).withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: size * 0.1,
              decoration: BoxDecoration(
                color: const Color(0xFFA0522D).withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
