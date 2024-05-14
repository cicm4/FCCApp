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
    // Assume HelpService.makeRequest is implemented as shown before
    bool success = await HelpService.makeRequest(
        _selectedHelp!, _messageController.text, UserService(), DBService());
    if (!mounted) return; // Check if the widget is still in the tree
    setState(() {
      _showLoading = false;
    });
    if (success) {
      // Only proceed if the widget is still mounted
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Home'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = (constraints.maxWidth / 150).floor(); // Adjust 150 to change the button size
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 3, // Adjust the aspect ratio as needed
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: Help.values.length,
                  itemBuilder: (context, index) {
                    final help = Help.values[index];
                    return HelpButton(
                      help: help,
                      isSelected: _selectedHelp == help,
                      onPressed: () {
                        setState(() {
                          _selectedHelp = help;
                          _showTextBox = true;
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          if (_showTextBox) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Enter your message here',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _messageController.text.isNotEmpty ? _handleSend : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green[800] ?? Colors.green, // Fallback color
              ),
              child: const Text('Send'),
            ),
          ],
          if (_showLoading) ...[
            const CircularProgressIndicator(),
          ],
        ],
      ),
    );
  }
}
