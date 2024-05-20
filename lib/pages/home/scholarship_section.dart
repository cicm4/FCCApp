import 'package:flutter/material.dart';
import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/level_2/scholarships_service.dart';

class ScholarshipSection extends StatefulWidget {
  final DBService dbs;
  final ScholarshipService scholarshipService;
  const ScholarshipSection({super.key, required this.dbs, required this.scholarshipService});

  @override
  State<ScholarshipSection> createState() => _ScholarshipSectionState();
}

class _ScholarshipSectionState extends State<ScholarshipSection> {
  late num scholarshipStatus;

  @override
  void initState() {
    super.initState();
    scholarshipStatus = widget.scholarshipService.getStatusNum();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        const Text(
          "Mi Beca",
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            await Navigator.pushNamed(context, '/scholarshipsHome');
            setState(() {
              scholarshipStatus = widget.scholarshipService.getStatusNum();
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0b512d),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fixedSize: Size(screenWidth * 0.4, 50),
          ),
          child: const Text(
            "Subir Archivos",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600, // Use Montserrat-SemiBold
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 30), // Increased space to lower the section
      ],
    );
  }
}
