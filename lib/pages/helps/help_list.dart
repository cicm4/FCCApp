import 'package:flutter/material.dart';
import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:fccapp/services/data/help.dart';
import 'package:fccapp/services/level_2/help_service.dart';

class HelpsInProgressPage extends StatefulWidget {
  const HelpsInProgressPage({super.key});

  @override
  _HelpsInProgressPageState createState() => _HelpsInProgressPageState();
}

class _HelpsInProgressPageState extends State<HelpsInProgressPage> {
  List<HelpVar>? helps;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHelps();
  }

  Future<void> _fetchHelps() async {
    final helpsList =
        await HelpService.getHelps(dbs: DBService(), us: UserService());
    setState(() {
      helps = helpsList;
      isLoading = false;
    });

    if (helps == null || helps!.isEmpty) {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text('No se encontraron solicitudes de ayuda.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b512d),
        title: const Text(
          "Ayudas en Proceso",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          color: Colors.white,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : helps == null || helps!.isEmpty
                  ? const Center(child: Text('No se encontraron solicitudes de ayuda.'))
                  : SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 20.0,
                          columns: const [
                            DataColumn(
                              label: Text(
                                'ID',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0b512d),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Mensaje',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Hora',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Estado',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                          rows: helps!.map((help) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          '/helpStatus', arguments: help);
                                    },
                                    child: Text(
                                      help.id ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Color(0xFF0b512d),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      help.message ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    help.time ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    getStatusText(help.status),
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

  String getStatusText(String? status) {
    switch (status) {
      case '0':
        return 'Recibida';
      case '1':
        return 'En Proceso';
      case '2':
        return 'Aceptada';
      case '3':
        return 'Rechazada';
      default:
        return 'Desconocido';
    }
  }
}

class HelpStatusPage extends StatelessWidget {
  final HelpVar help;

  const HelpStatusPage({super.key, required this.help});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b512d),
        title: const Text(
          "Estado de Ayuda",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatusDot(context, help.status == '0'),
                  _buildStatusLine(context),
                  _buildStatusDot(context, help.status == '1'),
                  _buildStatusLine(context),
                  _buildStatusDot(context, help.status == '2'),
                  _buildStatusLine(context),
                  _buildStatusDot(context, help.status == '3'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Recibida',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'En Proceso',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Aceptada',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Rechazada',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDot(BuildContext context, bool isActive) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0b512d) : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildStatusLine(BuildContext context) {
    return Container(
      width: 50,
      height: 2,
      color: Colors.grey,
    );
  }
}