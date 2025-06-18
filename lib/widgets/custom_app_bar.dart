import 'package:flutter/material.dart';
import 'dart:ui';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final BuildContext context;
  final VoidCallback? onBackPressed;
  final VoidCallback? onHomePressed;
  final Function(String)? onMenuSelected;

  const CustomAppBar({
    super.key,
    required this.context,
    this.onBackPressed,
    this.onHomePressed,
    this.onMenuSelected,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar>
    with TickerProviderStateMixin {
  bool _isSearchFocused = false;
  bool _isMenuVisible = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final GlobalKey _menuButtonKey = GlobalKey();

  late AnimationController _searchAnimationController;
  late Animation<double> _searchWidthAnimation;
  late Animation<double> _searchBorderRadiusAnimation;

  @override
  void initState() {
    super.initState();

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _searchWidthAnimation = Tween<double>(begin: 50.0, end: 250.0).animate(
      CurvedAnimation(
        parent: _searchAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _searchBorderRadiusAnimation = Tween<double>(begin: 25.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _searchAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });

      if (_searchFocusNode.hasFocus) {
        _searchAnimationController.forward();
      } else {
        _searchAnimationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _searchAnimationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _showMenu() {
    if (_isMenuVisible) return;

    final RenderBox renderBox =
        _menuButtonKey.currentContext?.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = _createOverlayEntry(position);
    Overlay.of(widget.context).insert(_overlayEntry!);

    setState(() {
      _isMenuVisible = true;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _isMenuVisible = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry(Offset position) {
    return OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _removeOverlay,
                  child: Container(color: Colors.transparent),
                ),
              ),
              Positioned(
                top: position.dy + 50,
                right: 10,
                child: Material(
                  color: Colors.transparent,
                  child: AnimatedMenuDropdown(
                    onItemSelected: (value) {
                      _removeOverlay();
                      widget.onMenuSelected?.call(value);
                    },
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: null,
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: widget.onBackPressed ?? () => Navigator.pop(widget.context),
      ),
      actions: [
        // Widget de Búsqueda
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: AnimatedBuilder(
            animation: _searchAnimationController,
            builder: (context, child) {
              return Container(
                width: _searchWidthAnimation.value,
                height: 50,
                decoration: BoxDecoration(
                  color:
                      _isSearchFocused
                          ? Colors.transparent
                          : const Color(0xFF7E4FD4),
                  borderRadius: BorderRadius.circular(
                    _searchBorderRadiusAnimation.value,
                  ),
                  boxShadow:
                      _isSearchFocused
                          ? []
                          : [
                            BoxShadow(
                              color: const Color(0xFFF3F3F3),
                              blurRadius: 3,
                              offset: const Offset(0, 0),
                            ),
                          ],
                  border:
                      _isSearchFocused
                          ? const Border(
                            bottom: BorderSide(
                              color: Color(0xFF7E4FD4),
                              width: 3,
                            ),
                          )
                          : null,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontFamily: 'Trebuchet MS',
                        ),
                        decoration: InputDecoration(
                          hintText: _isSearchFocused ? 'search..' : '',
                          hintStyle: const TextStyle(
                            color: Color(0xFF8F8F8F),
                            fontSize: 17,
                            fontFamily: 'Trebuchet MS',
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                            right: 50,
                            top: 10,
                            bottom: 10,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          if (!_isSearchFocused) {
                            _searchFocusNode.requestFocus();
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Botón de Menú
        IconButton(
          key: _menuButtonKey,
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: _showMenu,
        ),
      ],
    );
  }
}

// Clases AnimatedMenuDropdown y MenuItem se mantienen igual que en tu código original
class AnimatedMenuDropdown extends StatefulWidget {
  final Function(String) onItemSelected;

  const AnimatedMenuDropdown({super.key, required this.onItemSelected});

  @override
  State<AnimatedMenuDropdown> createState() => _AnimatedMenuDropdownState();
}

class _AnimatedMenuDropdownState extends State<AnimatedMenuDropdown>
    with TickerProviderStateMixin {
  String? _hoveredItem;
  String? _activeItem;

  final List<MenuItem> _menuItems = [
    MenuItem(value: 'inicio', label: 'Inicio', icon: Icons.home),
    MenuItem(value: 'buscar', label: 'Buscar', icon: Icons.search),
    MenuItem(value: 'reservas', label: 'Reservas', icon: Icons.book_online),
    MenuItem(value: 'favoritos', label: 'Favoritos', icon: Icons.favorite),
    MenuItem(value: 'perfil', label: 'Perfil', icon: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 1),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: _menuItems.map((item) => _buildMenuItem(item)).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    final isHovered = _hoveredItem == item.value;
    final isActive = _activeItem == item.value;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(
        begin: 1.0,
        end: (_hoveredItem != null && !isHovered) ? 0.95 : 1.0,
      ),
      builder: (context, scaleValue, child) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween(
            begin: 0.0,
            end: (_hoveredItem != null && !isHovered) ? 1.5 : 0.0,
          ),
          builder: (context, blurValue, child) {
            return Transform.scale(
              scale: scaleValue,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: blurValue,
                  sigmaY: blurValue,
                ),
                child: _buildMenuButton(item, isHovered, isActive),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMenuButton(MenuItem item, bool isHovered, bool isActive) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 1),
      tween: Tween(begin: 0.0, end: isActive ? 17.0 : 0.0),
      builder: (context, marginValue, child) {
        return AnimatedContainer(
          duration: const Duration(seconds: 1),
          margin: EdgeInsets.only(left: marginValue),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _activeItem = item.value;
                });
                Future.delayed(const Duration(milliseconds: 100), () {
                  widget.onItemSelected(item.value);
                });
              },
              onHover: (hover) {
                setState(() {
                  _hoveredItem = hover ? item.value : null;
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:
                      isActive ? const Color(0xFF1A1F24) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      (isHovered || isActive)
                          ? Border.all(color: const Color(0xFF1A1F24), width: 2)
                          : null,
                ),
                child: Stack(
                  children: [
                    if (isActive)
                      Positioned(
                        left: -25,
                        top: 5,
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(seconds: 1),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, opacityValue, child) {
                            return Opacity(
                              opacity: opacityValue,
                              child: Container(
                                width: 5,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2F81F7),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    Row(
                      children: [
                        Icon(
                          item.icon,
                          color:
                              (isHovered || isActive)
                                  ? const Color(0xFF637185)
                                  : Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          item.label,
                          style: TextStyle(
                            color:
                                (isHovered || isActive)
                                    ? const Color(0xFF637185)
                                    : Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MenuItem {
  final String value;
  final String label;
  final IconData icon;

  MenuItem({required this.value, required this.label, required this.icon});
}
