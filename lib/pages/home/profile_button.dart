import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Icon(Icons.account_circle, color: Colors.white, size: 30),
        onPressed: () {
          Navigator.pushNamed(context, '/userHome');
        },
      ),
    );
  }
}
