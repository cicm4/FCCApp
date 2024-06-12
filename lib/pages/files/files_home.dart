import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fccapp/services/Level_1/db_user_service.dart';

class FilesHome extends StatefulWidget {
  final DBUserService dus;

  const FilesHome({super.key, required this.dus});

  @override
  State<FilesHome> createState() => _FilesHomeState();
}

class _FilesHomeState extends State<FilesHome> {
  String? _pdfFilePath;
  bool _isLoading = true;
  String _selectedCertificate = '';
  String? _userName;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _userName = await widget.dus.getUserName();
    _userData = await widget.dus.getUserData();
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _createPdf(String certificateType) async {
    if (_userData == null) return;

    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();

    final ByteData logoData = await rootBundle.load('assets/LOGOFCC.png');
    final ByteData bottomInfoData = await rootBundle.load('assets/bottomInfo.png');
    final ByteData signatureData = await rootBundle.load('assets/signature.png');
    final List<int> logoBytes = logoData.buffer.asUint8List();
    final List<int> bottomInfoBytes = bottomInfoData.buffer.asUint8List();
    final List<int> signatureBytes = signatureData.buffer.asUint8List();

    final PdfBitmap logoBitmap = PdfBitmap(logoBytes);
    page.graphics.drawImage(
      logoBitmap,
      Rect.fromLTWH(
        page.getClientSize().width - (logoBitmap.width * 0.2),
        0,
        logoBitmap.width * 0.2,
        logoBitmap.height * 0.2,
      ),
    );

    final String currentDate = DateTime.now().toIso8601String().split('T').first;
    page.graphics.drawString(
      'FECHA DE EXPEDICIÓN: $currentDate\n',
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      bounds: Rect.fromLTWH(0, 60, page.getClientSize().width, 20),
    );

    String content;
    if (certificateType == 'Certificado de Permanencia') {
      content =
          'A quien pueda interesar\n\nLa fundación club campestre certifica que el señor ${_userData!['displayName']} identificado con cc ${_userData!['gid']} es beneficiario de los programas educativos de la fundación desde el ${_userData!['startDate']} hasta la fecha.\n\nAtentamente\n\n\n\n\nPaula Cristina Pérez González\nDirectora';
    } else if (certificateType == 'Certificado de Egresados') {
      if(_userData?['endDate'] != null) {
        content =
            'A quien pueda interesar\n\nLa fundación club campestre certifica que el señor ${_userData!['displayName']} identificado con cc ${_userData!['gid']} fue beneficiario de los programas educativos de la fundación desde el ${_userData!['startDate']} hasta el ${_userData!['endDate']}.\n\nAtentamente\n\n\n\n\nPaula Cristina Pérez González\nDirectora';
      } else {
        content =
            'A quien pueda interesar\n\nLa fundación club campestre certifica que el señor ${_userData!['displayName']} identificado con cc ${_userData!['gid']} fue beneficiario de los programas educativos de la fundación desde el ${_userData!['startDate']} hasta la fecha.\n\nAtentamente\n\n\n\n\nPaula Cristina Pérez González\nDirectora';
      }
      content =
          'A quien pueda interesar\n\nLa fundación club campestre certifica que el señor ${_userData!['displayName']} identificado con cc ${_userData!['gid']} fue beneficiario de los programas educativos de la fundación desde el ${_userData!['startDate']} hasta el día $currentDate.\n\nAtentamente\n\n\n\n\nPaula Cristina Pérez González\nDirectora';
    } else {
      return;
    }

    page.graphics.drawString(
      content,
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      bounds: Rect.fromLTWH(0, 80, page.getClientSize().width, page.getClientSize().height - 160),
    );

    final PdfBitmap signatureBitmap = PdfBitmap(signatureBytes);
    page.graphics.drawImage(
      signatureBitmap,
      Rect.fromLTWH(
        0,
        page.getClientSize().height - 160,
        signatureBitmap.width.toDouble() * 0.5,
        signatureBitmap.height.toDouble() * 0.5,
      ),
    );

    page.graphics.drawString(
      'Fecha: $currentDate\n',
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      bounds: Rect.fromLTWH(0, page.getClientSize().height - 120, page.getClientSize().width, 20),
    );

    final PdfBitmap bottomInfoBitmap = PdfBitmap(bottomInfoBytes);
    double bottomInfoWidth = page.getClientSize().width * 0.8;
    double bottomInfoHeight = (bottomInfoWidth * bottomInfoBitmap.height) / bottomInfoBitmap.width;
    page.graphics.drawImage(
      bottomInfoBitmap,
      Rect.fromLTWH(
        (page.getClientSize().width - bottomInfoWidth) / 2,
        page.getClientSize().height - bottomInfoHeight,
        bottomInfoWidth,
        bottomInfoHeight,
      ),
    );

    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final File file = File('$tempPath/$certificateType.pdf');
    final List<int> bytes = await document.save();
    await file.writeAsBytes(bytes);
    document.dispose();

    if (!mounted) return;
    setState(() {
      _pdfFilePath = file.path;
      _isLoading = false;
    });
  }

