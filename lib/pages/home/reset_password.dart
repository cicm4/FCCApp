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
          _message = 'Reset password email sent successfully.';
        });
      } catch (error) {
        setState(() {
          _message = 'Error sending reset password email: $error';
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
        title: Text('Reset Password'),
        backgroundColor: Color(0xFF0b512d), // Customize the color as needed
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendResetPasswordEmail,
              child: Text('Reset Password'),
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // Customize the button color as needed
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
