import 'package:fccapp/services/Level_1/db_user_service.dart';
import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  final DBUserService dbu;

  const UserHome({super.key, required this.dbu});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  late Future<Map<String, dynamic>?> _userDataFuture;
  Map<String, dynamic>? _originalUserData;
  Map<String, dynamic>? _editableUserData;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _userDataFuture = widget.dbu.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No se encontraron datos del usuario.'));
          } else {
            _originalUserData ??= snapshot.data!;
            _editableUserData ??= Map.from(_originalUserData!);
            return _buildUserProfile(_editableUserData!);
          }
        },
      ),
    );
  }

  Widget _buildUserProfile(Map<String, dynamic> userData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: (userData['photoUrl'] != null && userData['photoUrl'].isNotEmpty)
                  ? NetworkImage(userData['photoUrl']) as ImageProvider
                  : const AssetImage('assets/default_avatar.png'),
            ),
          ),
          const SizedBox(height: 20),
          _buildEditableTextField('Nombre: ', 'displayName', userData),
          _buildEditableTextField('Correo electrónico: ', 'email', userData),
          _buildEditableTextField('Cédula: ', 'gid', userData),
          _buildEditableTextField('Ubicación: ', 'location', userData),
          _buildEditableTextField('Teléfono: ', 'phone', userData),
          _buildEditableTextField('Deporte: ', 'sport', userData),
          const SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton(
                onPressed: _toggleEditSave,
                child: Text(_isEditing ? 'Guardar' : 'Editar'),
              ),
              if (_isEditing)
                const SizedBox(width: 10),
              if (_isEditing)
                ElevatedButton(
                  onPressed: _cancelEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Cancelar'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableTextField(String label, String key, Map<String, dynamic> userData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Expanded(
            child: _isEditing
                ? TextFormField(
                    initialValue: userData[key],
                    onChanged: (value) => userData[key] = value,
                  )
                : Text(
                    userData[key] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }

  void _toggleEditSave() {
    setState(() {
      if (_isEditing) {
        // Save logic here (e.g., update the database)
        _originalUserData = Map.from(_editableUserData!);
        widget.dbu.updateUserProfile(_editableUserData!);
      }
      _isEditing = !_isEditing;
    });
  }

  void _cancelEdit() {
    setState(() {
      _editableUserData = Map.from(_originalUserData!);
      _isEditing = false;
    });
  }
}
