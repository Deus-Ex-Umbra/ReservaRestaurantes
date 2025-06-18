import 'package:flutter/material.dart';
import 'dart:math' as math;

class FoodBackgroundWidget extends StatefulWidget {
  final Widget child;

  const FoodBackgroundWidget({Key? key, required this.child}) : super(key: key);

  @override
  _FoodBackgroundWidgetState createState() => _FoodBackgroundWidgetState();
}

class _FoodBackgroundWidgetState extends State<FoodBackgroundWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 30),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller);
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF8DC).withOpacity(0.9),
            Color(0xFFFFFAF0).withOpacity(0.9),
            Color(0xFFFDF5E6).withOpacity(0.9),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Ingredientes flotantes (reducidos a 8)
          ...List.generate(8, (index) => _buildFloatingIngredient(index)),

          // Plato con waffles ultra realistas
          Positioned(
            top: -50,
            right: -50,
            child: _buildUltraRealisticWaffleStack(),
          ),

          // Contenido principal
          widget.child,
        ],
      ),
    );
  }

  Widget _buildUltraRealisticWaffleStack() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value * 0.03,
          child: Container(
            width: 420,
            height: 420,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Plato con detalles ultra realistas
                _buildUltraRealisticPlate(),

                // Waffle inferior con textura mejorada y efecto 3D
                Positioned(
                  bottom: 50,
                  child: _buildWaffle(
                    size: 240,
                    color: Color(0xFFE6B800),
                    borderColor: Color(0xFFB8860B),
                    darkerColor: Color(0xFFA67C00),
                    elevation: 12,
                    thickness: 18,
                  ),
                ),

                // Waffle superior con textura mejorada y efecto 3D
                Positioned(
                  top: 50,
                  child: _buildWaffle(
                    size: 220,
                    color: Color(0xFFFFD700),
                    borderColor: Color(0xFFDAA520),
                    darkerColor: Color(0xFFC9A227),
                    elevation: 16,
                    thickness: 16,
                  ),
                ),

                // Crema batida con textura ultra realista
                Positioned(top: 130, child: _buildUltraRealisticWhippedCream()),

                // Frutas con detalles ultra realistas
                _buildUltraRealisticFruits(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUltraRealisticPlate() {
    return Container(
      width: 380,
      height: 380,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color(0xFFF8F8FF),
            Color(0xFFE6E6FA),
            Color(0xFFD8D8F0),
            Color(0xFFC0C0D0),
          ],
          stops: [0.0, 0.5, 0.8, 1.0],
          center: Alignment(-0.1, -0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 40,
            spreadRadius: 2,
            offset: Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: -10,
            offset: Offset(0, -15),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Reflejos en el plato
          Positioned(
            top: 60,
            left: 60,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.4), Colors.transparent],
                  stops: [0.0, 0.8],
                ),
              ),
            ),
          ),

          // Patrón de plato con más detalles
          CustomPaint(painter: _UltraRealisticPlatePatternPainter()),

          // Borde del plato con reflejo metálico
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.6),
                width: 2.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaffle({
    required double size,
    required Color color,
    required Color borderColor,
    required Color darkerColor,
    required double elevation,
    required double thickness,
  }) {
    return Transform(
      transform: Matrix4.rotationZ(math.pi / 20),
      child: Stack(
        children: [
          // Sombra del waffle para efecto de grosor
          Positioned(
            bottom: -thickness * 0.5,
            left: 0,
            right: 0,
            child: Container(
              height: thickness * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: elevation * 0.8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),

          // Cuerpo principal del waffle con efecto 3D
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, darkerColor, darkerColor],
                stops: [0.0, 0.7, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: elevation,
                  offset: Offset(0, elevation * 0.6),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(-5, -5),
                ),
              ],
              border: Border.all(color: borderColor.withOpacity(0.9), width: 3),
            ),
            child: Stack(
              children: [
                // Efecto de borde dorado
                Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color(0xFFFFF176).withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                ),

                // Textura del waffle con profundidad mejorada
                CustomPaint(
                  painter: _UltraRealisticWafflePainter(
                    cellCount: 8,
                    lightColor: color,
                    darkColor: darkerColor,
                    thickness: thickness,
                  ),
                ),

                // Brillo en los bordes
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Efecto de costado para dar grosor
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: thickness,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    darkerColor.withOpacity(0.8),
                    darkerColor.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUltraRealisticWhippedCream() {
    return Transform.rotate(
      angle: -math.pi / 10,
      child: Container(
        width: 160,
        height: 120,
        child: Stack(
          children: [
            // Base de la crema con sombra y profundidad
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80),
                  topRight: Radius.circular(80),
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFCF5),
                    Color(0xFFF5F5F5),
                    Color(0xFFE8E8E8),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                    spreadRadius: -2,
                  ),
                ],
              ),
            ),

            // Textura de la crema con más detalles
            CustomPaint(painter: _UltraRealisticWhippedCreamPainter()),

            // Gotas de crema más realistas
            ...List.generate(4, (index) {
              return Positioned(
                bottom: 5 + index * 5,
                left: 20 + index * 30,
                child: Container(
                  width: 12 + index * 2,
                  height: 20 + index * 3,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFCF5),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              );
            }),

            // Reflejos en la crema
            Positioned(
              top: 10,
              left: 20,
              child: Container(
                width: 40,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUltraRealisticFruits() {
    return Container(
      width: 380,
      height: 380,
      child: Stack(
        children: [
          // Frambuesas con más detalles
          Positioned(
            top: 70,
            left: 100,
            child: _buildUltraRealisticRaspberry(),
          ),
          Positioned(
            top: 90,
            right: 90,
            child: _buildUltraRealisticRaspberry(),
          ),

          // Arándanos con reflejos mejorados
          Positioned(
            top: 80,
            left: 130,
            child: _buildUltraRealisticBlueberry(),
          ),
          Positioned(
            bottom: 110,
            left: 110,
            child: _buildUltraRealisticBlueberry(),
          ),

          // Fresas con semillas y hojas más realistas
          Positioned(
            top: 150,
            left: 90,
            child: _buildUltraRealisticStrawberry(),
          ),
          Positioned(
            bottom: 70,
            right: 100,
            child: _buildUltraRealisticStrawberry(),
          ),

          // Hojas de menta para decoración
          Positioned(
            top: 60,
            right: 130,
            child: _buildUltraRealisticMintLeaf(),
          ),
          Positioned(
            bottom: 90,
            left: 130,
            child: _buildUltraRealisticMintLeaf(),
          ),
        ],
      ),
    );
  }

  Widget _buildUltraRealisticRaspberry() {
    return Container(
      width: 32,
      height: 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cuerpo principal con sombra y gradiente mejorado
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFE91E63),
                  Color(0xFFC2185B),
                  Color(0xFF9C0D38),
                  Color(0xFF7B0030),
                ],
                stops: [0.0, 0.5, 0.8, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF7B0030).withOpacity(0.6),
                  blurRadius: 12,
                  offset: Offset(0, 5),
                  spreadRadius: 1,
                ),
              ],
            ),
          ),

          // Textura de drupelets con sombras
          ...List.generate(14, (index) {
            final angle = index * math.pi / 7;
            final distance = 11.0;
            return Positioned(
              left: 14 + distance * math.cos(angle),
              top: 14 + distance * math.sin(angle),
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0xFFFF4081), Color(0xFFE91E63)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            );
          }),

          // Hojas con textura
          Positioned(
            top: 0,
            left: 5,
            child: Transform.rotate(
              angle: -math.pi / 6,
              child: Container(
                width: 20,
                height: 10,
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF81C784),
                      Color(0xFF4CAF50),
                      Color(0xFF388E3C),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: CustomPaint(painter: _LeafVeinsPainter()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUltraRealisticBlueberry() {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color(0xFF3F51B5),
            Color(0xFF303F9F),
            Color(0xFF1A237E),
            Color(0xFF0D1238),
          ],
          stops: [0.0, 0.5, 0.8, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1A237E).withOpacity(0.6),
            blurRadius: 10,
            offset: Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Brillo más natural
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.8), Colors.transparent],
                  stops: [0.0, 0.8],
                ),
              ),
            ),
          ),

          // Cicatriz floral con más detalles
          Positioned(
            top: 3,
            left: 9,
            child: Container(
              width: 8,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFF8BC34A),
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFAED581), Color(0xFF689F38)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUltraRealisticStrawberry() {
    return Container(
      width: 36,
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cuerpo principal con gradiente mejorado
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFF44336),
                  Color(0xFFD32F2F),
                  Color(0xFFB71C1C),
                  Color(0xFF8C001A),
                ],
                stops: [0.0, 0.5, 0.8, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF8C001A).withOpacity(0.6),
                  blurRadius: 12,
                  offset: Offset(0, 5),
                  spreadRadius: 1,
                ),
              ],
            ),
          ),

          // Semillas con sombras y posición más natural
          ...List.generate(24, (index) {
            final angle = index * math.pi / 12;
            final distance = 14.0;
            final seedSize = 1.5 + (index % 3) * 0.5;
            return Positioned(
              left: 16 + distance * math.cos(angle),
              top: 16 + distance * math.sin(angle),
              child: Transform.rotate(
                angle: angle,
                child: Container(
                  width: seedSize,
                  height: seedSize * 1.5,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFEB3B),
                    borderRadius: BorderRadius.circular(seedSize / 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Hojas con textura y gradiente
          Positioned(
            top: 0,
            child: Container(
              width: 24,
              height: 12,
              decoration: BoxDecoration(
                color: Color(0xFF4CAF50),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF81C784),
                    Color(0xFF4CAF50),
                    Color(0xFF388E3C),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: CustomPaint(painter: _LeafVeinsPainter()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUltraRealisticMintLeaf() {
    return Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Color(0xFF81C784),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFA5D6A7), Color(0xFF81C784), Color(0xFF66BB6A)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: CustomPaint(painter: _LeafVeinsPainter()),
      ),
    );
  }

  Widget _buildFloatingIngredient(int index) {
    final random = math.Random(index);
    final double top = random.nextDouble() * MediaQuery.of(context).size.height;
    final double left = random.nextDouble() * MediaQuery.of(context).size.width;
    final double size = 24 + random.nextDouble() * 20;
    final double opacity = 0.15 + random.nextDouble() * 0.15;
    final double speed = 0.5 + random.nextDouble() * 0.7;
    final int type = index % 4;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: top + 20 * math.sin(_animation.value * speed + index),
          left: left + 20 * math.cos(_animation.value * speed + index),
          child: Opacity(
            opacity: opacity,
            child: Transform.rotate(
              angle: _animation.value * speed,
              child: Container(
                width: size,
                height: size,
                child: _buildIngredientByType(type, size),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIngredientByType(int type, double size) {
    switch (type) {
      case 0: // Fresa
        return _buildMiniStrawberry(size);
      case 1: // Arándano
        return _buildMiniBlueberry(size);
      case 2: // Frambuesa
        return _buildMiniRaspberry(size);
      case 3: // Hoja de menta
      default:
        return _buildMintLeaf(size);
    }
  }

  Widget _buildMiniStrawberry(double size) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color(0xFFF44336).withOpacity(0.9),
            Color(0xFFD32F2F).withOpacity(0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD32F2F).withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.35,
          height: size * 0.18,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF81C784).withOpacity(0.8),
                Color(0xFF4CAF50).withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(size * 0.12),
              topRight: Radius.circular(size * 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniBlueberry(double size) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color(0xFF3F51B5).withOpacity(0.9),
            Color(0xFF303F9F).withOpacity(0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF303F9F).withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.25,
          height: size * 0.12,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFAED581).withOpacity(0.8),
                Color(0xFF689F38).withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(size * 0.06),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniRaspberry(double size) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color(0xFFE91E63).withOpacity(0.9),
            Color(0xFFC2185B).withOpacity(0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFC2185B).withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.3,
          height: size * 0.15,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF81C784).withOpacity(0.8),
                Color(0xFF4CAF50).withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(size * 0.08),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMintLeaf(double size) {
    return Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Color(0xFF81C784).withOpacity(0.8),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size * 0.7),
            bottomRight: Radius.circular(size * 0.7),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _UltraRealisticWafflePainter extends CustomPainter {
  final int cellCount;
  final Color lightColor;
  final Color darkColor;
  final double thickness;

  _UltraRealisticWafflePainter({
    required this.cellCount,
    required this.lightColor,
    required this.darkColor,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / cellCount;
    final cellHeight = size.height / cellCount;
    final centerOffset = thickness * 0.3;

    // Pintar las celdas con efecto 3D
    final cellPaint = Paint()..style = PaintingStyle.fill;
    final highlightPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..style = PaintingStyle.fill;

    for (int row = 0; row < cellCount; row++) {
      for (int col = 0; col < cellCount; col++) {
        final center = Offset(
          col * cellWidth + cellWidth / 2,
          row * cellHeight + cellHeight / 2,
        );
        final radius = cellWidth / 2.8;

        // Efecto de profundidad alternando colores
        cellPaint.color =
            (row + col) % 2 == 0
                ? lightColor.withOpacity(0.85)
                : darkColor.withOpacity(0.95);

        // Dibujar celda con sombra interior para efecto 3D
        canvas.drawCircle(center, radius, cellPaint);

        // Efecto de profundidad en el borde inferior derecho
        final shadowPath =
            Path()..addArc(
              Rect.fromCircle(center: center, radius: radius),
              0,
              math.pi * 2,
            );

        cellPaint.shader = RadialGradient(
          colors: [Colors.transparent, Colors.black.withOpacity(0.15)],
          stops: [0.7, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius));

        canvas.drawPath(shadowPath, cellPaint);
        cellPaint.shader = null;

        // Destello en algunas celdas
        if ((row + col) % 3 == 0) {
          final highlightCenter = Offset(
            center.dx - centerOffset,
            center.dy - centerOffset,
          );
          canvas.drawCircle(highlightCenter, radius / 3, highlightPaint);
        }
      }
    }

    // Dibujar líneas de la cuadrícula con efecto de profundidad
    final gridPaint =
        Paint()
          ..color = darkColor.withOpacity(0.8)
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke;

    final gridHighlightPaint =
        Paint()
          ..color = lightColor.withOpacity(0.4)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

    for (int i = 1; i < cellCount; i++) {
      // Líneas verticales
      final vLinePath =
          Path()
            ..moveTo(i * cellWidth, 0)
            ..lineTo(i * cellWidth, size.height);

      // Sombra en el lado derecho de la línea vertical
      gridPaint.shader = LinearGradient(
        colors: [Colors.black.withOpacity(0.3), Colors.transparent],
        stops: [0.0, 0.3],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      ).createShader(
        Rect.fromLTRB(i * cellWidth, 0, i * cellWidth + 5, size.height),
      );

      canvas.drawPath(vLinePath, gridPaint);
      gridPaint.shader = null;

      // Resaltado en el lado izquierdo de la línea vertical
      canvas.drawPath(vLinePath, gridHighlightPaint);

      // Líneas horizontales
      final hLinePath =
          Path()
            ..moveTo(0, i * cellHeight)
            ..lineTo(size.width, i * cellHeight);

      // Sombra en el lado inferior de la línea horizontal
      gridPaint.shader = LinearGradient(
        colors: [Colors.black.withOpacity(0.3), Colors.transparent],
        stops: [0.0, 0.3],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ).createShader(
        Rect.fromLTRB(0, i * cellHeight, size.width, i * cellHeight + 5),
      );

      canvas.drawPath(hLinePath, gridPaint);
      gridPaint.shader = null;

      // Resaltado en el lado superior de la línea horizontal
      canvas.drawPath(hLinePath, gridHighlightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _UltraRealisticWhippedCreamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.95)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2
          ..strokeCap = StrokeCap.round;

    final fillPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.fill;

    // Dibujar remolinos de crema con relleno
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Remolino principal con relleno
    final mainSwirl =
        Path()
          ..moveTo(center.dx - radius * 0.7, center.dy - radius * 0.3)
          ..quadraticBezierTo(
            center.dx,
            center.dy - radius * 0.8,
            center.dx + radius * 0.7,
            center.dy - radius * 0.3,
          )
          ..quadraticBezierTo(
            center.dx,
            center.dy + radius * 0.4,
            center.dx - radius * 0.7,
            center.dy - radius * 0.3,
          );

    canvas.drawPath(mainSwirl, fillPaint);
    canvas.drawPath(mainSwirl, paint);

    // Remolinos secundarios con más detalles
    for (int i = 0; i < 3; i++) {
      final offset = i * 0.3 - 0.3;
      final smallSwirl =
          Path()
            ..moveTo(
              center.dx - radius * 0.5,
              center.dy - radius * 0.1 + offset,
            )
            ..quadraticBezierTo(
              center.dx,
              center.dy - radius * 0.5 + offset,
              center.dx + radius * 0.5,
              center.dy - radius * 0.1 + offset,
            );

      canvas.drawPath(smallSwirl, paint);

      // Pequeños puntos para textura
      if (i % 2 == 0) {
        for (double t = 0.0; t <= 1.0; t += 0.1) {
          final p =
              smallSwirl
                  .computeMetrics()
                  .first
                  .getTangentForOffset(
                    t * smallSwirl.computeMetrics().first.length,
                  )
                  ?.position;
          if (p != null) {
            canvas.drawCircle(p, 1.2, paint);
          }
        }
      }
    }

    // Textura de burbujas pequeñas
    final random = math.Random(42);
    for (int i = 0; i < 15; i++) {
      final bubbleX = random.nextDouble() * size.width;
      final bubbleY =
          random.nextDouble() * size.height * 0.6 + size.height * 0.2;
      final bubbleSize = 1.0 + random.nextDouble() * 2.0;
      canvas.drawCircle(
        Offset(bubbleX, bubbleY),
        bubbleSize,
        Paint()
          ..color = Colors.white.withOpacity(0.7)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _UltraRealisticPlatePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;

    final highlightPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8;

    // Dibujar patrón circular concéntrico con efecto de profundidad
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (
      double r = maxRadius * 0.7;
      r > maxRadius * 0.3;
      r -= maxRadius * 0.1
    ) {
      // Sombra en la parte inferior del anillo
      paint.shader = SweepGradient(
        colors: [
          Colors.transparent,
          Colors.black.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: [0.0, 0.5, 1.0],
        transform: GradientRotation(math.pi * 1.25),
      ).createShader(Rect.fromCircle(center: center, radius: r));

      canvas.drawCircle(center, r, paint);
      paint.shader = null;

      // Resaltado en la parte superior del anillo
      highlightPaint.shader = SweepGradient(
        colors: [
          Colors.transparent,
          Colors.white.withOpacity(0.3),
          Colors.transparent,
        ],
        stops: [0.0, 0.5, 1.0],
        transform: GradientRotation(math.pi * 0.25),
      ).createShader(Rect.fromCircle(center: center, radius: r));

      canvas.drawCircle(center, r, highlightPaint);
      highlightPaint.shader = null;
    }

    // Dibujar líneas radiales con efecto de profundidad
    for (int i = 0; i < 16; i++) {
      final angle = i * math.pi / 8;
      final lineEnd = Offset(
        center.dx + maxRadius * 0.7 * math.cos(angle),
        center.dy + maxRadius * 0.7 * math.sin(angle),
      );

      // Sombra en un lado de la línea
      paint.shader = LinearGradient(
        colors: [Colors.black.withOpacity(0.1), Colors.transparent],
        stops: [0.0, 0.5],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        transform: GradientRotation(angle + math.pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius * 0.7));

      canvas.drawLine(center, lineEnd, paint);
      paint.shader = null;

      // Resaltado en el otro lado de la línea
      highlightPaint.shader = LinearGradient(
        colors: [Colors.white.withOpacity(0.3), Colors.transparent],
        stops: [0.0, 0.5],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        transform: GradientRotation(angle + math.pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius * 0.7));

      canvas.drawLine(center, lineEnd, highlightPaint);
      highlightPaint.shader = null;
    }

    // Patrón decorativo central
    final centerPatternPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.4)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, maxRadius * 0.1, centerPatternPaint);

    final centerPatternStrokePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    canvas.drawCircle(center, maxRadius * 0.1, centerPatternStrokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LeafVeinsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Color(0xFF388E3C).withOpacity(0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..strokeCap = StrokeCap.round;

    // Línea central
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );

    // Venas laterales
    for (int i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(0, y + size.height / 8),
        paint,
      );
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width, y + size.height / 8),
        paint,
      );
    }

    // Pequeñas venas
    final smallPaint =
        Paint()
          ..color = Color(0xFF388E3C).withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..strokeCap = StrokeCap.round;

    for (int i = 1; i < 6; i++) {
      final y = size.height * i / 6;
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 4, y + size.height / 12),
        smallPaint,
      );
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width * 3 / 4, y + size.height / 12),
        smallPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
