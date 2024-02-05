import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:fccapp/services/Level_0/storage_service.dart';
import 'package:fccapp/services/level_2/scholarships_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:mime/mime.dart';

class FilePreview extends StatefulWidget {
  final UrlFileType fileType;
  final ScholarshipService scholarshipService;
  final StorageService storageService;

  const FilePreview({
    super.key,
    required this.fileType,
    required this.scholarshipService,
    required this.storageService,
  });

  @override
  State<FilePreview> createState() => _FilePreviewState();
}

class _FilePreviewState extends State<FilePreview> {
  Future<Widget> _buildPdfView(Uint8List data) async {
    final Directory tempDir = await getTemporaryDirectory();
    final File tempFile = File('${tempDir.path}/temp.pdf');
    await tempFile.writeAsBytes(data);

    return PDFView(
      filePath: tempFile.path,
      autoSpacing: true,
      enableSwipe: true,
      pageSnap: true,
      swipeHorizontal: true,
      nightMode: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: widget.scholarshipService.getURLFile(
        fileType: widget.fileType,
        storageService: widget.storageService,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('');
        } else {
          Uint8List data = snapshot.data!;
          String mimeType = lookupMimeType('', headerBytes: data) ?? '';

          if (mimeType.startsWith('image/')) {
            return Image.memory(data);
          } else if (mimeType == 'application/pdf') {
            return FutureBuilder<Widget>(
              future: _buildPdfView(data),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error');
                } else {
                  return snapshot.data!;
                }
              },
            );
          } else {
            return const Text(
                'No se puede mostrar el archivo o no hay archivo');
          }
        }
      },
    );
  }
}
