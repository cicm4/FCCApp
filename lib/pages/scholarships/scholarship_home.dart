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
  String? bankAccountText = '';
  bool isUploading = false;
  var dataFromDatabase;
  bool isBankAccountFile = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ScholarshipService>(
      future: widget.scholarshipService,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error');
        } else {
          ScholarshipService scholarshipService = snapshot.data!;
          dataFromDatabase = scholarshipService.getScholarshipData();
          bankAccountText = scholarshipService.getBankAccount();

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
                  _buildBankAccountItem(scholarshipService),
                  _buildSelectFileButton(scholarshipService),
                  _buildUploadButton(scholarshipService),
                  _buildFilePreview(scholarshipService),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildSelectFileButton(ScholarshipService scholarshipService) {
    return Visibility(
      visible: selectedFileType != null &&
          (isBankAccountFile || selectedFileType != UrlFileType.bankaccount),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800]),
        onPressed: () async {
          selectedFile = await scholarshipService.pickURLFileType();
          setState(() {});
        },
        child: const Text('Select File', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildUploadButton(ScholarshipService scholarshipService) {
    return Visibility(
      visible: selectedFileType != null &&
          (selectedFile != null ||
              (selectedFileType == UrlFileType.bankaccount &&
                  !isBankAccountFile)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800]),
        onPressed: () => uploadFile(
            scholarshipService, selectedFileType.toString().split('.')[1]),
        child: isUploading
            ? const CircularProgressIndicator()
            : const Text('Upload File', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  String? getFileTypeData() {
    var splitList = selectedFileType.toString().split('.');
    if (splitList.length > 1) {
      return dataFromDatabase[splitList[1]];
    }
    return null;
  }

  Widget _buildFilePreview(ScholarshipService scholarshipService) {
    return Visibility(
      visible: selectedFileType != null &&
              dataFromDatabase[selectedFileType.toString().split('.')[1]] !=
                  null ||
          (selectedFileType == UrlFileType.bankaccount && !isBankAccountFile),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: constraints.maxHeight == double.infinity
                  ? MediaQuery.of(context).size.height - 400
                  : constraints.maxHeight,
              child: FilePreview(
                fileType: selectedFileType!,
                scholarshipService: scholarshipService,
                storageService: widget.st,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> uploadFile(
      ScholarshipService scholarshipService, String? urlFileType) async {
    setState(() {
      isUploading = true;
    });

    bool uploadResult;
    try {
      if (urlFileType != 'bankaccount' || urlFileType == null) {
        uploadResult = await scholarshipService.addFiledReqierment(
          st: widget.st,
          type: selectedFileType!,
          fileURL: selectedFile![0],
          fileName: selectedFile![1],
        );
      } else {
        if (isBankAccountFile) {
          uploadResult = await scholarshipService.addFiledReqierment(
            st: widget.st,
            type: selectedFileType!,
            fileURL: selectedFile![0],
            fileName: selectedFile![1],
          );
        } else {
          uploadResult =
              await scholarshipService.setBankAccount(bankAccountText);
        }
      }

      if (uploadResult) {
        await scholarshipService.configureScholarship();
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

  Widget _buildBankAccountItem(ScholarshipService scholarshipService) {
    return Column(
      children: [
        ListTile(
          tileColor: selectedFileType == UrlFileType.bankaccount
              ? Colors.green[800]
              : null,
          title: const Text('Numero de Banco',
              style: TextStyle(color: Colors.white)),
          trailing: Icon(
            dataFromDatabase['bankaccount'] != null ? Icons.check : Icons.close,
            color: dataFromDatabase['bankaccount'] != null
                ? Colors.green
                : Colors.red,
          ),
          onTap: () {
            setState(() {
              selectedFileType = UrlFileType.bankaccount;
              selectedFile = null;
            });
          },
        ),
        Visibility(
          visible: selectedFileType == UrlFileType.bankaccount,
          child: SwitchListTile(
            title: const Text('Switch to URL file type'),
            value: isBankAccountFile,
            onChanged: (bool value) {
              setState(() {
                isBankAccountFile = value;
              });
            },
          ),
        ),
        Visibility(
          visible:
              selectedFileType == UrlFileType.bankaccount && !isBankAccountFile,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                bankAccountText = value;
              },
              controller: TextEditingController(text: bankAccountText),
              decoration: const InputDecoration(
                labelText: 'Bank Account Number',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
