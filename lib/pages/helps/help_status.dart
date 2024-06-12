import 'package:fccapp/services/data/help.dart';
import 'package:flutter/material.dart'; // Assuming you have HelpVar in a file named help_var.dart

class HelpStatusPageNotList extends StatefulWidget {
  final HelpVar help;

  const HelpStatusPageNotList({super.key, required this.help});

  @override
  _HelpStatusPageNotListState createState() => _HelpStatusPageNotListState();
}

class _HelpStatusPageNotListState extends State<HelpStatusPageNotList> {
  late bool _isReceived;
  late bool _isInProcess;
  late bool _isCompleted;
  late bool _isRejected;

  @override
  void initState() {
    super.initState();
    _initializeStatus();
  }

  void _initializeStatus() {
    _isReceived = widget.help.status == '0';
    _isInProcess = widget.help.status == '1';
    _isCompleted = widget.help.status == '2';
    _isRejected = widget.help.status == '3'; // New condition for rejected status
  }

  void _nextStage() {
    setState(() {
      if (_isReceived) {
        _isReceived = false;
        _isInProcess = true;
        widget.help.status = '1';
      } else if (_isInProcess) {
        _isInProcess = false;
        _isCompleted = true;
        widget.help.status = '2'; // Mark as completed
      }
    });
    // Here you can add logic to update the status in your backend if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b512d),
        title: const Text(
          "Detalles de Ayuda",
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
        child: _isRejected ? _buildRejectedStatus() : _buildStatusTimeline(),
      ),
    );
  }

  Widget _buildRejectedStatus() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.red,
        ),
        SizedBox(height: 10),
        Text(
          "Rechazado",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTimeline() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _isReceived ? Colors.green : Colors.grey,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Recibida",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Container(
              height: 2,
              width: 50,
              color: Colors.grey,
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _isInProcess ? Colors.green : Colors.grey,
                ),
                const SizedBox(height: 10),
                const Text(
                  "En Proceso",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Container(
              height: 2,
              width: 50,
              color: Colors.grey,
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _isCompleted ? Colors.green : Colors.grey,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Finalizada",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
