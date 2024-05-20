import 'package:flutter/material.dart';
import 'package:fccapp/services/level_2/help_service.dart';

class HelpButton extends StatelessWidget {
  final Help help;
  final VoidCallback onPressed;
  final bool isSelected;
  final double screenWidth;

  const HelpButton({
    super.key,
    required this.help,
    required this.onPressed,
    required this.isSelected,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double fontSize = constraints.maxWidth / 10;
        if (!fontSize.isFinite || fontSize <= 0) {
          fontSize = 16.0; // Fallback font size
        }

        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: isSelected
                ? Colors.green[800] ?? Colors.green // Dark green when selected
                : Colors.teal[600], // Teal when not selected
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fixedSize: Size(screenWidth * 0.4, 50),
          ),
          child: Text(
            help.displayName,
            style: TextStyle(fontSize: fontSize, color: Colors.white),
          ),
        );
      },
    );
  }
}
