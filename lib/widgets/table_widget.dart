import 'package:flutter/material.dart';

enum TableType { individual, forTwo, forFour, forSix, forEight }

class TableWidget extends StatelessWidget {
  final int tableNumber;
  final bool isReserved;
  final bool isSelected;
  final Function(int) onTap;
  final TableType type;

  const TableWidget({
    Key? key,
    required this.tableNumber,
    required this.isReserved,
    required this.isSelected,
    required this.onTap,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isReserved ? null : () => onTap(tableNumber),
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [_buildTable(), if (isReserved) _buildReservedSign()],
        ),
      ),
    );
  }

  Widget _buildReservedSign() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFF8B6F47).withOpacity(0.3)),
      ),
      child: const Text(
        'Reservado',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF8B6F47),
        ),
      ),
    );
  }

  Widget _buildTable() {
    switch (type) {
      case TableType.individual:
        return SizedBox(
          width: 100,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color:
                      isReserved
                          ? const Color(0xFFD3D3D3)
                          : isSelected
                          ? const Color(0xFF8B6F47)
                          : const Color(0xFFE8DCC0),
                  border: Border.all(
                    color:
                        isReserved
                            ? const Color(0xFFAAAAAA)
                            : const Color(0xFF8B6F47),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    isReserved
                        ? null
                        : Center(
                          child: Text(
                            '$tableNumber',
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? Colors.white
                                      : const Color(0xFF8B6F47),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
              ),
              const SizedBox(height: 10),
              _buildChair(),
            ],
          ),
        );
      case TableType.forTwo:
        return SizedBox(
          width: 100,
          height: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChair(),
              const SizedBox(height: 10),
              Container(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  color:
                      isReserved
                          ? const Color(0xFFD3D3D3)
                          : isSelected
                          ? const Color(0xFF8B6F47)
                          : const Color(0xFFE8DCC0),
                  border: Border.all(
                    color:
                        isReserved
                            ? const Color(0xFFAAAAAA)
                            : const Color(0xFF8B6F47),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    isReserved
                        ? null
                        : Center(
                          child: Text(
                            '$tableNumber',
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? Colors.white
                                      : const Color(0xFF8B6F47),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
              ),
              const SizedBox(height: 10),
              _buildChair(),
            ],
          ),
        );
      case TableType.forFour:
        return SizedBox(
          width: 150,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildChair(),
                  const SizedBox(width: 40),
                  _buildChair(),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: 100,
                height: 60,
                decoration: BoxDecoration(
                  color:
                      isReserved
                          ? const Color(0xFFD3D3D3)
                          : isSelected
                          ? const Color(0xFF8B6F47)
                          : const Color(0xFFE8DCC0),
                  border: Border.all(
                    color:
                        isReserved
                            ? const Color(0xFFAAAAAA)
                            : const Color(0xFF8B6F47),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    isReserved
                        ? null
                        : Center(
                          child: Text(
                            '$tableNumber',
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? Colors.white
                                      : const Color(0xFF8B6F47),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildChair(),
                  const SizedBox(width: 40),
                  _buildChair(),
                ],
              ),
            ],
          ),
        );
      case TableType.forSix:
        return SizedBox(
          width: 200,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildChair(),
                  const SizedBox(width: 20),
                  _buildChair(),
                  const SizedBox(width: 20),
                  _buildChair(),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: 140,
                height: 60,
                decoration: BoxDecoration(
                  color:
                      isReserved
                          ? const Color(0xFFD3D3D3)
                          : isSelected
                          ? const Color(0xFF8B6F47)
                          : const Color(0xFFE8DCC0),
                  border: Border.all(
                    color:
                        isReserved
                            ? const Color(0xFFAAAAAA)
                            : const Color(0xFF8B6F47),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    isReserved
                        ? null
                        : Center(
                          child: Text(
                            '$tableNumber',
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? Colors.white
                                      : const Color(0xFF8B6F47),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildChair(),
                  const SizedBox(width: 20),
                  _buildChair(),
                  const SizedBox(width: 20),
                  _buildChair(),
                ],
              ),
            ],
          ),
        );
      case TableType.forEight:
        return SizedBox(
          width: 250,
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildChair(),
                  const SizedBox(width: 15),
                  _buildChair(),
                  const SizedBox(width: 15),
                  _buildChair(),
                  const SizedBox(width: 15),
                  _buildChair(),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: 200,
                height: 70,
                decoration: BoxDecoration(
                  color:
                      isReserved
                          ? const Color(0xFFD3D3D3)
                          : isSelected
                          ? const Color(0xFF8B6F47)
                          : const Color(0xFFE8DCC0),
                  border: Border.all(
                    color:
                        isReserved
                            ? const Color(0xFFAAAAAA)
                            : const Color(0xFF8B6F47),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    isReserved
                        ? null
                        : Center(
                          child: Text(
                            '$tableNumber',
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? Colors.white
                                      : const Color(0xFF8B6F47),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildChair(),
                  const SizedBox(width: 15),
                  _buildChair(),
                  const SizedBox(width: 15),
                  _buildChair(),
                  const SizedBox(width: 15),
                  _buildChair(),
                ],
              ),
            ],
          ),
        );
    }
  }

  Widget _buildChair() {
    return Container(
      width: 30,
      height: 25,
      decoration: BoxDecoration(
        color:
            isReserved
                ? const Color(0xFFD3D3D3)
                : isSelected
                ? const Color(0xFF8B6F47)
                : const Color(0xFFE8DCC0),
        border: Border.all(
          color: isReserved ? const Color(0xFFAAAAAA) : const Color(0xFF8B6F47),
          width: 2,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: Center(
        child: Container(
          width: 20,
          height: 3,
          color: isReserved ? const Color(0xFFAAAAAA) : const Color(0xFF8B6F47),
        ),
      ),
    );
  }
}
