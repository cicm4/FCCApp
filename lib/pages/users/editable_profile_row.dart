import 'package:flutter/material.dart';

class EditableProfileRow extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;
  final bool isEditing;
  final bool isDate;
  final ValueChanged<String> onChanged;
  final ValueChanged<DateTime?>? onDatePicked;

  const EditableProfileRow({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
    required this.isEditing,
    required this.onChanged,
    this.isDate = false,
    this.onDatePicked,
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
            ? isDate
                ? GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (onDatePicked != null) {
                        onDatePicked!(pickedDate);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0b512d),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Text(
                        value.isEmpty ? 'Seleccionar fecha' : value,
                        style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                      ),
                    ),
                  )
                : TextFormField(
                    initialValue: value,
                    onChanged: onChanged,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      filled: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
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
