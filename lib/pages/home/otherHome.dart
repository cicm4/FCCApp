import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<bool> _fileUploaded = [false, false, false, false];
  String _selectedFileType = '';

  void selectFileType(String fileType) {
    setState(() {
      _selectedFileType = fileType;
    });
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
            SizedBox(height: 30),  // Increased height to lower the text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      // Handle back button action
                    },
                  ),
                  Text(
                    "Scholarship Home",
                    style: TextStyle(
                      fontFamily: 'Montserrat', // Apply Montserrat font
                      color: Colors.white,
                      fontSize: 24,  // Increased font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 48), // To balance the space for the back button
                ],
              ),
            ),
            SizedBox(height: 0),  // Increased height for better spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: _fileUploaded[index] ? Colors.green : Colors.grey,
                  ),
                );
              }),
            ),
            SizedBox(height: 5),
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: bottomInset),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          FadeInUp(
                            duration: Duration(milliseconds: 1400),
                            child: Column(
                              children: [
                                _buildUploadRow("Liquidacion de Matricula", 0),
                                _buildUploadRow("Horario", 1),
                                _buildUploadRow("Soporte de Pago", 2),
                                _buildUploadRow("Numero de Banco", 3),
                                SizedBox(height: 20),
                                MaterialButton(
                                  onPressed: () {
                                    if (_selectedFileType.isNotEmpty) {
                                      setState(() {
                                        final index = [
                                          "Liquidacion de Matricula",
                                          "Horario",
                                          "Soporte de Pago",
                                          "Numero de Banco"
                                        ].indexOf(_selectedFileType);
                                        if (index != -1) _fileUploaded[index] = true;
                                      });
                                    }
                                  },
                                  height: 50,
                                  color: Colors.teal[600],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Select File",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                FilePreview(
                                  fileType: _selectedFileType,
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

  Widget _buildUploadRow(String title, int index) {
    return GestureDetector(
      onTap: () => selectFileType(title),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: _selectedFileType == title ? Colors.green.shade200 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
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
                color: _selectedFileType == title ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_fileUploaded[index])
              Icon(
                Icons.check,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}

class FilePreview extends StatelessWidget {
  final String fileType;

  FilePreview({required this.fileType});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35, // Adjust height as needed
      color: Colors.grey.shade300,
      child: Center(
        child: Text(
          fileType.isNotEmpty ? 'Preview of $fileType' : 'No file selected',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}