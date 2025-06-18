import 'package:flutter/material.dart';
import 'dart:math';

class FoodieBackground extends StatelessWidget {
  final Widget? child;
  final double foodOpacity;
  final bool showSaladBowl;
  final bool showBurger;
  final bool showFries;
  final bool showDrink;
  final bool showPizza;
  final bool showTaco;

  const FoodieBackground({
    Key? key,
    this.child,
    this.foodOpacity = 0.15,
    this.showSaladBowl = true,
    this.showBurger = true,
    this.showFries = true,
    this.showDrink = true,
    this.showPizza = true,
    this.showTaco = true,
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Salad bowl - improved with more details
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
                      border: Border.all(
                        color: Colors.green[200]!.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Salad ingredients - more detailed
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      // Tomato
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red[300]?.withOpacity(0.8),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.red[400]!.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                      ),
                      // Lettuce
                      Container(
                        width: 12,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.green[400]?.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      // Cucumber
                      Container(
                        width: 14,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.green[600]?.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      // Purple cabbage
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.purple[300]?.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Carrot
                      Container(
                        width: 10,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.orange[400]?.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      // Dressing drops
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Sesame seeds on top bun
                Positioned(
                  top: 5,
                  left: 15,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.yellow[100]?.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 20,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.yellow[100]?.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Bun top - more detailed with gradient
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

                // Lettuce - more wavy
                Positioned(
                  top: 20,
                  left: 12,
                  right: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.green[400]?.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: CustomPaint(
                        painter: _WavyLinePainter(
                          color: Colors.green[600]!.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ),

                // Tomato slice
                Positioned(
                  top: 26,
                  left: 15,
                  right: 15,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.red[300]?.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(
                        color: Colors.red[400]!.withOpacity(0.6),
                        width: 0.5,
                      ),
                    ),
                  ),
                ),

                // Patty - more detailed with grill marks
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
                    child: Stack(
                      children: [
                        // Grill marks
                        Positioned(
                          left: 5,
                          top: 3,
                          bottom: 3,
                          child: Container(
                            width: 2,
                            decoration: BoxDecoration(
                              color: Colors.brown[800]!.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 15,
                          top: 3,
                          bottom: 3,
                          child: Container(
                            width: 2,
                            decoration: BoxDecoration(
                              color: Colors.brown[800]!.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 5,
                          top: 3,
                          bottom: 3,
                          child: Container(
                            width: 2,
                            decoration: BoxDecoration(
                              color: Colors.brown[800]!.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Cheese - more melted look
                Positioned(
                  top: 45,
                  left: 12,
                  right: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.yellow[300]?.withOpacity(0.8),
                      ),
                      child: CustomPaint(
                        painter: _DrippingCheesePainter(
                          color: Colors.yellow[400]!.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),
                ),

                // Bun bottom - with more texture
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

                // Sesame seeds on bottom bun
                Positioned(
                  bottom: 5,
                  left: 20,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.yellow[100]?.withOpacity(0.9),
                      shape: BoxShape.circle,
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
              // Fries container - more detailed
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey[300]!.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Fries - more realistic with varying colors
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
                            // Each fry with more detail
                            _buildSingleFry(
                              color: Colors.yellow[300]!,
                              darkColor: Colors.orange[300]!,
                            ),
                            _buildSingleFry(
                              color: Colors.yellow[400]!,
                              darkColor: Colors.orange[400]!,
                            ),
                            _buildSingleFry(
                              color: Colors.yellow[500]!,
                              darkColor: Colors.orange[500]!,
                              isCurved: true,
                            ),
                            _buildSingleFry(
                              color: Colors.yellow[300]!,
                              darkColor: Colors.orange[300]!,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Fries label - more detailed
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
                  border: Border.all(
                    color: Colors.red[400]!.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 2,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleFry({
    required Color color,
    required Color darkColor,
    bool isCurved = false,
  }) {
    return Transform.rotate(
      angle: isCurved ? 0.1 : 0,
      child: Container(
        width: 35,
        height: 8,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withOpacity(0.9), darkColor.withOpacity(0.9)],
          ),
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: darkColor.withOpacity(0.3),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Cup highlights
                Positioned(
                  left: 5,
                  top: 10,
                  bottom: 10,
                  child: Container(
                    width: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Drink liquid - with bubbles
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
                    child: Stack(
                      children: [
                        // Bubbles
                        Positioned(
                          top: 5,
                          left: 15,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          right: 10,
                          child: Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          left: 25,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Straw - more detailed
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
                      border: Border.all(
                        color: Colors.red[400]!.withOpacity(0.3),
                        width: 0.5,
                      ),
                    ),
                  ),
                ),

                // Lid - more detailed
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
                      border: Border.all(
                        color: Colors.red[300]!.withOpacity(0.4),
                        width: 0.5,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 20,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.red[300]!.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),

                // Ice cubes - more detailed
                Positioned(
                  bottom: 30,
                  left: 20,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue[100]!.withOpacity(0.4),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 20,
                  child: Transform.rotate(
                    angle: 0.3,
                    child: Container(
                      width: 10,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue[100]!.withOpacity(0.4),
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                        ],
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
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
                  border: Border.all(
                    color: Colors.orange[300]!.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    // Pizza slices
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Transform.rotate(
                        angle: 0.5,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CustomPaint(painter: _PizzaSlicePainter()),
                        ),
                      ),
                    ),

                    // Pepperoni - more detailed
                    Positioned(
                      top: 15,
                      left: 15,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.red[400]?.withOpacity(0.8),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.red[500]!.withOpacity(0.6),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red[600]!.withOpacity(0.3),
                              blurRadius: 2,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.red[200]!.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                          ),
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
                          border: Border.all(
                            color: Colors.red[500]!.withOpacity(0.6),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red[600]!.withOpacity(0.3),
                              blurRadius: 2,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.red[200]!.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 30,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red[400]?.withOpacity(0.8),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.red[500]!.withOpacity(0.6),
                            width: 1,
                          ),
                        ),
                      ),
                    ),

                    // Mushrooms
                    Positioned(
                      bottom: 30,
                      right: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.brown[200]?.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 6,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Cheese drips - more detailed
                    Positioned(
                      top: 10,
                      left: 30,
                      child: Transform.rotate(
                        angle: 0.3,
                        child: Container(
                          width: 5,
                          height: 15,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.yellow[100]!.withOpacity(0.9),
                                Colors.yellow[200]!.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.yellow[300]!.withOpacity(0.3),
                                blurRadius: 2,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Basil leaves
                    Positioned(
                      top: 25,
                      right: 25,
                      child: Transform.rotate(
                        angle: -0.3,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.green[600]?.withOpacity(0.8),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                              bottomLeft: Radius.circular(2),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  // Taco shell - more detailed with texture
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
                      child: CustomPaint(painter: _TacoShellTexturePainter()),
                    ),
                  ),

                  // Filling - more detailed
                  Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    bottom: 5,
                    child: Column(
                      children: [
                        // Meat - with texture
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
                          child: Center(
                            child: Container(
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: Colors.brown[700]!.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),

                        // Lettuce - more wavy
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.green[400]?.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: CustomPaint(
                            painter: _WavyLinePainter(
                              color: Colors.green[600]!.withOpacity(0.8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),

                        // Cheese
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.yellow[300]?.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 2),

                        // Tomatoes and other toppings
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Tomato
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.red[400]?.withOpacity(0.8),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.red[500]!.withOpacity(0.5),
                                  width: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),

                            // Onion
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.purple[100]?.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),

                            // Sour cream
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painters for additional details
class _WavyLinePainter extends CustomPainter {
  final Color color;

  _WavyLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    final path = Path();
    path.moveTo(0, size.height / 2);

    for (double i = 0; i < size.width; i += 5) {
      path.quadraticBezierTo(
        i + 2.5,
        ((i / 5).toInt().isEven) ? size.height : 0,
        i + 5,
        size.height / 2,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DrippingCheesePainter extends CustomPainter {
  final Color color;

  _DrippingCheesePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Main cheese area
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(2),
      ),
      paint,
    );

    // Drips
    canvas.drawCircle(Offset(size.width * 0.2, size.height), 2, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height), 3, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height), 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PizzaSlicePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.orange[300]!.withOpacity(0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    const sliceAngle = 2 * 3.14159 / 8; // 8 slices

    for (int i = 0; i < 8; i++) {
      final angle = i * sliceAngle;
      canvas.drawLine(
        center,
        Offset(
          center.dx + size.width / 2 * cos(angle),
          center.dy + size.width / 2 * sin(angle),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TacoShellTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.orange[400]!.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    // Draw some irregular lines to simulate corn texture
    for (double i = 0; i < size.height; i += 3) {
      final y = i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y + (i % 6) - 3), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
