import 'package:flutter/material.dart';

class TestSection extends StatelessWidget {
  const TestSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await Navigator.pushNamed(context, '/test');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0b512d),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        "Test",
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600, // Use Montserrat-SemiBold
          color: Colors.white,
        ),
      ),
    );
  }
}
