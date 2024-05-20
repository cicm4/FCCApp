import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fccapp/pages/scholarships/file_preview_home.dart';
import 'package:fccapp/services/Level_0/storage_service.dart';
import 'package:fccapp/services/level_2/scholarships_service.dart';

class ScholarshipHome extends StatefulWidget {
  final Future<ScholarshipService> scholarshipService;
  final StorageService st;

  const ScholarshipHome({
    super.key,
    required this.scholarshipService,
    required this.st,
  });

  @override
  State<ScholarshipHome> createState() => _ScholarshipHomeState();
}

class _ScholarshipHomeState extends State<ScholarshipHome> {
  UrlFileType? selectedFileType;
  dynamic selectedFile;
  String? bankAccountText = '';
  bool isUploading = false;
  dynamic dataFromDatabase;
  bool isBankAccountFile = false;

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
          bankAccountText = scholarshipService.getBankaccount();
          isBankAccountFile = scholarshipService.getSmartBankDetailAURLFile(isBankAccountFile);

          return Scaffold(
            body: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.teal.shade600,
                    Colors.green.shade300,
                    Colors.tealAccent.shade400,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 30),
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
                          "Scholarship Home",
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
                  const SizedBox(height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: dataFromDatabase != null &&
                                  scholarshipService.getStatusNum() > index
                              ? Colors.green
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: SingleChildScrollView(
                      
                      reverse: false,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
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
                                      _buildUploadRow(
                                          "Liquidacion de Matricula",
                                          "matriculaURL",
                                          scholarshipService,
                                          UrlFileType.matriculaURL,
                                          dataFromDatabase),
                                      _buildUploadRow("Horario", "horarioURL",
                                          scholarshipService, UrlFileType.horarioURL, dataFromDatabase),
                                      _buildUploadRow(
                                          "Soporte de Pago",
                                          "soporteURL",
                                          scholarshipService,
                                          UrlFileType.soporteURL,
                                          dataFromDatabase),
                                      _buildBankAccountItem(
                                          scholarshipService),
                                      const SizedBox(height: 20),
                                      _buildSelectFileButton(
                                          scholarshipService),
                                      _buildUploadButton(
                                          scholarshipService),
                                      _buildFilePreview(
                                          scholarshipService),
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
      },
    );
  }

  Widget _buildSelectFileButton(ScholarshipService scholarshipService) {
    return Visibility(
      visible: selectedFileType != null &&
          (isBankAccountFile || selectedFileType != UrlFileType.bankaccount),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: () => uploadFile(
            scholarshipService, selectedFileType.toString().split('.')[1]),
        child: isUploading
            ? const CircularProgressIndicator()
            : const Text('Upload File', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildFilePreview(ScholarshipService scholarshipService) {
    return Visibility(
      visible: true,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: constraints.maxHeight == double.infinity
                  ? MediaQuery.of(context).size.height - 400
                  : constraints.maxHeight,
              child: selectedFileType != null
                  ? FilePreview(
                      fileType: selectedFileType!,
                      scholarshipService: scholarshipService,
                      storageService: widget.st,
                    )
                  : const Center(
                      child: Text(
                        'Select a file to preview',
                        style: TextStyle(color: Colors.black),
                      ),
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
              await scholarshipService.setBankaccount(bankAccountText);
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

  Widget _buildUploadRow(
      String title,
      String type,
      ScholarshipService scholarshipService,
      UrlFileType urlFileType,
      var dataFromDatabase) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFileType = urlFileType;
          selectedFile = null;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: selectedFileType == urlFileType ? Colors.green.shade200 : Colors.white,
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
                color: selectedFileType == urlFileType ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              dataFromDatabase[type] != null ? Icons.check : Icons.close,
              color: dataFromDatabase[type] != null ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankAccountItem(ScholarshipService scholarshipService) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedFileType = UrlFileType.bankaccount;
              selectedFile = null;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: selectedFileType == UrlFileType.bankaccount ? Colors.green.shade200 : Colors.white,
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
                  'Numero de Banco',
                  style: TextStyle(
                    color: selectedFileType == UrlFileType.bankaccount ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  (dataFromDatabase['bankaccountURL'] != null || dataFromDatabase['bankaccount'] != null)
                      ? Icons.check
                      : Icons.close,
                  color: (dataFromDatabase['bankaccountURL'] != null || dataFromDatabase['bankaccount'] != null)
                      ? Colors.green
                      : Colors.red,
                ),
              ],
            ),
          ),
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
          visible: selectedFileType == UrlFileType.bankaccount && !isBankAccountFile,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                bankAccountText = value;
              },
              controller: TextEditingController(text: bankAccountText),
              style: const TextStyle(color: Colors.black), // Black text
              decoration: const InputDecoration(
                labelText: 'Bank Account Number',
                labelStyle: TextStyle(color: Colors.black), // Black label text
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
