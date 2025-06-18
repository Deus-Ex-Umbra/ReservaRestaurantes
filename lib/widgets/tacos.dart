import 'package:flutter/material.dart';
import 'dart:math';

class TacosPage extends StatelessWidget {
  final Widget? child;
  final double foodOpacity;
  final bool showSaladBowl;
  final bool showBurger;
  final bool showFries;
  final bool showDrink;
  final bool showPizza;
  final bool showTaco;
  final bool showBurrito;

  const TacosPage({
    Key? key,
    this.child,
    this.foodOpacity = 0.15,
    this.showSaladBowl = true,
    this.showBurger = true,
    this.showFries = true,
    this.showDrink = true,
    this.showPizza = true,
    this.showTaco = true,
    this.showBurrito = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFDF5E6), // Very light cream
            Color(0xFFF5F5DC), // Light beige
          ],
        ),
      ),
      child: Stack(
        children: [
          // Floating food items
          if (showSaladBowl) _buildSaladBowl(foodOpacity),
          if (showBurger) _buildBurger(foodOpacity),
          if (showFries) _buildFries(foodOpacity),
          if (showDrink) _buildDrink(foodOpacity),
          if (showPizza) _buildPizza(foodOpacity),
          if (showTaco) _buildTaco(foodOpacity),
          if (showBurrito) _buildBurrito(foodOpacity),

          // Child widget (content)
          if (child != null) child!,
        ],
      ),
    );
  }

  Widget _buildSaladBowl(double opacity) {
    return Positioned(
      top: 50,
      right: 30,
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: 0.2,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.green[50]!.withOpacity(0.8),
                          Colors.green[100]!.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red[300]?.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.green[400]?.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      Container(
                        width: 14,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.green[600]?.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBurger(double opacity) {
    return Positioned(
      bottom: 80,
      left: 40,
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: -0.3,
          child: Container(
            width: 100,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.8),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.orange[100]!.withOpacity(0.9),
                          Colors.orange[200]!.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 12,
                  right: 12,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.green[400]?.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                Positioned(
                  top: 26,
                  left: 15,
                  right: 15,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.red[300]?.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 15,
                  right: 15,
                  child: Container(
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.brown[600]?.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                Positioned(
                  top: 45,
                  left: 12,
                  right: 12,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.yellow[300]?.withOpacity(0.8),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.orange[200]!.withOpacity(0.8),
                          Colors.orange[300]!.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFries(double opacity) {
    return Positioned(
      top: 100,
      left: 30,
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: 0.4,
          child: Column(
            children: [
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.grey[100]!.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      height: 50,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSingleFry(
                              color: Colors.yellow[300]!,
                              darkColor: Colors.orange[300]!,
                            ),
                            _buildSingleFry(
                              color: Colors.yellow[400]!,
                              darkColor: Colors.orange[400]!,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.red[200]!.withOpacity(0.9),
                      Colors.red[300]!.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleFry({required Color color, required Color darkColor}) {
    return Container(
      width: 35,
      height: 8,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.9), darkColor.withOpacity(0.9)],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildDrink(double opacity) {
    return Positioned(
      bottom: 100,
      right: 50,
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: -0.1,
          child: Container(
            width: 70,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue[100]!.withOpacity(0.6),
                          Colors.blue[300]!.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(5),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 15,
                  bottom: 10,
                  child: Container(
                    width: 6,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red[100]!.withOpacity(0.8),
                          Colors.red[300]!.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 5,
                  right: 5,
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.red[100]!.withOpacity(0.9),
                          Colors.red[200]!.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPizza(double opacity) {
    return Positioned(
      top: 200,
      right: 60,
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: 0.5,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.orange[100]!.withOpacity(0.9),
                      Colors.orange[200]!.withOpacity(0.8),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 15,
                      left: 15,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.red[400]?.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 15,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.red[400]?.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaco(double opacity) {
    return Positioned(
      bottom: 150,
      left: 60,
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: -0.4,
          child: Container(
            width: 80,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.yellow[200]!.withOpacity(0.9),
                          Colors.yellow[300]!.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: 5,
                  child: Column(
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.brown[500]!.withOpacity(0.9),
                              Colors.brown[600]!.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.green[400]?.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.yellow[300]?.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBurrito(double opacity) {
    return Positioned(
      top: 30,
      right: 30,
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: 0.2,
          child: Stack(
            children: [
              // Hoja debajo del burrito
              Positioned(
                left: 10,
                top: 20,
                child: Container(
                  width: 100,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green[50]?.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),

              // Burrito
              Container(
                width: 100,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.brown[200]!.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    // Relleno del burrito
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Column(
                          children: [
                            // Capa de frijoles
                            Expanded(
                              flex: 2,
                              child: Container(
                                color: Colors.brown[400]?.withOpacity(0.7),
                              ),
                            ),
                            // Capa de carne
                            Expanded(
                              flex: 3,
                              child: Container(
                                color: Colors.brown[600]?.withOpacity(0.8),
                              ),
                            ),
                            // Capa de queso
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: Colors.yellow[200]?.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Detalles de la tortilla
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.yellow[100]!.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Salsas alrededor
              Positioned(
                right: 0,
                top: 20,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.red[400]?.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 15,
                bottom: 0,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.green[400]?.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: 5,
                bottom: 10,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
