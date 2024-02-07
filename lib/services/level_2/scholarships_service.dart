import 'dart:io';
import 'package:fccapp/services/data/scholarship.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/storage_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:flutter/foundation.dart';

/// An enumeration of the types of URL files that can be handled by the `ScholarshipService` class.
///
/// The `UrlFileType` enum has four possible values:
/// - `matriculaURL`: Represents a URL for a matricula (enrollment) document or page.
/// - `horarioURL`: Represents a URL for a horario (schedule) document or page.
/// - `soporteURL`: Represents a URL for a soporte (support) document or page.
/// - `bankaccount`: Represents a URL for a bank account page or a bank account number.
///
/// This enum is used in the `getURLFile` and `addFiledReqierment` methods of the `ScholarshipService` class
/// to determine the type of the file to retrieve or add. The methods use a switch statement to handle each
/// possible `UrlFileType` value differently.
enum UrlFileType {
  matriculaURL,
  horarioURL,
  soporteURL,
  bankaccount,
}

/// The `ScholarshipService` class is responsible for managing the scholarship data.
///
/// This class provides methods to fetch and manage scholarship data from a database and a storage service.
/// It uses instances of `DBService` and `UserService` to interact with the database and the user data respectively.
///
/// The `ScholarshipService` class has the following properties:
/// - `scholarship`: An instance of the `Scholarship` class that represents the scholarship.
/// - `dbService`: An instance of `DBService` used to fetch and store scholarship data.
/// - `userService`: An instance of `UserService` used to get the current user's data.
///
/// The `ScholarshipService` class provides the following methods:
/// - `_getScholarshipDataFromDB`: Fetches the scholarship data for the current user from the database.
/// - `getURLFile`: Fetches a file from Firebase Storage based on the specified `UrlFileType`.
/// - `getURLFileType`: Opens a file picker and returns the selected file and its name.
/// - `addFiledReqierment`: Adds a file to Firebase Storage and updates the scholarship data in the database.
/// - `getScholarshipData`: Fetches the scholarship data for the current user from the pre-existing `scholarship` object.
/// - `configureScholarship`: Configures the scholarship by fetching the scholarship data and creating a `Scholarship` object from it.
/// - `create`: Creates a new `ScholarshipService`, configures the scholarship, and returns the `ScholarshipService`.
/// - `getStatusNum`: Returns the status number of the scholarship, which is the number of completed items excluding `uid` and `gid`.
///
/// Example usage:
///
/// ```dart
/// final ScholarshipService scholarshipService = await ScholarshipService.create(
///   userService: userService,
///   dbService: dbService,
/// );
/// final Uint8List fileData = await scholarshipService.getURLFile(
///   fileType: UrlFileType.matriculaURL,
///   storageService: storageService,
/// );
/// ```
class ScholarshipService {
  /// The scholarship.
  Scholarship? scholarship;

  /// The `database service used to fetch and store scholarship data.
  DBService dbService;

  /// The user service used to get the current user's data.
  UserService userService;

//used for getters and setters
  bool smartCycle = false;

  /// Private constructor used by the `create` method to create a new `ScholarshipService`.
  ScholarshipService._(
      {this.scholarship, required this.userService, required this.dbService});

