import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fccapp/services/level_2/help_service.dart';
import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
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

  void _handleSend() async {
    setState(() {
      _showLoading = true;
    });
    bool success = await HelpService.makeRequest(
        _selectedHelp!, _messageController.text, UserService(), DBService());
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.teal.shade600,
              Colors.green.shade300,
              Colors.tealAccent.shade400,
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
                  padding:
                      EdgeInsets.only(left: 5, right: 5, bottom: bottomInset),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildHelpButton(Help.zapato),
                                    _buildHelpButton(Help.dermatologico),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildHelpButton(Help.oftamologico),
                                    _buildHelpButton(Help.calamidad),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildHelpButton(Help.tutoria),
                                    _buildHelpButton(Help.otro),
                                  ],
                                ),
                                if (_showTextBox) ...[
                                  const SizedBox(height: 20),
                                  TextField(
                                    controller: _messageController,
                                    style: const TextStyle(
                                      color: Colors.black
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Enter your message here",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  MaterialButton(
                                    onPressed:
                                        _messageController.text.isNotEmpty
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
