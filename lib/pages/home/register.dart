import 'package:flutter/material.dart';
import 'package:fccapp/services/Level_1/authentication_service.dart';
import 'package:intl/intl.dart';
import '../../shared/loading.dart';

class UserRegister extends StatefulWidget {
  final AuthService auth;

  const UserRegister({super.key, required this.auth});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _securePasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _gidController = TextEditingController();
  String _selectedLocation = 'Medellin';
  String _selectedSport = 'Tennis';
  late String _errorText = '';
  bool _isLoading = false;
  DateTime? _selectedDate;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String registration = await widget.auth.registerWithEmailAndPass(
        emailAddress: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        phone: _phoneController.text,
        gid: _gidController.text,
        location: _selectedLocation,
        sport: _selectedSport,
        startDate: _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : '',
      );
      if (registration == 'Success') {
        Navigator.pop(context);
      } else {
        setState(() {
          _errorText = registration;
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Text(_emailController.text),
            Text(_passwordController.text),
            Text(_securePasswordController.text),
          ],
        ),
      ));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF0b512d),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              "Registro de usuario",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          backgroundColor: const Color(0xFF0b512d),
          body: _isLoading
              ? const Loading()
              : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0b512d),
                      Color(0xFFe6e6e3),
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/LOGOFCC.png',
                                height: 295,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _emailController,
                              icon: Icons.email,
                              hintText: 'Correo electrónico',
                              obscureText: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor introduzca su correo electrónico.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            _buildTextField(
                              controller: _passwordController,
                              icon: Icons.lock,
                              hintText: 'Contraseña',
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, introduzca su contraseña.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            _buildTextField(
                              controller: _securePasswordController,
                              icon: Icons.lock,
                              hintText: 'Reingresar Contraseña',
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, introduzca otra vez su contraseña.';
                                } else if (value != _passwordController.text) {
                                  return 'Las contraseñas no coinciden.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            _buildTextField(
                              controller: _nameController,
                              icon: Icons.person,
                              hintText: 'Nombre Completo',
                              obscureText: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, introduzca su nombre completo.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            _buildTextField(
                              controller: _phoneController,
                              icon: Icons.phone,
                              hintText: 'Telefono',
                              obscureText: false,
                            ),
                            const SizedBox(height: 10),
                            _buildTextField(
                              controller: _gidController,
                              icon: Icons.credit_card,
                              hintText: 'GID',
                              obscureText: false,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Location',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildDropdown(
                              value: _selectedLocation,
                              items: ['Medellin', 'Llano Grande'],
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedLocation = newValue!;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Sport',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildDropdown(
                              value: _selectedSport,
                              items: ['Tennis', 'Golf'],
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedSport = newValue!;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Dia de ingreso a la fundación',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today, color: Colors.white),
                                    const SizedBox(width: 10),
                                    Text(
                                      _selectedDate == null
                                          ? 'Seleccionar fecha'
                                          : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                                ),
                                child: const Text(
                                  "Crear Cuenta",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Center(
                              child: Text(
                                _errorText,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    required bool obscureText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        dropdownColor: Colors.black,
        iconEnabledColor: Colors.white,
        underline: const SizedBox.shrink(),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _securePasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _gidController.dispose();
    super.dispose();
  }
}
