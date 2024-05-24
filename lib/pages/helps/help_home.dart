import 'package:animate_do/animate_do.dart';
import 'package:fccapp/pages/helps/help_list.dart';
import 'package:fccapp/services/Level_0/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:fccapp/services/level_2/help_service.dart';
import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'dart:io';
import 'help_button.dart';

class HelpHome extends StatefulWidget {
  const HelpHome({super.key});

  @override
  State<HelpHome> createState() => _HelpHomeState();
}

class _HelpHomeState extends State<HelpHome> {
  final TextEditingController _messageController = TextEditingController();
  bool _showTextBox = false;
  bool _showLoading = false;
  Help? _selectedHelp;
  dynamic _selectedFile;
  String? _name;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      // This will trigger the widget to rebuild and re-evaluate the condition for the 'Send' button.
    });
  }

  Future<void> _pickFile() async {
    final result = await HelpService.pickExtraFile();
    if (result != null) {
      setState(() {
        _selectedFile = result[0] as File;
        _name = result[1] as String;
      });
    }
  }

  void _handleSend() async {
    if (_selectedFile == null) {
      // Show an alert if no file is selected
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Anexa un archivo'),
          content: const Text('Por favor, anexa un archivo para enviar tu mensaje'),
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
      return;
    }

    setState(() {
      _showLoading = true;
    });

    bool success = await HelpService.makeRequest(
      help: _selectedHelp!,
      message: _messageController.text,
      st: StorageService(),
      dbs: DBService(),
      us: UserService(),
      file: _selectedFile!,
      name: _name!,
    );

    if (!mounted) return; // Check if the widget is still in the tree

    setState(() {
      _showLoading = false;
    });

    if (success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Mensaje Enviado'),
          content: const Text('Su mensaje ha sido enviado con éxito.'),
          actions: [
            TextButton(
              onPressed: () {
                if (mounted) {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Pop the current page
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color(0xFF0b512d),
              Color(0xFFe6e6e3),
              Color(0xFF22c0c6),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    "Solicitacion de ayudas",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: bottomInset),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    height: MediaQuery.of(context).size.height * 0.8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildHelpButton(Help.deportivo),
                                    _buildHelpButton(Help.academico),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildHelpButton(Help.salud),
                                    _buildHelpButton(Help.otro),
                                  ],
                                ),
                                if (_showTextBox) ...[
                                  const SizedBox(height: 20),
                                  TextField(
                                    controller: _messageController,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Enter your message here",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: _pickFile,
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.white),
                                      foregroundColor: MaterialStateProperty.all(const Color(0xFF0b512d)),
                                    ),
                                    child: const Text('Anexar Archivo'),
                                  ),
                                  const SizedBox(height: 10),
                                  if (_selectedFile != null)
                                    Text('File: ${_selectedFile!.path.split('/').last}'),
                                  const SizedBox(height: 10),
                                  MaterialButton(
                                    onPressed: _messageController.text.isNotEmpty
                                        ? _handleSend
                                        : null,
                                    height: 50,
                                    color: Colors.teal[600],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Send",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                if (_showLoading) ...[
                                  const CircularProgressIndicator(),
                                ],
                                
                                ElevatedButton(
                                      onPressed: () async {
                                        //navigator to reset password
                                        Navigator.pushNamed(context, '/helpList');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        "Mis solicitudes de ayuda",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpButton(Help help) {
    return HelpButton(
      screenWidth: MediaQuery.of(context).size.width,
      help: help,
      isSelected: _selectedHelp == help,
      onPressed: () {
        setState(() {
          _selectedHelp = help;
          _showTextBox = true;
        });
      },
    );
  }
}
