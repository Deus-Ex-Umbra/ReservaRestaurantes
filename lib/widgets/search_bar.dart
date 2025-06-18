import 'package:flutter/material.dart';

class RecipeSearchBar extends StatefulWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchPressed;
  final String hintText;
  final EdgeInsetsGeometry? padding;

  const RecipeSearchBar({
    Key? key,
    this.onSearchChanged,
    this.onSearchPressed,
    this.hintText = 'Search any recipe',
    this.padding,
  }) : super(key: key);

  @override
  State<RecipeSearchBar> createState() => _RecipeSearchBarState();
}

class _RecipeSearchBarState extends State<RecipeSearchBar>
    with TickerProviderStateMixin {
  late AnimationController _focusController;
  late AnimationController _hoverController;
  late AnimationController _pulseController;

  late Animation<double> _focusAnimation;
  late Animation<double> _hoverAnimation;
  late Animation<double> _pulseAnimation;

  final FocusNode _focusNode = FocusNode();
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    // Controlador para el efecto de focus
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Controlador para el efecto de hover
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Controlador para el efecto de pulso
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _focusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _focusController, curve: Curves.easeInOut),
    );

    _hoverAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(_onFocusChange);

    // Iniciar animación de pulso
    _pulseController.repeat(reverse: true);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused) {
      _focusController.forward();
      _pulseController.stop();
    } else {
      _focusController.reverse();
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _focusController.dispose();
    _hoverController.dispose();
    _pulseController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 40),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _focusAnimation,
          _hoverAnimation,
          _pulseAnimation,
        ]),
        builder: (context, child) {
          return Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF23272F), Color(0xFF14161A)],
              ),
              boxShadow: [
                // Sombra exterior oscura
                BoxShadow(
                  color: const Color(0xFF0E1013).withOpacity(0.8),
                  offset: const Offset(10, 10),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
                // Sombra exterior clara
                BoxShadow(
                  color: const Color(0xFF383E4B).withOpacity(0.4),
                  offset: const Offset(-10, -10),
                  blurRadius: 40,
                  spreadRadius: 0,
                ),
                // Efecto de brillo al hacer focus
                if (_isFocused)
                  BoxShadow(
                    color: const Color(
                      0xFFFFD43B,
                    ).withOpacity(0.3 * _focusAnimation.value),
                    blurRadius: 20 * _focusAnimation.value,
                    spreadRadius: 2 * _focusAnimation.value,
                  ),
                // Efecto de pulso cuando no está enfocado
                if (!_isFocused)
                  BoxShadow(
                    color: const Color(
                      0xFFFFD43B,
                    ).withOpacity(0.1 * _pulseAnimation.value),
                    blurRadius: 10 * _pulseAnimation.value,
                    spreadRadius: 1 * _pulseAnimation.value,
                  ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  // Campo de texto
                  Expanded(
                    flex: 75,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        color: const Color(0xFF23272F),
                        border: Border.all(
                          color:
                              _isFocused
                                  ? Color.lerp(
                                    Colors.transparent,
                                    const Color(0xFFFFD43B),
                                    _focusAnimation.value,
                                  )!
                                  : Colors.transparent,
                          width: 1,
                        ),
                        boxShadow: [
                          // Sombra interior oscura
                          BoxShadow(
                            color: const Color(0xFF0E1013).withOpacity(0.8),
                            offset: const Offset(5, 5),
                            blurRadius: 10,
                          ),
                          // Sombra interior clara
                          BoxShadow(
                            color: const Color(0xFF383E4B).withOpacity(0.6),
                            offset: const Offset(-5, -5),
                            blurRadius: 10,
                          ),
                          // Efecto de brillo interior al hacer focus
                          if (_isFocused) ...[
                            BoxShadow(
                              color: const Color(
                                0xFFFF6600,
                              ).withOpacity(0.3 * _focusAnimation.value),
                              blurRadius: 10 * _focusAnimation.value,
                            ),
                            BoxShadow(
                              color: const Color(
                                0xFFFFD43B,
                              ).withOpacity(0.3 * _focusAnimation.value),
                              blurRadius: 10 * _focusAnimation.value,
                            ),
                          ],
                        ],
                      ),
                      child: TextField(
                        focusNode: _focusNode,
                        onChanged: widget.onSearchChanged,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 4),

                  // Botón de búsqueda
                  Expanded(
                    flex: 15,
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _isHovered = true;
                        });
                        _hoverController.forward();
                      },
                      onExit: (_) {
                        setState(() {
                          _isHovered = false;
                        });
                        _hoverController.reverse();
                      },
                      child: GestureDetector(
                        onTap: widget.onSearchPressed,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.lerp(
                                  const Color(0xFFFFD43B),
                                  const Color(0xFFFFD43B),
                                  _isHovered ? 0.5 : 0.0,
                                )!,
                                Color.lerp(
                                  const Color(0xFFFF6600),
                                  const Color(0xFFFF6600),
                                  _isHovered ? 1.0 : 1.0,
                                )!,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFD43B).withOpacity(0.3),
                                blurRadius: 2,
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: const Color(0xFFFF6600).withOpacity(0.3),
                                blurRadius: 2,
                                spreadRadius: 0,
                              ),
                              // Efecto de brillo al hacer hover
                              if (_isHovered) ...[
                                BoxShadow(
                                  color: const Color(
                                    0xFFFFD43B,
                                  ).withOpacity(0.5 * _hoverAnimation.value),
                                  blurRadius: 20 * _hoverAnimation.value,
                                  spreadRadius: 2 * _hoverAnimation.value,
                                ),
                                BoxShadow(
                                  color: const Color(
                                    0xFFFF6600,
                                  ).withOpacity(0.5 * _hoverAnimation.value),
                                  blurRadius: 20 * _hoverAnimation.value,
                                  spreadRadius: 2 * _hoverAnimation.value,
                                ),
                              ],
                            ],
                          ),
                          child: Center(
                            child: AnimatedScale(
                              scale: _isHovered ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.search,
                                color: const Color(0xFF23272F),
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
