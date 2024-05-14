import 'package:fccapp/services/level_2/help_service.dart';
import 'package:flutter/material.dart';// Import the help_service.dart file

class HelpButton extends StatelessWidget {
  final Help help;
  final VoidCallback onPressed;
  final bool isSelected;

  const HelpButton({super.key, 
    required this.help,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double fontSize = constraints.maxWidth / 10; // Adjust the divisor to fit the desired font size

        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.grey[100],
            backgroundColor: isSelected
                ? Colors.green[800] ?? Colors.green // Dark green when selected
                : Colors.grey[600], // Grey when not selected
          ),
          child: Text(
            help.toString().split('.').last,
            style: TextStyle(fontSize: fontSize),
          ),
        );
      },
    );
  }
}
