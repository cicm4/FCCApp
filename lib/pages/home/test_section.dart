import 'package:flutter/material.dart';

class TestSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await Navigator.pushNamed(context, '/test');
      },
      child: Text(
        "Test",
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600, // Use Montserrat-SemiBold
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF0b512d),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
