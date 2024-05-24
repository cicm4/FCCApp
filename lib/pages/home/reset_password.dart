import 'package:flutter/material.dart';
import 'package:fccapp/services/Level_1/authentication_service.dart';

class ResetPasswordHome extends StatefulWidget {
  final AuthService auth;

  const ResetPasswordHome({super.key, required this.auth});

  @override
  State<ResetPasswordHome> createState() => _ResetPasswordHomeState();
}

class _ResetPasswordHomeState extends State<ResetPasswordHome> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _message = '';

  Future<void> _sendResetPasswordEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        await widget.auth.sendResetPasswordEmail(_emailController.text);
        setState(() {
          _message =
              'Se ha enviado un correo de restablecimiento de contraseña a ${_emailController.text}';
        });
      } catch (error) {
        setState(() {
          _message =
              'Hubo un error al enviar el correo de restablecimiento de contraseña.';
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Olvide mi contraseña?'),
        backgroundColor:
            const Color(0xFF0b512d), // Customize the color as needed
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color(0xFF0b512d),
          Color(0xFFe6e6e3),
        ])),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo Electronico',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: const TextStyle(
                      color:
                          Colors.black), // Add this line to make the text black
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su correo electronico';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Por favor ingrese un correo electronico valido';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendResetPasswordEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Customize the button color as needed
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Enviar Correo'),
              ),
              const SizedBox(height: 20),
              Text(
                _message,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
