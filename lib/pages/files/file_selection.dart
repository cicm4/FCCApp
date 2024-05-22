import 'package:flutter/material.dart';

class FileSelection extends StatelessWidget {
  final String selectedCertificate;
  final Function(String) onSelect;

  const FileSelection({super.key, required this.selectedCertificate, required this.onSelect});

  Widget _buildCertificateRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () => onSelect(title),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: selectedCertificate == title ? Colors.green.shade200 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(11, 81, 45, .3),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: selectedCertificate == title ? Colors.white : Colors.black,
              ),
            ),
            if (selectedCertificate == title)
              const Icon(
                Icons.check,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCertificateRow(context, "Certificado 1"),
        _buildCertificateRow(context, "Certificado 2"),
        _buildCertificateRow(context, "Certificado 3"),
        _buildCertificateRow(context, "Certificado 4"),
      ],
    );
  }
}
