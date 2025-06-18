import 'package:flutter/material.dart';
import 'dart:math';

class PizzaBackground extends StatefulWidget {
  final Widget? child;

  const PizzaBackground({Key? key, this.child}) : super(key: key);

  @override
  State<PizzaBackground> createState() => _PizzaBackgroundState();
}

class _PizzaBackgroundState extends State<PizzaBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF8E1), Color(0xFFFFF3C4), Color(0xFFFFF8E1)],
        ),
      ),
      child: Stack(
        children: [
          // Círculo amarillo principal
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFD54F).withOpacity(0.8),
                    const Color(0xFFFFA726).withOpacity(0.6),
                    const Color(0xFFFFA726).withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),

          // Pala de pizza (debajo de la pizza)
          Positioned(
            top: 220,
            right: -20,
            child: Transform.rotate(
              angle: 0.1,
              child: Container(
                width: 300,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFD2691E),
                      Color(0xFFA0522D),
                      Color(0xFF8B4513),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(5, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Textura de madera
                    Positioned(
                      top: 8,
                      left: 20,
                      right: 20,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFF654321).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 30,
                      right: 30,
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          color: const Color(0xFF654321).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 25,
                      right: 25,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFF654321).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                    // Mango de la pala
                    Positioned(
                      right: -50,
                      top: 10,
                      child: Container(
                        width: 100,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8B4513), Color(0xFF654321)],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Hoja verde decorativa
          Positioned(
            top: 20,
            right: 50,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: 120,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 2,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Pizza principal (más grande)
          Positioned(
            top: 40,
            right: -20,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFB74D),
                    Color(0xFFF57C00),
                    Color(0xFFE65100),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(8, 12),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Borde de la pizza (corteza)
                  Positioned(
                    top: 5,
                    left: 5,
                    right: 5,
                    bottom: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFDEB887), Color(0xFFCD853F)],
                        ),
                      ),
                    ),
                  ),
                  // Base de queso
                  Positioned(
                    top: 25,
                    left: 25,
                    right: 25,
                    bottom: 25,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFF9C4), Color(0xFFFFF176)],
                        ),
                      ),
                    ),
                  ),

                  // Pepperoni realistas
                  Positioned(
                    top: 60,
                    left: 80,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [
                            Color(0xFFFF6B6B),
                            Color(0xFFD32F2F),
                            Color(0xFFB71C1C),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Textura del pepperoni
                          Positioned(
                            top: 8,
                            left: 10,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF8B0000),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 15,
                            left: 20,
                            child: Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF8B0000),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 12,
                            child: Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF8B0000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Más pepperonis
                  Positioned(
                    top: 120,
                    left: 140,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [
                            Color(0xFFFF6B6B),
                            Color(0xFFD32F2F),
                            Color(0xFFB71C1C),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 6,
                            left: 8,
                            child: Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF8B0000),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 15,
                            left: 18,
                            child: Container(
                              width: 2,
                              height: 2,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF8B0000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    top: 180,
                    left: 100,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [
                            Color(0xFFFF6B6B),
                            Color(0xFFD32F2F),
                            Color(0xFFB71C1C),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Aceitunas negras realistas
                  Positioned(
                    top: 90,
                    left: 160,
                    child: Container(
                      width: 18,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1B5E20), Color(0xFF0D2818)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 4,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF4CAF50).withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 140,
                    left: 70,
                    child: Container(
                      width: 16,
                      height: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1B5E20), Color(0xFF0D2818)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 4,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Hongos
                  Positioned(
                    top: 100,
                    left: 120,
                    child: Container(
                      width: 25,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFBCAAA4), Color(0xFF8D6E63)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 2,
                            left: 8,
                            child: Container(
                              width: 8,
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: const Color(0xFFF5F5F5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Ingredientes flotantes animados con más detalles
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Stack(
                children: [
                  // Tomate realista flotante
                  Positioned(
                    top: 150 + sin(_animation.value) * 10,
                    left: 50 + cos(_animation.value * 0.8) * 15,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [
                            Color(0xFFFF6B6B),
                            Color(0xFFFF5722),
                            Color(0xFFD32F2F),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Brillo del tomate
                          Positioned(
                            top: 8,
                            left: 10,
                            child: Container(
                              width: 12,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: const Color(0xFFFFCDD2).withOpacity(0.8),
                              ),
                            ),
                          ),
                          // Hoja del tomate
                          Positioned(
                            top: -2,
                            left: 12,
                            child: Container(
                              width: 12,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: const Color(0xFF4CAF50),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Pimiento verde realista
                  Positioned(
                    top: 250 + cos(_animation.value * 1.2) * 12,
                    left: 80 + sin(_animation.value * 0.9) * 8,
                    child: Transform.rotate(
                      angle: _animation.value * 0.5,
                      child: Container(
                        width: 30,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF66BB6A),
                              Color(0xFF4CAF50),
                              Color(0xFF388E3C),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(1, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Brillo del pimiento
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                width: 8,
                                height: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: const Color(
                                    0xFFC8E6C9,
                                  ).withOpacity(0.6),
                                ),
                              ),
                            ),
                            // Tallo del pimiento
                            Positioned(
                              top: -3,
                              left: 12,
                              child: Container(
                                width: 6,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: const Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Queso derretido flotante
                  Positioned(
                    top: 350 + sin(_animation.value * 1.5) * 8,
                    left: 120 + cos(_animation.value * 1.1) * 12,
                    child: Container(
                      width: 25,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFFFDE7),
                            Color(0xFFFFF9C4),
                            Color(0xFFFFF176),
                          ],
                        ),
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
                          // Agujeros del queso
                          Positioned(
                            top: 5,
                            left: 6,
                            child: Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFFFE082),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 15,
                            child: Container(
                              width: 2,
                              height: 2,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFFFE082),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Pepperoni flotante mejorado
                  Positioned(
                    top: 200 + cos(_animation.value * 0.7) * 15,
                    right: 100 + sin(_animation.value * 1.3) * 10,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [
                            Color(0xFFFF6B6B),
                            Color(0xFFFF5722),
                            Color(0xFFD32F2F),
                            Color(0xFFB71C1C),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(3, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Textura del pepperoni
                          Positioned(
                            top: 10,
                            left: 12,
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF8B0000),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 25,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF8B0000),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 25,
                            left: 15,
                            child: Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF8B0000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Hoja de albahaca flotante
                  Positioned(
                    top: 400 + sin(_animation.value * 0.6) * 6,
                    right: 50 + cos(_animation.value * 1.4) * 8,
                    child: Transform.rotate(
                      angle: _animation.value * -0.3,
                      child: Container(
                        width: 35,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF81C784),
                              Color(0xFF66BB6A),
                              Color(0xFF4CAF50),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(1, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Vena central de la hoja
                            Positioned(
                              top: 8,
                              left: 17,
                              child: Container(
                                width: 1,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E7D32),
                                  borderRadius: BorderRadius.circular(0.5),
                                ),
                              ),
                            ),
                            // Venas laterales
                            Positioned(
                              top: 10,
                              left: 12,
                              child: Transform.rotate(
                                angle: -0.3,
                                child: Container(
                                  width: 1,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF2E7D32,
                                    ).withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(0.5),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 22,
                              child: Transform.rotate(
                                angle: 0.3,
                                child: Container(
                                  width: 1,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF2E7D32,
                                    ).withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Círculos decorativos de fondo
          Positioned(
            bottom: 100,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFA726).withOpacity(0.1),
              ),
            ),
          ),

          Positioned(
            bottom: -30,
            right: 30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD54F).withOpacity(0.15),
              ),
            ),
          ),

          // Contenido que se pasa como child
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

// Ejemplo de uso:
class ExampleUsage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PizzaBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¡Bienvenido!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Tu contenido aquí',
                style: TextStyle(fontSize: 18, color: Colors.brown[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