  /// Fetches the scholarship data for the current user from the database.
  ///
  /// This method uses the `dbService` property to fetch the scholarship data from the database.
  /// The fetched data is then stored in the `scholarship` property.
  ///
  /// This method is private and is only used internally by the `ScholarshipService` class.
  /// It is called by the `configureScholarship` method during the creation of a `ScholarshipService` instance.
  ///
  /// Throws an `Exception` if the scholarship data could not be fetched.
  ///
  /// Example usage (within the `ScholarshipService` class):
  ///
  /// ```dart
  /// await _getScholarshipDataFromDB();
  /// ```
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
  Future<Uint8List?> getURLFile(
      {required UrlFileType fileType,
      required StorageService storageService}) async {
    try {
      String? path;
      String? data;
      if (kDebugMode) {
        print(
            'calling getURLFile from scholarshipService with fileType: $fileType');
      }
      switch (fileType) {
        case UrlFileType.matriculaURL:
          if (kDebugMode) {
            print(
                'calling getURLFile from scholarshipService with path: ${scholarship!.matriculaURL} and data: ${scholarship!.matriculaURLName}');
          }
          path = scholarship!.matriculaURL;
          data = scholarship!.matriculaURLName;
        case UrlFileType.horarioURL:
          if (kDebugMode) {
            print(
                'calling getURLFile from scholarshipService with path: ${scholarship!.matriculaURL} and data: ${scholarship!.matriculaURLName}');
          }
          path = scholarship!.horarioURL;
          data = scholarship!.horarioURLName;
        case UrlFileType.soporteURL:
          if (kDebugMode) {
            print(
                'calling getURLFile from scholarshipService with path: ${scholarship!.matriculaURL} and data: ${scholarship!.matriculaURLName}');
          }
          path = scholarship!.soporteURL;
          data = scholarship!.soporteURLName;
        case UrlFileType.bankaccount:
          if (kDebugMode) {
            print(
                'calling getURLFile from scholarshipService with path: ${scholarship!.matriculaURL} and data: ${scholarship!.matriculaURLName}');
          }
          path = scholarship!.bankaccountURL;
          data = scholarship!.bankaccountName;
        default: // Should never happen
          throw Exception('Invalid UrlFileType');
      }
      if (kDebugMode) {
        print(
            'calling getFileFromST from storageService with path: $path and data: $data');
      }

      if (data != null && path != null) {
        return await storageService.getFileFromST(path: path, data: data);
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('Error fetching file: $e');
    }
  }

  /// Opens a file picker and allows the user to select a file.
  ///
  /// This method opens a file picker dialog and allows the user to select a file.
  /// The selected file is then returned as a `File` object, along with its name as a `String`.
  ///
  /// The method uses the `file_picker` package to open the file picker dialog.
  /// The `File` object and the file name are returned in a `List`, with the first element being the `File` object and the second element being the file name.
  ///
  /// If the user cancels the file picker dialog without selecting a file, the method returns `null`.
  /// If an error occurs while getting the file, the method catches the error, prints it if in debug mode, and returns `null`.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// final List<dynamic>? selectedFileData = await scholarshipService.pickURLFileType();
  /// if (selectedFileData != null) {
  ///   final File file = selectedFileData[0];
  ///   final String fileName = selectedFileData[1];
  ///   // Use the file and file name...
  /// }
  /// ```
  Future pickURLFileType() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.first.name;
        return [file, fileName];
      } else {
        // User canceled the file picker
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        throw Exception('Error getting file: $e');
      }
      return null;
    }
  }

  /// Adds a file to Firebase Storage and updates the scholarship data in the database.
  ///
  /// This method takes a `UrlFileType`, a `Uint8List` representing the file data, and a `String` representing the file name.
  /// It uploads the file to Firebase Storage and then updates the scholarship data in the database with the URL of the uploaded file.
  ///
  /// The method uses the `storageService` to upload the file to Firebase Storage and the `dbService` to update the scholarship data in the database.
  /// The `UrlFileType` is used to determine the path in Firebase Storage where the file should be uploaded and the field in the scholarship data that should be updated.
  ///
  /// If an error occurs while uploading the file or updating the scholarship data, the method catches the error, prints it if in debug mode, and returns `false`.
  /// If the file is uploaded and the scholarship data is updated successfully, the method returns `true`.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// final bool success = await scholarshipService.addFiledReqierment(
  ///   fileType: UrlFileType.matriculaURL,
  ///   fileData: fileData,
  ///   fileName: fileName,
  /// );
  /// if (success) {
  ///   // The file was uploaded and the scholarship data was updated successfully...
  /// } else {
  ///   // An error occurred...
  /// }
  /// ```
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
        case UrlFileType.bankaccount:
          fileType = 'bankaccountURL';
          fileTypeName = 'bankaccountName';
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
  ///
  /// This method calls the `getScholarshipData` method of the `scholarship` object, which returns a `Map<String, dynamic>` representing the scholarship data.
  ///
  /// The `scholarship` object is an instance of the `Scholarship` class and is expected to have been initialized with the scholarship data for the current user.
  ///
  /// If the `scholarship` object is `null`, this method returns `null`.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// final Map<String, dynamic>? scholarshipData = scholarshipService.getScholarshipData();
  /// if (scholarshipData != null) {
  ///   // Use the scholarship data...
  /// }
  /// ```
  getScholarshipData() {
    return scholarship?.getScholarshipData();
  }

  /// Checks if the bank detail is a URL file.
  ///
  /// This method calls the `isBankDetailAURLFile` method of the `scholarship` object.
  /// The `scholarship` object is expected to have a `isBankDetailAURLFile` method which determines if the bank detail is a URL file.
  ///
  /// Returns:
  /// `true` if the bank detail is a URL file, `false` otherwise and `false` if an error is thrown.
  bool getBankDetailAURLFile() {
    try {
      return scholarship!.getBankDetailAURLFile();
    } catch (e) {
      return false;
    }
  }

  bool getSmartBankDetailAURLFile(bool isFile) {
    if (!smartCycle) {
      smartCycle = true;
      return getBankDetailAURLFile();
    } else {
      return isFile;
    }
  }

  void setBankDetailAURLFile(bool isFile) {
    scholarship?.setBankDetailAURLFile(isFile);
  }

  String? getBankaccount() {
    return scholarship?.bankaccount;
  }

  //sets the text for the bank account asuming that the bank account is not a file
  Future<bool> setBankaccount(String? bankaccount) async {
    try {
      var data = await getScholarshipData();
      data['bankaccount'] = bankaccount;
      await dbService.addEntryToDBWithName(
          path: 'scholarships', entry: data, name: UserService().user!.uid);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }

  /// Configures the scholarship by fetching the scholarship data and creating a `Scholarship` object from it.
  ///
  /// This method fetches the scholarship data from the database by calling the `_getScholarshipDataFromDB` method.
  /// It then creates a new `Scholarship` object from the fetched data using the `Scholarship.fromMap` constructor.
  ///
  /// This method is asynchronous and returns a `Future<void>`. It should be `await`ed.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// await scholarshipsService.configureScholarship();
  /// ```
  Future<void> configureScholarship() async {
    scholarship = Scholarship.fromMap(await _getScholarshipDataFromDB());
  }

  /// Creates a new instance of the `ScholarshipService` class.
  ///
  /// This static method is used to create a new `ScholarshipService` object. It takes two required named parameters: `userService` and `dbService`.
  /// These parameters are used to initialize the `userService` and `dbService` properties of the `ScholarshipService` object.
  ///
  /// The method also calls the `configureScholarship` method to configure the `scholarship` property of the `ScholarshipService` object.
  ///
  /// This method is asynchronous and returns a `Future<ScholarshipService>`. It should be `await`ed.
  ///
  /// If an error occurs during the creation of the `ScholarshipService` object, the method throws an `Exception` with a message indicating the error.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// try {
  ///   final ScholarshipService scholarshipService = await ScholarshipService.create(
  ///     userService: userService,
  ///     dbService: dbService,
  ///   );
  /// } catch (e) {
  ///   print('Failed to create ScholarshipService: $e');
  /// }
  /// ```
  static Future<ScholarshipService> create({
    required UserService userService,
    required DBService dbService,
  }) async {
    try {
      var scholarshipService = ScholarshipService._(
        scholarship: null,
        userService: userService,
        dbService: dbService,
      );
      await scholarshipService.configureScholarship();
      return scholarshipService;
    } catch (e) {
      throw Exception('Failed to create ScholarshipService: $e');
    }
  }

  /// Returns the status number of the scholarship.
  ///
  /// This method calls the `getStatusNum` method of the `scholarship` object.
  ///
  /// If the `scholarship` object is `null` or if an error occurs during the execution of the `getStatusNum` method, this method returns `0`.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// final num statusNum = scholarshipsService.getStatusNum();
  /// ```
  num getStatusNum() {
    try {
      return scholarship!.getStatusNum();
    } catch (e) {
      return 0;
    }
  }
}
