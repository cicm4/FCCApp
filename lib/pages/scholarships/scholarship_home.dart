import 'package:fccapp/pages/scholarships/file_preview_home.dart';
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
  var dataFromDatabase;

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
          dataFromDatabase = scholarshipService.getScholarshipData();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Scholarship Home'),
              backgroundColor: Colors.black,
            ),
            body: Material(
              color: Colors.black,
              child: ListView(
                children: <Widget>[
                  _buildListItem(
                      'Liquidacion de Matricula',
                      'matriculaURL',
                      scholarshipService,
                      UrlFileType.matriculaURL,
                      dataFromDatabase),
                  _buildListItem('Horario', 'horarioURL', scholarshipService,
                      UrlFileType.horarioURL, dataFromDatabase),
                  _buildListItem(
                      'Soporte de Pago',
                      'soporteURL',
                      scholarshipService,
                      UrlFileType.soporteURL,
                      dataFromDatabase),
                  _buildListItem(
                      'Numero de Banco',
                      'bankAccount',
                      scholarshipService,
                      UrlFileType.bankAccount,
                      dataFromDatabase),
                  _buildButtons(scholarshipService),
                  selectedFileType != null &&
                          dataFromDatabase[
                                  selectedFileType.toString().split('.')[1]] !=
                              null
                      ? LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: constraints.maxHeight == double.infinity
                                    ? MediaQuery.of(context)
                                            .size
                                            .height - //here goes the height of everything else
                                        400
                                    : constraints.maxHeight,
                                child: FilePreview(
                                  fileType: selectedFileType!,
                                  scholarshipService: scholarshipService,
                                  storageService: widget.st,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(),
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
        fileURL: selectedFile![0],
        fileName: selectedFile![1],
      );

      if (uploadResult) {
        await scholarshipService
            .configureScholarship(); // Call the callback function
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

  Widget _buildListItem(
      String title,
      String type,
      ScholarshipService scholarshipService,
      UrlFileType urlFileType,
      var dataFromDatabase) {
    return ListTile(
      tileColor: selectedFileType == urlFileType ? Colors.green[800] : null,
      title: Text(title, style: const TextStyle(color: Colors.white)),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800]),
            onPressed: () async {
              selectedFile = await scholarshipService.getURLFileType();
              setState(() {});
            },
            child: const Text('Select File',
                style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800]),
            onPressed: selectedFile != null
                ? () => uploadFile(scholarshipService)
                : null,
            child: isUploading
                ? const CircularProgressIndicator()
                : const Text('Upload File',
                    style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
