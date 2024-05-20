import 'package:flutter/material.dart';

class HelpPapersSection extends StatelessWidget {
  const HelpPapersSection({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        const Text(
          "Ayudas y Papeles",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
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
                fixedSize: Size(screenWidth * 0.42, 50), // 42% of screen width and fixed height of 50
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
                fixedSize: Size(screenWidth * 0.42, 50), // 42% of screen width and fixed height of 50
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