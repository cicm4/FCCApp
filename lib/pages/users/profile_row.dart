import 'package:flutter/material.dart';

class ProfileRow extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  const ProfileRow({super.key, 
    required this.iconPath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
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
          value,
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
}
