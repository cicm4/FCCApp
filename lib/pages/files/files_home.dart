import 'dart:io';
import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:fccapp/services/Level_1/db_user_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

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
    _createPdf(userName!);
  }

  Future<void> _createPdf(String userName) async {
    final PdfDocument document = PdfDocument();
    document.pages.add().graphics.drawString(
      'Hello $userName!',
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: const Rect.fromLTWH(0, 0, 150, 20),
    );

    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final File file = File('$tempPath/Hello_$userName.pdf');
    final List<int> bytes = await document.save();
    await file.writeAsBytes(bytes);
    document.dispose();

    setState(() {
      _pdfFilePath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _pdfFilePath == null
                ? const Text('Failed to generate PDF')
                : PDFView(
                    filePath: _pdfFilePath!,
                    autoSpacing: true,
                    enableSwipe: true,
                    pageSnap: true,
                    swipeHorizontal: true,
                    nightMode: true,
                  ),
      ),
    );
  }
}
