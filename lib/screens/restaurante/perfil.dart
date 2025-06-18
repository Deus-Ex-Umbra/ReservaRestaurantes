import 'package:flutter/material.dart';

class AdminProfileScreen extends StatefulWidget {
  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: 'Malaba Restaurante',
  );
  final TextEditingController _addressController = TextEditingController(
    text: '386 Grau, Sucre, Bolivia',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '+591 75788100',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'contacto@malaba.com',
  );
  final TextEditingController _descriptionController = TextEditingController(
    text:
        'Restaurante especializado en comida estilo americano con una variedad amplia de comida rápida, teniendo como especialidad las hamburguesas.',
  );

  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0c0f14), // Fondo oscuro
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Perfil del Restaurante',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.close : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) {
                  // Guardar cambios cuando se desactiva la edición
                  _saveChanges();
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto del perfil con opción de edición
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFd17842), width: 2),
                      image: DecorationImage(
                        image: AssetImage('assets/restaurant_logo.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _changeProfileImage,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFFd17842),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Información básica editable
            Text(
              'Información Básica',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildEditableField(
              'Nombre del Restaurante',
              Icons.restaurant,
              _nameController,
              isEditing: _isEditing,
            ),
            SizedBox(height: 15),
            _buildEditableField(
              'Dirección',
              Icons.location_on,
              _addressController,
              isEditing: _isEditing,
            ),
            SizedBox(height: 15),
            _buildEditableField(
              'Teléfono',
              Icons.phone,
              _phoneController,
              isEditing: _isEditing,
            ),
            SizedBox(height: 15),
            _buildEditableField(
              'Correo Electrónico',
              Icons.email,
              _emailController,
              isEditing: _isEditing,
            ),
            SizedBox(height: 15),

            // Descripción
            Text(
              'Descripción',
              style: TextStyle(color: Color(0xFF8B9AAB), fontSize: 14),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              enabled: _isEditing,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1A1F2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(15),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 30),

            // Horario de atención
            Text(
              'Horario de Atención',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildScheduleDay(
              'Lunes a Viernes',
              '11:00 - 23:00',
              isEditing: _isEditing,
            ),
            _buildScheduleDay('Sábado', '11:00 - 00:00', isEditing: _isEditing),
            _buildScheduleDay(
              'Domingo',
              '12:00 - 22:00',
              isEditing: _isEditing,
            ),
            SizedBox(height: 30),

            // Botón de guardar (solo visible en modo edición)
            if (_isEditing)
              Center(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4ECDC4), // Turquesa
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Guardar Cambios',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    IconData icon,
    TextEditingController controller, {
    required bool isEditing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Color(0xFF8B9AAB), fontSize: 14)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: isEditing,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFF1A1F2E),
            prefixIcon: Icon(icon, color: Color(0xFF8B9AAB)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildScheduleDay(
    String day,
    String hours, {
    required bool isEditing,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              day,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          if (isEditing)
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(
                        text: hours.split(' - ')[0],
                      ),
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF0c0f14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'a',
                      style: TextStyle(color: Color(0xFF8B9AAB)),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(
                        text: hours.split(' - ')[1],
                      ),
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF0c0f14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              hours,
              style: TextStyle(color: Color(0xFF8B9AAB), fontSize: 16),
            ),
        ],
      ),
    );
  }

  void _changeProfileImage() {
    // Lógica para cambiar la imagen de perfil
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Color(0xFF1A1F2E),
            title: Text(
              'Cambiar imagen',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Color(0xFF8B9AAB)),
                  title: Text(
                    'Tomar foto',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Lógica para tomar foto
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: Color(0xFF8B9AAB)),
                  title: Text(
                    'Elegir de la galería',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Lógica para elegir de galería
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _saveChanges() {
    // Lógica para guardar los cambios
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cambios guardados exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
    setState(() {
      _isEditing = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
