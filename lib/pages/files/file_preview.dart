import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class FilePreview extends StatelessWidget {
  final String? pdfFilePath;

  const FilePreview({super.key, required this.pdfFilePath});

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
