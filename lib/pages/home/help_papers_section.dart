import 'package:flutter/material.dart';

class HelpPapersSection extends StatelessWidget {
  const HelpPapersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Ayudas y Papeles",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Text color set to black
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/helpHome');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0b512d),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Mis Ayudas",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600, // Use Montserrat-SemiBold
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/filesHome');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0b512d),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Pedir Certificado",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600, // Use Montserrat-SemiBold
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
