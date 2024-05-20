import 'package:fccapp/pages/users/editable_dropdown_profile_row.dart';
import 'package:fccapp/pages/users/editable_profile_row.dart';
import 'package:fccapp/pages/users/profile_row.dart';
import 'package:fccapp/services/Level_1/db_user_service.dart';
import 'package:fccapp/services/Level_0/storage_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

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
  void dispose() {
    // Perform any necessary cleanup here
    super.dispose();
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

  Future<void> _changeProfilePicture(BuildContext context) async {
    final result = await widget.dbu.pickProfilePicture();
    if (result != null) {
      File file = result[0];
      String fileName = result[1];

      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar Cambio'),
            content: const Text('¿Deseas cambiar tu foto de perfil?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        await widget.dbu.addProfilePicture(
          st: StorageService(),
          file: file,
        );

        // Reload the user data to reflect the changes
        if (mounted) {
          setState(() {
            _userDataFuture = widget.dbu.getUserData();
          });
        }
      }
    }
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
                child: GestureDetector(
                  onTap: () => _changeProfilePicture(context),
                  child: FutureBuilder<Uint8List?>(
                    future: widget.dbu.getProfilePicture(st: StorageService()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage: const AssetImage('assets/defaultimage.jpg'),
                        );
                      } else {
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage: MemoryImage(snapshot.data!),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              EditableProfileRow(
                iconPath: 'assets/nameicon.png',
                label: 'Nombre: ',
                value: userData['displayName'] ?? '',
                isEditing: _isEditing,
                onChanged: (value) => userData['displayName'] = value,
              ),
              const SizedBox(height: 20),
              ProfileRow(
                iconPath: 'assets/emailicon.png',
                label: 'Correo electrónico: ',
                value: userData['email'] ?? '',
              ),
              const SizedBox(height: 20),
              EditableProfileRow(
                iconPath: 'assets/idicon.png',
                label: 'Cédula: ',
                value: userData['gid'] ?? '',
                isEditing: _isEditing,
                onChanged: (value) => userData['gid'] = value,
              ),
              const SizedBox(height: 20),
              EditableDropdownProfileRow(
                iconPath: 'assets/locationicon.png',
                label: 'Ubicación: ',
                value: userData['location'] ?? '',
                options: _locations,
                isEditing: _isEditing,
                onChanged: (value) => userData['location'] = value,
              ),
              const SizedBox(height: 20),
              EditableProfileRow(
                iconPath: 'assets/phoneicon.png',
                label: 'Teléfono: ',
                value: userData['phone'] ?? '',
                isEditing: _isEditing,
                onChanged: (value) => userData['phone'] = value,
              ),
              const SizedBox(height: 20),
              EditableDropdownProfileRow(
                iconPath: 'assets/sporticon.png',
                label: 'Deporte: ',
                value: userData['sport'] ?? '',
                options: _sports,
                isEditing: _isEditing,
                onChanged: (value) => userData['sport'] = value,
              ),
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
                        backgroundColor: Colors.red,
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

  void _toggleEditSave() {
    if (mounted) {
      setState(() {
        if (_isEditing) {
          _originalUserData = Map.from(_editableUserData!);
          widget.dbu.updateUserProfile(_editableUserData!);
        }
        _isEditing = !_isEditing;
      });
    }
  }

  void _cancelEdit() {
    if (mounted) {
      setState(() {
        _editableUserData = Map.from(_originalUserData!);
        _isEditing = false;
      });
    }
  }
}
