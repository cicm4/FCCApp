import 'package:flutter/material.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';

class DownloadTest extends StatefulWidget {
  const DownloadTest({super.key});

  @override
  State<DownloadTest> createState() => _DownloadTestState();
}

class _DownloadTestState extends State<DownloadTest> {
  final _flutterMediaDownloaderPlugin = MediaDownload();

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ElevatedButton(onPressed: () async {
            _flutterMediaDownloaderPlugin.downloadMedia(context,'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf');
          }, child: const Text('Media Download')),
        ),
      ),
    );
  }
}
