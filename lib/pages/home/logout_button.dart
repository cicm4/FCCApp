import 'package:flutter/material.dart';
import 'package:fccapp/services/Level_1/authentication_service.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AuthService.signOut();
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: const Center(
        child: Text(
          'Cambiar de cuenta',
          style: TextStyle(
            fontSize: 14, // Making text small
            color: Colors.blue, // Text color blue
            decoration: TextDecoration.underline, // Underlined text
          ),
        ),
      ),
    );
  }
}
