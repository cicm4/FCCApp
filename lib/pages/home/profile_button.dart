import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: const Icon(Icons.account_circle, color: Colors.white, size: 40),
        onPressed: () {
          Navigator.pushNamed(context, '/userHome');
        },
      ),
    );
  }
}
