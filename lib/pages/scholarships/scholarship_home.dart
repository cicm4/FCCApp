import 'package:fccapp/services/level_2/scholarships_service.dart';
import 'package:flutter/material.dart';

class ScholarshipHome extends StatefulWidget {
  final Future<ScholarshipService> scholarshipService;
  const ScholarshipHome({super.key, required this.scholarshipService});

  @override
  State<ScholarshipHome> createState() => _ScholarshipHomeState();
}

class _ScholarshipHomeState extends State<ScholarshipHome> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ScholarshipService>(
      future: widget.scholarshipService,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading spinner while waiting
        } else if (snapshot.hasError) {
          return const Text(
              'Error'); // Show an error message if something went wrong
        } else {
          ScholarshipService scholarshipService = snapshot.data!;
          Scholarship? scholarship = scholarshipService.scholarship;
          return Scaffold(
            appBar: AppBar(
              title: Text('Scholarship Home'),
            ),
            body: Material(
              child: ListView(
                children: <Widget>[
                  _buildListItem(
                      'Liquidacion de Matricula', scholarship?.matriculaURL),
                  _buildListItem('Horario', scholarship?.horarioURL),
                  _buildListItem('Soporte de Pago', scholarship?.soporteURL),
                  _buildListItem('Numero de Banco', scholarship?.bankaccount),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildListItem(String title, String? value) {
    return ListTile(
      title: Text(title),
      trailing: Icon(
        value != null ? Icons.check : Icons.close,
        color: value != null ? Colors.green : Colors.red,
      ),
    );
  }
}
