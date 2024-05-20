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

  final List<String> _locations = ['Medellin', 'Llanogrande'];
  final List<String> _sports = ['Tennis', 'Golf'];

  @override
  void initState() {
    super.initState();
    _userDataFuture = widget.dbu.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b512d),
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          'Perfil de Usuario',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0b512d),
            Color(0xFF22c0c6),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: (userData['photoUrl'] != null && userData['photoUrl'].isNotEmpty)
                      ? NetworkImage(userData['photoUrl']) as ImageProvider
                      : const AssetImage('assets/defaultimage.jpg'),
                ),
              ),
              const SizedBox(height: 20),
              _buildEditableProfileRow('assets/nameicon.png', 'Nombre: ', 'displayName', userData),
              const SizedBox(height: 20),
              _buildProfileRow('assets/emailicon.png', 'Correo electrónico: ', 'email', userData),
              const SizedBox(height: 20),
              _buildEditableProfileRow('assets/idicon.png', 'Cédula: ', 'gid', userData),
              const SizedBox(height: 20),
              _buildEditableDropdownProfileRow('assets/locationicon.png', 'Ubicación: ', 'location', userData, _locations),
              const SizedBox(height: 20),
              _buildEditableProfileRow('assets/phoneicon.png', 'Teléfono: ', 'phone', userData),
              const SizedBox(height: 20),
              _buildEditableDropdownProfileRow('assets/sporticon.png', 'Deporte: ', 'sport', userData, _sports),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _toggleEditSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(color: Color(0xFF0b512d), width: 2),
                    ),
                    child: Text(
                      _isEditing ? 'Guardar' : 'Editar',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF0b512d),
                      ),
                    ),
                  ),
                  if (_isEditing) const SizedBox(width: 10),
                  if (_isEditing)
                    ElevatedButton(
                      onPressed: _cancelEdit,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildEditableProfileRow(String iconPath, String label, String key, Map<String, dynamic> userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        _isEditing
            ? TextFormField(
                initialValue: userData[key],
                onChanged: (value) => userData[key] = value,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              )
            : Text(
                userData[key] ?? '',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
      ],
    );
  }

  Widget _buildProfileRow(String iconPath, String label, String key, Map<String, dynamic> userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          userData[key] ?? '',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildEditableDropdownProfileRow(String iconPath, String label, String key, Map<String, dynamic> userData, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        _isEditing
            ? DropdownButtonFormField<String>(
                value: options.contains(userData[key]) ? userData[key] : null,
                items: options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    userData[key] = value;
                  });
                },
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              )
            : Text(
                userData[key] ?? '',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
      ],
    );
  }

  void _toggleEditSave() {
    setState(() {
      if (_isEditing) {
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
