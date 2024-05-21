import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:fccapp/services/Level_1/db_user_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'file_selection.dart';
import 'file_preview.dart';
import 'download_button.dart';
import 'package:permission_handler/permission_handler.dart';

class FilesHome extends StatefulWidget {
  final DBService dbs;
  final DBUserService dus;

  FilesHome({super.key, required this.dbs})
      : dus = DBUserService(userService: UserService(), dbService: dbs);

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

    setState(() {
      _pdfFilePath = file.path;
    });
  }

  Future<void> _saveFile(String fileName) async {
    if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(await File(_pdfFilePath!).readAsBytes());
    } else if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.storage.request();
      }
      if (status.isGranted) {
        const downloadsFolderPath = '/storage/emulated/0/Download/';
        final Directory dir = Directory(downloadsFolderPath);
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(await File(_pdfFilePath!).readAsBytes());
      }
    }
  }

  void selectCertificate(String certificate) async {
    String? userName = await widget.dus.getUserName();
    await _createPdf(certificate, userName!);
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
                                  onDownload: () => _saveFile('Certificate_${_selectedCertificate}.pdf'),
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
