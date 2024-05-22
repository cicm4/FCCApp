import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'file_selection.dart';
import 'file_preview.dart';
import 'download_button.dart';
import 'package:fccapp/services/Level_1/db_user_service.dart';

class FilesHome extends StatefulWidget {
  final DBUserService dus;

  FilesHome({super.key, required this.dus});

  @override
  State<FilesHome> createState() => _FilesHomeState();
}

class _FilesHomeState extends State<FilesHome> {
  String? _pdfFilePath;
  bool _isLoading = true;
  String _selectedCertificate = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    String? userName = await widget.dus.getUserName();
    if (!mounted) return; // Check if the widget is still mounted
    setState(() {
      _isLoading = false;
    });
    await _createPdf('Certificado 1', userName!); // Load default certificate
  }

  Future<void> _createPdf(String certificateType, String userName) async {
    final PdfDocument document = PdfDocument();
    document.pages.add().graphics.drawString(
      'Certificate Type: $certificateType\nUser: $userName',
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: const Rect.fromLTWH(0, 0, 150, 20),
    );

    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final File file = File('$tempPath/$certificateType$userName.pdf');
    final List<int> bytes = await document.save();
    await file.writeAsBytes(bytes);
    document.dispose();

    if (!mounted) return; // Check if the widget is still mounted
    setState(() {
      _pdfFilePath = file.path;
    });
  }

  Future<void> _downloadFile() async {
    if (_pdfFilePath != null) {
      try {
        final Directory? downloadsDir = await _getDownloadsDirectory();
        if (downloadsDir == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unable to access storage')));
          return;
        }

        final String newFilePath = '${downloadsDir.path}/Certificate_${_selectedCertificate}.pdf';
        final File newFile = File(newFilePath);
        await newFile.writeAsBytes(await File(_pdfFilePath!).readAsBytes());

        if (!mounted) return; // Check if the widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File saved to $newFilePath')));
      } catch (e) {
        if (!mounted) return; // Check if the widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving file: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No file to download')));
    }
  }

  Future<Directory?> _getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    return null;
  }

  void selectCertificate(String certificate) async {
    String? userName = await widget.dus.getUserName();
    await _createPdf(certificate, userName!);
    if (!mounted) return; // Check if the widget is still mounted
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
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ),
            SizedBox(height: 20),
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
                                FileSelection(
                                  selectedCertificate: _selectedCertificate,
                                  onSelect: selectCertificate,
                                ),
                                SizedBox(height: 20),
                                DownloadButton(
                                  onDownload: _downloadFile,
                                  isLoading: _isLoading,
                                ),
                                SizedBox(height: 20),
                                FilePreview(
                                  pdfFilePath: _pdfFilePath,
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
}
