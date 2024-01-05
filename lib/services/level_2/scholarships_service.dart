import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/storage_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:flutter/foundation.dart';

/// The `ScholarshipService` class is responsible for managing the scholarship data.
enum UrlFileType {
  matriculaURL,
  horarioURL,
  soporteURL,
  bankAccount,
}

class ScholarshipService {
  /// The current scholarship.
  Scholarship? scholarship;

  /// The database service used to fetch and store scholarship data.
  DBService dbService;

  /// The user service used to get the current user's data.
  UserService userService;

  /// Private constructor used by the `create` method to create a new `ScholarshipService`.
  ScholarshipService._(
      {this.scholarship, required this.userService, required this.dbService});

  /// Fetches the scholarship data for the current user from the database.
  _getScholarshipDataFromDB() async {
    return await dbService.getFromDB(
        path: 'scholarships', data: '${userService.user?.uid}');
  }

  /// Fetches a file from Firebase Storage based on the specified [fileType].
  ///
  /// The [fileType] parameter is an enum of type `UrlFileType` that specifies the type of the file to retrieve.
  /// The [storageService] parameter is an instance of `StorageService` that is used to interact with Firebase Storage.
  ///
  /// This method uses a switch statement to determine the path and data for the file based on the [fileType].
  /// It then calls the `getFileFromST` method of the `StorageService` class to retrieve the file.
  ///
  /// If the file is successfully retrieved, this method returns the file as a `Uint8List`.
  /// If an error occurs during retrieval, this method throws an exception with a message that includes the error.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// final Uint8List fileData = await scholarshipService.getURLFile(
  ///   fileType: UrlFileType.matriculaURL,
  ///   storageService: storageService,
  /// );
  /// ```
  ///
  /// Throws:
  ///   - `Exception` if an invalid `UrlFileType` is provided.
  ///   - `Exception` if there is an error fetching the file.
  Future<Uint8List> getURLFile(
      {required UrlFileType fileType,
      required StorageService storageService}) async {
    try {
      String path;
      String data;
      switch (fileType) {
        case UrlFileType.matriculaURL:
          path = scholarship!.matriculaURL!;
          data = scholarship!.matriculaURLName!;
        case UrlFileType.horarioURL:
          path = scholarship!.horarioURL!;
          data = scholarship!.horarioURLName!;
        case UrlFileType.soporteURL:
          path = scholarship!.soporteURL!;
          data = scholarship!.soporteURLName!;
        case UrlFileType.bankAccount:
          path = scholarship!.bankaccount!;
          data = scholarship!.bankaccountName!;
        default: // Should never happen
          throw Exception('Invalid UrlFileType');
      }
      print(
          'calling getFileFromST from storageService with path: $path and data: $data');
      final Uint8List fileData =
          await storageService.getFileFromST(path: path, data: data);
      return fileData;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('Error fetching file: $e');
    }
  }

  Future getURLFileType() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'txt'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.first.name;
      return [file, fileName];
    }
  }

  Future showURLFileTypeFile(
      {required UrlFileType type,
      required StorageService storageService}) async {}

  Future addFiledReqierment(
      {required StorageService st,
      required UrlFileType type,
      required fileURL,
      required fileName}) async {
    try {
      String fileType;
      String fileTypeName;

      var data = await getScholarshipData();

      switch (type) {
        case UrlFileType.matriculaURL:
          fileType = 'matriculaURL';
          fileTypeName = 'matriculaURLName';
          break;
        case UrlFileType.horarioURL:
          fileType = 'horarioURL';
          fileTypeName = 'horarioURLName';
          break;
        case UrlFileType.soporteURL:
          fileType = 'soporteURL';
          fileTypeName = 'soporteURLName';
          break;
        case UrlFileType.bankAccount:
          fileType = 'bankAccount';
          fileTypeName = 'bankAccountName';
          break;
      }
      try {
        data[fileType] = 'scholarships/${userService.user?.uid}/$fileType';
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      try {
        data[fileTypeName] = fileName;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }

      await st.addFile(
          path: 'scholarships/${userService.user?.uid}/$fileType',
          file: fileURL,
          data: fileName);

      await dbService.addEntryToDBWithName(
          path: 'scholarships', entry: data, name: UserService().user!.uid);

      return true;
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
  Future<void> configureScholarship() async {
    scholarship = Scholarship.fromMap(await _getScholarshipDataFromDB());
  }

  /// Creates a new `ScholarshipService`, configures the scholarship, and returns the `ScholarshipService`.
  static Future<ScholarshipService> create(
      {required UserService userService, required DBService dbService}) async {
    var scholarshipService = ScholarshipService._(
        scholarship: null, userService: userService, dbService: dbService);
    await scholarshipService.configureScholarship();
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

  /// The Name of the matricula.
  final String? matriculaURLName;

  /// The URL of the horario.
  final String? horarioURL;

  /// The Name of the horario.
  final String? horarioURLName;

  /// The URL of the soporte.
  final String? soporteURL;

  /// The Name of the soporte.
  final String? soporteURLName;

  /// The bank account associated with the scholarship.
  final String? bankaccount;

  final String? bankaccountName;

  /// Creates a new `Scholarship` with the given data.
  Scholarship({
    required this.uid,
    required this.gid,
    required this.matriculaURL,
    required this.horarioURL,
    required this.soporteURL,
    required this.bankaccount,
    required this.matriculaURLName,
    required this.horarioURLName,
    required this.soporteURLName,
    required this.bankaccountName,
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
      matriculaURLName: data['matriculaURLName'],
      horarioURLName: data['horarioURLName'],
      soporteURLName: data['soporteURLName'],
      bankaccountName: data['bankAccountName'],
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

  /// Returns a map of the scholarship data.
  getScholarshipData() {
    return {
      'uid': uid,
      'gid': gid,
      'matriculaURL': matriculaURL,
      'horarioURL': horarioURL,
      'soporteURL': soporteURL,
      'bankaccount': bankaccount,
      'matriculaURLName': matriculaURLName,
      'horarioURLName': horarioURLName,
      'soporteURLName': soporteURLName,
      'bankAccountName': bankaccountName,
    };
  }
}