  Future<void> _downloadFile() async {
    if (_pdfFilePath != null) {
      try {
        final Directory? downloadsDir = await _getDownloadsDirectory();
        if (downloadsDir == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to access storage')));
          return;
        }

        final String newFilePath = '${downloadsDir.path}/Certificate_${_selectedCertificate.replaceAll(' ', '_')}.pdf';
        final File newFile = File(newFilePath);
        await newFile.writeAsBytes(await File(_pdfFilePath!).readAsBytes());

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File saved to $newFilePath')));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving file: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No file to download')));
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
    setState(() {
      _isLoading = true;
      _selectedCertificate = certificate;
      _pdfFilePath = null;
    });
    await _createPdf(certificate);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
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
                    "Pedir Certificado",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 24,
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
                                FileSelection(
                                  selectedCertificate: _selectedCertificate,
                                  onSelect: selectCertificate,
                                ),
                                const SizedBox(height: 20),
                                DownloadButton(
                                  onDownload: _downloadFile,
                                  isLoading: _selectedCertificate.isEmpty || _isLoading,
                                ),
                                const SizedBox(height: 20),
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

class FileSelection extends StatelessWidget {
  final String selectedCertificate;
  final Function(String) onSelect;

  const FileSelection({
    super.key,
    required this.selectedCertificate,
    required this.onSelect,
  });

  Widget _buildCertificateRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () => onSelect(title),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: selectedCertificate == title ? Colors.green.shade200 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
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
                fontWeight: FontWeight.w600,
                color: selectedCertificate == title ? Colors.white : Colors.black,
              ),
            ),
            if (selectedCertificate == title)
              const Icon(
                Icons.check,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCertificateRow(context, "Certificado de Permanencia"),
        _buildCertificateRow(context, "Certificado de Egresados"),
      ],
    );
  }
}

class DownloadButton extends StatelessWidget {
  final Function onDownload;
  final bool isLoading;

  const DownloadButton({
    super.key,
    required this.onDownload,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isLoading ? null : () => onDownload(),
      height: 50,
      color: const Color(0xFF0b512d),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Center(
        child: Text(
          "Descargar Archivo",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class FilePreview extends StatelessWidget {
  final String? pdfFilePath;

  const FilePreview({
    super.key,
    required this.pdfFilePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      color: Colors.grey.shade300,
      child: pdfFilePath == null
          ? const Center(child: Text('No file selected', style: TextStyle(fontSize: 18)))
          : PDFView(
              filePath: pdfFilePath!,
              autoSpacing: true,
              enableSwipe: true,
              pageSnap: true,
              swipeHorizontal: true,
              nightMode: false,
              
            ),
    );
  }
}
