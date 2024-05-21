import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // Import the animate_do package

class CertificatePage extends StatefulWidget {
  @override
  _CertificatePageState createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  String _selectedCertificate = '';

  void selectCertificate(String certificate) {
    setState(() {
      _selectedCertificate = certificate;
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "Pedir Certificado",
                    style: TextStyle(
                      fontFamily: 'Montserrat', // Apply Montserrat font
                      color: Colors.white,
                      fontSize: 24, // Increased font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 48), // To balance the space for the back button
                ],
              ),
            ),
            SizedBox(height: 20), // Centered title
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
                                _buildCertificateRow("Certificado 1"),
                                _buildCertificateRow("Certificado 2"),
                                _buildCertificateRow("Certificado 3"),
                                _buildCertificateRow("Certificado 4"),
                                SizedBox(height: 20),
                                MaterialButton(
                                  onPressed: () {
                                    // Handle download file action here
                                  },
                                  height: 50,
                                  color: Color(0xFF0b512d), // Updated color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Descargar Archivo",
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600, // Use Montserrat-SemiBold
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                FilePreview(
                                  fileType: _selectedCertificate,
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

  Widget _buildCertificateRow(String title) {
    return GestureDetector(
      onTap: () => selectCertificate(title),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: _selectedCertificate == title ? Colors.green.shade200 : Colors.white,
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
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600, // Use Montserrat-SemiBold
                color: _selectedCertificate == title ? Colors.white : Colors.black,
              ),
            ),
            if (_selectedCertificate == title)
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