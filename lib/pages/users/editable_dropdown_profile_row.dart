import 'package:flutter/material.dart';

class EditableDropdownProfileRow extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;
  final List<String> options;
  final bool isEditing;
  final ValueChanged<String?> onChanged;

  const EditableDropdownProfileRow({super.key, 
    required this.iconPath,
    required this.label,
    required this.value,
    required this.options,
    required this.isEditing,
    required this.onChanged,
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
        isEditing
            ? DropdownButtonFormField<String>(
                value: options.contains(value) ? value : null,
                items: options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: onChanged,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              )
            : Text(
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
