import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/storage_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:flutter/foundation.dart';

/// The `ScholarshipService` class is responsible for managing the scholarship data.
enum UrlFileType {
  matricula,
  horario,
  soporte,
  bankAccount,
}

class ScholarshipService {
  /// The current scholarship.
  Scholarship? scholarship;

  /// The database service used to fetch and store scholarship data.
  DBService dbService = DBService();

  /// The user service used to get the current user's data.
  UserService userService;

  /// Private constructor used by the `create` method to create a new `ScholarshipService`.
  ScholarshipService._({this.scholarship, required this.userService});

  /// Fetches the scholarship data for the current user from the database.
  _getScholarshipDataFromDB() async {
    return await dbService.getFromDB(
        path: 'scholarships', data: '${userService.user?.uid}');
  }

  //such as matricula and horario URLS, essensialy any URL file that will be saved on the storage and URL on the database
  /// Method to add a file requirement such as matricula and horario URLs.
  /// These are essential URL files that will be saved on the storage and URL on the database.
  ///
  /// The [st] parameter is the storage service used to store the file.
  /// The [type] parameter is the type of the file, represented by the [UrlFileType] enum.
  ///
  /// This method returns a [Future] that completes with a boolean value.
  /// The boolean value is true if the file was successfully added, and false otherwise.
  ///
  /// This method uses the [FilePicker] package to pick the file from the device file system.
  /// It only allows files with the extensions 'jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'txt'.
  ///
  /// If the file is successfully picked, it is added to the storage with the [StorageService.addFile] method.
  /// The path of the file in the storage is 'scholarships/${userService.user?.uid}/$fileType/$fileName'.
  ///
  /// After the file is added to the storage, the scholarship data in the database is updated with the new file path.
  /// The data is updated with the [DBService.addEntryToDBWithName] method.
  /// The path of the data in the database is 'scholarships'.
  ///
  /// If an error occurs while picking the file, adding it to the storage, or updating the data in the database,
  /// the method catches the error and returns false.
  Future<bool> addFiledReqierment(
      {required StorageService st, required UrlFileType type}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'txt'],
    );
    try {
      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.first.name;

        String fileType;

        var data = await getScholarshipData();

        switch (type) {
          case UrlFileType.matricula:
            fileType = 'matriculaURL';
            break;
          case UrlFileType.horario:
            fileType = 'horarioURL';
            break;
          case UrlFileType.soporte:
            fileType = 'soporteURL';
            break;
          case UrlFileType.bankAccount:
            fileType = 'bankaccount';
            break;
        }

        data[fileType] =
            'scholarships/${userService.user?.uid}/$fileType/$fileName';

        await st.addFile(
            path: 'scholarships/${userService.user?.uid}/$fileType/$fileName',
            file: file,
            data: fileName);

        await dbService.addEntryToDBWithName(
            path: 'scholarships', entry: data, name: UserService().user!.uid);

        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
        return false;
      }
    }
    return false;
  }

  /// Fetches the scholarship data for the current user from the pre-existing `scholarship` object.
  getScholarshipData() {
    return scholarship?.getScholarshipData();
  }

  /// Configures the scholarship by fetching the scholarship data and creating a `Scholarship` object from it.
  Future<void> _configureScholarship() async {
    scholarship = Scholarship.fromMap(await _getScholarshipDataFromDB());
  }

  /// Creates a new `ScholarshipService`, configures the scholarship, and returns the `ScholarshipService`.
  static Future<ScholarshipService> create(
      {required UserService userService}) async {
    var scholarshipService =
        ScholarshipService._(scholarship: null, userService: userService);
    await scholarshipService._configureScholarship();
    return scholarshipService;
  }

  /// Returns the status number of the scholarship, which is the number of completed items excluding `uid` and `gid`.
  /// If an error occurs (for example, if `scholarship` is `null`), returns 0.
  num getStatusNum() {
    try {
      return scholarship!.getStatusNum();
    } catch (e) {
      return 0;
    }
  }
}

/// The `Scholarship` class represents a scholarship.
class Scholarship {
  /// The unique ID of the scholarship.
  final String? uid;

  /// The GID of the scholarship.
  final String? gid;

  /// The URL of the matricula.
  final String? matriculaURL;

  /// The URL of the horario.
  final String? horarioURL;

  /// The URL of the soporte.
  final String? soporteURL;

  /// The bank account associated with the scholarship.
  final String? bankaccount;

  /// Creates a new `Scholarship` with the given data.
  Scholarship({
    required this.uid,
    required this.gid,
    required this.matriculaURL,
    required this.horarioURL,
    required this.soporteURL,
    required this.bankaccount,
  });

  /// Creates a new `Scholarship` from a map of data.
  factory Scholarship.fromMap(Map<String, dynamic> data) {
    return Scholarship(
      uid: data['uid'],
      gid: data['gid'],
      matriculaURL: data['matriculaURL'],
      horarioURL: data['horarioURL'],
      soporteURL: data['soporteURL'],
      bankaccount: data['bankaccount'],
    );
  }

  /// Returns the status number of the scholarship, which is the number of completed items excluding `uid` and `gid`.
  num getStatusNum() {
    int status = 0;
    if (matriculaURL != null) {
      status++;
    }
    if (horarioURL != null) {
      status++;
    }
    if (soporteURL != null) {
      status++;
    }
    if (bankaccount != null) {
      status++;
    }
    return status;
  }

  getScholarshipData() {
    return {
      'matriculaURL': matriculaURL,
      'horarioURL': horarioURL,
      'soporteURL': soporteURL,
      'bankaccount': bankaccount,
    };
  }
}
