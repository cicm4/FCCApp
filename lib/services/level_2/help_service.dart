import 'dart:io';
import 'dart:math';
import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/storage_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:fccapp/services/data/help.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class HelpService {
  static Future<bool> makeRequest(
      {required Help help,
      required String message,
      required UserService us,
      required DBService dbs,
      required File file,
      required StorageService st,
      required String name}) async {
    //get UID
    String? uid = us.user?.uid.toString();

    if (uid == null) {
      throw Exception('User not logged in');
    }

    //get email
    String? email = us.user?.email.toString();

    if (email == null) {
      throw Exception('User not logged in');
    }

    String id = await _idGenerator(dbs);

    try {
      Map<String, String> data = {
        'uid': uid,
        'email': email,
        'message': message,
        'help': help.toString(),
        'time': DateTime.now()
            .toString()
            .substring(0, 10), //take only the first 10 characters
        'id': id,
        'status': '0'

        //status 0 = received
        //status 1 = pending
        //status 2 = accepted
        //status 3 = rejected
      };

      await _addExtraFile(
          dbs: dbs, file: file, st: st, uid: uid, id: id, name: name);

      await dbs.addEntryToDBWithName(
          path: 'adminNotification', entry: data, name: id);

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<HelpVar>?> getHelps(
      {required DBService dbs, required UserService us}) async {
    try {
      List<Map<String, dynamic>>? helps = await dbs.getListWithVariableFromDB(
          path: 'adminNotification',
          variable: 'uid',
          value: us.user!.uid.toString());
      List<HelpVar> helpList = [];
      for (Map<String, dynamic> help in helps!) {
        helpList.add(HelpVar.fromMap(help));
      }
      return helpList;
    } catch (e) {
      if (kDebugMode) {
        throw Exception('Error getting helps: $e');
      }
      return null;
    }
  }

  static Future<List<dynamic>?> pickExtraFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'webp'],
      );
      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.first.name;
        return [file, fileName];
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        throw Exception('Error getting file: $e');
      }
      return null;
    }
  }

//returns 10 random digits used as ID for request
  static String _random10Digits() {
    return Random.secure().nextInt(2000000000).toString();
  }

  static Future<String> _idGenerator(DBService dbs) async {
    String id = _random10Digits();
    bool isInDB = await dbs.isDataInDB(data: id, path: 'helps/');
    if (isInDB) {
      return _idGenerator(dbs);
    } else {
      return id;
    }
  }

  static Future<bool> _addExtraFile(
      {required DBService dbs,
      required File file,
      required StorageService st,
      required String uid,
      required String id,
      required String name}) async {
    try {
      //parse name extension
      String extension = name.split('.').last;
      String fileName = '$id.$extension';
      bool stAddition =
          await st.addFile(file: file, data: fileName, path: 'helps/');
      if (stAddition) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
        return false;
      }
    }
    return false;
  }
}

enum Help { deportivo, academico, salud, otro }

extension HelpExtension on Help {
  String get displayName {
    switch (this) {
      case Help.deportivo:
        return 'Deportivo';
      case Help.academico:
        return 'Academico';
      case Help.salud:
        return 'Salud';
      case Help.otro:
        return 'Otro';
      default:
        return '';
    }
  }
}
