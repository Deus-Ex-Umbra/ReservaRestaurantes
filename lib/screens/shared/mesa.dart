import 'package:flutter/material.dart';

class MesaSelectionScreen extends StatefulWidget {
  @override
  _MesaSelectionScreenState createState() => _MesaSelectionScreenState();
}

class _MesaSelectionScreenState extends State<MesaSelectionScreen> {
  int? selectedTable;

  // Lista de mesas ocupadas/reservadas
  List<int> reservedTables = [2, 5, 8];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F6F0),
      appBar: AppBar(
        title: Text(
          'Seleccionar Mesa',
          style: TextStyle(
            color: Color(0xFF8B6F47),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFF8F6F0),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF8B6F47)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Mesas Individuales
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildIndividualTable(1), _buildIndividualTable(2)],
            ),

            SizedBox(height: 50),

            // Mesas Para Dos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildTableForTwo(3), _buildTableForTwo(4)],
            ),

            SizedBox(height: 50),

            // Mesas Para Cuatro
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildTableForFour(5), _buildTableForFour(6)],
            ),

            SizedBox(height: 50),

            // Mesas Para Seis
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildTableForSix(7), _buildTableForSix(8)],
            ),

            SizedBox(height: 50),

            // Mesas Para Ocho
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildTableForEight(9), _buildTableForEight(10)],
            ),

            SizedBox(height: 40),

            // Botón de Confirmación
            if (selectedTable != null &&
                !reservedTables.contains(selectedTable))
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B6F47),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Confirmar Mesa ${selectedTable}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservedSign() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Color(0xFF8B6F47).withOpacity(0.3)),
      ),
      child: Text(
        'Reservado',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF8B6F47),
        ),
      ),
    );
  }

  Widget _buildIndividualTable(int tableNumber) {
    bool isSelected = selectedTable == tableNumber;
    bool isReserved = reservedTables.contains(tableNumber);

    return GestureDetector(
      onTap: () {
        if (!isReserved) {
          setState(() {
            selectedTable = tableNumber;
          });
        }
      },
      child: Container(
        width: 100,
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mesa cuadrada
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color:
                        isReserved
                            ? Color(0xFFD3D3D3)
                            : isSelected
                            ? Color(0xFF8B6F47)
                            : Color(0xFFE8DCC0),
                    border: Border.all(
                      color: isReserved ? Color(0xFFAAAAAA) : Color(0xFF8B6F47),
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
                                        : Color(0xFF8B6F47),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                ),
                SizedBox(height: 10),
                // Silla (ahora con forma de silla)
                _buildChair(isSelected, isReserved),
              ],
            ),
            if (isReserved) _buildReservedSign(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableForTwo(int tableNumber) {
    bool isSelected = selectedTable == tableNumber;
    bool isReserved = reservedTables.contains(tableNumber);

    return GestureDetector(
      onTap: () {
        if (!isReserved) {
          setState(() {
            selectedTable = tableNumber;
          });
        }
      },
      child: Container(
        width: 100,
        height: 140,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Silla superior
                _buildChair(isSelected, isReserved),
                SizedBox(height: 10),
                // Mesa rectangular
                Container(
                  width: 80,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        isReserved
                            ? Color(0xFFD3D3D3)
                            : isSelected
                            ? Color(0xFF8B6F47)
                            : Color(0xFFE8DCC0),
                    border: Border.all(
                      color: isReserved ? Color(0xFFAAAAAA) : Color(0xFF8B6F47),
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
                                        : Color(0xFF8B6F47),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                ),
                SizedBox(height: 10),
                // Silla inferior
                _buildChair(isSelected, isReserved),
              ],
            ),
            if (isReserved) _buildReservedSign(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableForFour(int tableNumber) {
    bool isSelected = selectedTable == tableNumber;
    bool isReserved = reservedTables.contains(tableNumber);

    return GestureDetector(
      onTap: () {
        if (!isReserved) {
          setState(() {
            selectedTable = tableNumber;
          });
        }
      },
      child: Container(
        width: 150,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sillas superiores
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildChair(isSelected, isReserved),
                    SizedBox(width: 40),
                    _buildChair(isSelected, isReserved),
                  ],
                ),
                SizedBox(height: 10),
                // Mesa cuadrada más grande
                Container(
                  width: 100,
                  height: 60,
                  decoration: BoxDecoration(
                    color:
                        isReserved
                            ? Color(0xFFD3D3D3)
                            : isSelected
                            ? Color(0xFF8B6F47)
                            : Color(0xFFE8DCC0),
                    border: Border.all(
                      color: isReserved ? Color(0xFFAAAAAA) : Color(0xFF8B6F47),
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
                                        : Color(0xFF8B6F47),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                ),
                SizedBox(height: 10),
                // Sillas inferiores
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildChair(isSelected, isReserved),
                    SizedBox(width: 40),
                    _buildChair(isSelected, isReserved),
                  ],
                ),
              ],
            ),
            if (isReserved) _buildReservedSign(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableForSix(int tableNumber) {
    bool isSelected = selectedTable == tableNumber;
    bool isReserved = reservedTables.contains(tableNumber);

    return GestureDetector(
      onTap: () {
        if (!isReserved) {
          setState(() {
            selectedTable = tableNumber;
          });
        }
      },
      child: Container(
        width: 200,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sillas superiores
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildChair(isSelected, isReserved),
                    SizedBox(width: 20),
                    _buildChair(isSelected, isReserved),
                    SizedBox(width: 20),
                    _buildChair(isSelected, isReserved),
                  ],
                ),
                SizedBox(height: 10),
                // Mesa rectangular larga
                Container(
                  width: 140,
                  height: 60,
                  decoration: BoxDecoration(
                    color:
                        isReserved
                            ? Color(0xFFD3D3D3)
                            : isSelected
                            ? Color(0xFF8B6F47)
                            : Color(0xFFE8DCC0),
                    border: Border.all(
                      color: isReserved ? Color(0xFFAAAAAA) : Color(0xFF8B6F47),
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
                                        : Color(0xFF8B6F47),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                ),
                SizedBox(height: 10),
                // Sillas inferiores
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildChair(isSelected, isReserved),
                    SizedBox(width: 20),
                    _buildChair(isSelected, isReserved),
                    SizedBox(width: 20),
                    _buildChair(isSelected, isReserved),
                  ],
                ),
              ],
            ),
            if (isReserved) _buildReservedSign(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableForEight(int tableNumber) {
    bool isSelected = selectedTable == tableNumber;
    bool isReserved = reservedTables.contains(tableNumber);

    return GestureDetector(
      onTap: () {
        if (!isReserved) {
          setState(() {
            selectedTable = tableNumber;
          });
        }
      },
      child: Container(
        width: 250,
        height: 170,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sillas superiores
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildChair(isSelected, isReserved),
                    SizedBox(width: 15),
                    _buildChair(isSelected, isReserved),
                    SizedBox(width: 15),
                    _buildChair(isSelected, isReserved),
                    SizedBox(width: 15),
                    _buildChair(isSelected, isReserved),
                  ],
                ),
                SizedBox(height: 10),
                // Mesa rectangular muy larga
                Container(
                  width: 200,
                  height: 70,
                  decoration: BoxDecoration(
                    color:
                        isReserved
                            ? Color(0xFFD3D3D3)
                            : isSelected
                            ? Color(0xFF8B6F47)
                            : Color(0xFFE8DCC0),
                    border: Border.all(
                      color: isReserved ? Color(0xFFAAAAAA) : Color(0xFF8B6F47),
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
                                        : Color(0xFF8B6F47),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                ),
                SizedBox(height: 10),
                // Sillas inferiores
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildChair(isSelected, isReserved),
                    SizedBox(width: 15),
                    _buildChair(isSelected, isReserved),
                    SizedBox(width: 15),
                    _buildChair(isSelected, isReserved),
                    SizedBox(width: 15),
                    _buildChair(isSelected, isReserved),
                  ],
                ),
              ],
            ),
            if (isReserved) _buildReservedSign(),
          ],
        ),
      ),
    );
  }

  Widget _buildChair(bool isSelected, bool isReserved) {
    return Container(
      width: 30,
      height: 25,
      decoration: BoxDecoration(
        color:
            isReserved
                ? Color(0xFFD3D3D3)
                : isSelected
                ? Color(0xFF8B6F47)
                : Color(0xFFE8DCC0),
        border: Border.all(
          color: isReserved ? Color(0xFFAAAAAA) : Color(0xFF8B6F47),
          width: 2,
        ),
        borderRadius: BorderRadius.only(
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
          color: isReserved ? Color(0xFFAAAAAA) : Color(0xFF8B6F47),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirmar Reservación',
            style: TextStyle(
              color: Color(0xFF8B6F47),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Deseas reservar la Mesa $selectedTable?',
            style: TextStyle(color: Color(0xFF8B6F47)),
          ),
          backgroundColor: Color(0xFFF8F6F0),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF8B6F47)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSuccessMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8B6F47),
              ),
              child: Text('Confirmar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mesa $selectedTable reservada exitosamente'),
        backgroundColor: Color(0xFF8B6F47),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
