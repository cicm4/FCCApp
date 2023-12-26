import 'package:fccapp/services/Level_0/storage_service.dart';
import 'package:fccapp/services/level_2/scholarships_service.dart';
import 'package:flutter/material.dart';

class ScholarshipHome extends StatefulWidget {
  final Future<ScholarshipService> scholarshipService;
  final StorageService st;

  const ScholarshipHome({
    Key? key,
    required this.scholarshipService,
    required this.st,
  }) : super(key: key);

  @override
  State<ScholarshipHome> createState() => _ScholarshipHomeState();
}

class _ScholarshipHomeState extends State<ScholarshipHome> {
  UrlFileType? selectedFileType;
  var selectedFile;
  bool isUploading = false;

  @override
  void dispose() {
    if (mounted) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ScholarshipService>(
      future: widget.scholarshipService,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading spinner while waiting
        } else if (snapshot.hasError) {
          return const Text(
              'Error'); // Show an error message if something went wrong
        } else {
          ScholarshipService scholarshipService = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Scholarship Home'),
            ),
            body: Material(
              child: ListView(
                children: <Widget>[
                  _buildListItem('Liquidacion de Matricula', 'matriculaURL',
                      scholarshipService, UrlFileType.matriculaURL),
                  _buildListItem('Horario', 'horarioURL', scholarshipService,
                      UrlFileType.horarioURL),
                  _buildListItem('Soporte de Pago', 'soporteURL',
                      scholarshipService, UrlFileType.soporteURL),
                  _buildListItem('Numero de Banco', 'bankAccount',
                      scholarshipService, UrlFileType.bankAccount),
                  _buildButtons(scholarshipService),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> uploadFile(ScholarshipService scholarshipService) async {
    setState(() {
      isUploading = true;
    });

    try {
      bool uploadResult = await scholarshipService.addFiledReqierment(
        st: widget.st,
        type: selectedFileType!,
        file: selectedFile![0],
        fileName: selectedFile![1],
      );

      if (uploadResult) {
        await scholarshipService.configureScholarship();
        ; // Call the callback function
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        isUploading = false;
        selectedFile = null;
        selectedFileType = null;
      });
    }
  }

  Widget _buildListItem(String title, String type,
      ScholarshipService scholarshipService, UrlFileType urlFileType) {
    var dataFromDatabase = scholarshipService.getScholarshipData();
    return ListTile(
      title: Text(title),
      trailing: Icon(
        dataFromDatabase[type] != null ? Icons.check : Icons.close,
        color: dataFromDatabase[type] != null ? Colors.green : Colors.red,
      ),
      onTap: () {
        setState(() {
          selectedFileType = urlFileType;
          selectedFile = null;
        });
      },
    );
  }

  Widget _buildButtons(ScholarshipService scholarshipService) {
    return Visibility(
      visible: selectedFileType != null,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              selectedFile = await scholarshipService.getURLFileType();
              setState(() {});
            },
            child: const Text('Select File'),
          ),
          ElevatedButton(
            onPressed: selectedFile != null
                ? () => uploadFile(scholarshipService)
                : null,
            child: isUploading
                ? CircularProgressIndicator()
                : const Text('Upload File'),
          ),
        ],
      ),
    );
  }
}
