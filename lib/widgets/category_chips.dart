import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final EdgeInsetsGeometry? padding;

  const CategoryChips({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Container(
        height: 90,
        child: Center(
          // Añadido Center para centrar horizontalmente
          child: ListView.builder(
            shrinkWrap:
                true, // Para que el ListView ocupe solo el espacio necesario
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category['name'] == selectedCategory;

              return Padding(
                padding: EdgeInsets.only(
                  right: index == categories.length - 1 ? 0 : 20,
                ),
                child: _buildCategoryChip(
                  category['name'],
                  category['icon'],
                  category['color'],
                  isSelected,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    String label,
    IconData icon,
    Color color,
    bool isSelected,
  ) {
    return _CSSStyledCategoryChip(
      label: label,
      icon: icon,
      color: color,
      isSelected: isSelected,
      onTap: () => onCategorySelected(label),
    );
  }
}

class _CSSStyledCategoryChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _CSSStyledCategoryChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  _CSSStyledCategoryChipState createState() => _CSSStyledCategoryChipState();
}

class _CSSStyledCategoryChipState extends State<_CSSStyledCategoryChip>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _tooltipController;
  late Animation<double> _fillAnimation;
  late Animation<double> _tooltipPositionAnimation;
  late Animation<double> _tooltipOpacityAnimation;
  late Animation<double> _shadowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _tooltipController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _fillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _tooltipPositionAnimation = Tween<double>(begin: -30.0, end: -50.0).animate(
      CurvedAnimation(parent: _tooltipController, curve: Curves.easeInOut),
    );

    _tooltipOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _tooltipController, curve: Curves.easeInOut),
    );

    _shadowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _tooltipController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _hoverController.forward();
      _tooltipController.forward();
    } else {
      _hoverController.reverse();
      _tooltipController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([_fillAnimation, _shadowAnimation]),
              builder: (context, child) {
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow:
                        _shadowAnimation.value > 0.1
                            ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 45,
                                offset: Offset(3, 2),
                                spreadRadius: 0,
                              ),
                            ]
                            : [],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: _fillAnimation.value * 50,
                            decoration: BoxDecoration(color: widget.color),
                          ),
                        ),
                        Center(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            child: Icon(
                              widget.icon,
                              size: 30,
                              color:
                                  _isHovered ? Colors.white : Color(0xFF4d4d4d),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: Listenable.merge([
                _tooltipPositionAnimation,
                _tooltipOpacityAnimation,
              ]),
              builder: (context, child) {
                return Positioned(
                  top: _tooltipPositionAnimation.value,
                  left: -25,
                  child: Opacity(
                    opacity: _tooltipOpacityAnimation.value,
                    child: Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          widget.label,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryData {
  static List<Map<String, dynamic>> getCategories() {
    return [
      {
        'name': 'Mundo',
        'icon': Icons.public_rounded,
        'color': Color(0xFF1DB954),
      },
      {
        'name': 'Rápida',
        'icon': Icons.flash_on_rounded,
        'color': Color(0xFFBD081C),
      },
      {
        'name': 'Saludable',
        'icon': Icons.favorite_rounded,
        'color': Color(0xFFEA4C89),
      },
      {
        'name': 'Bebidas',
        'icon': Icons.local_cafe_rounded,
        'color': Color(0xFF0088CC),
      },
      {
        'name': 'Postres',
        'icon': Icons.cake_rounded,
        'color': Color(0xFFFF6B35),
      },
      {
        'name': 'Parrilladas',
        'icon': Icons.outdoor_grill_rounded,
        'color': Color(0xFF6C5CE7),
      },
    ];
  }
}
