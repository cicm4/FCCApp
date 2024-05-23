  import 'dart:io';

  import 'package:fccapp/services/Level_0/database_service.dart';
  import 'package:fccapp/services/Level_0/storage_service.dart';
  import 'package:fccapp/services/Level_0/user_service.dart';
  import 'package:file_picker/file_picker.dart';
  import 'package:flutter/foundation.dart';

  class HelpService {
    static Future<bool> makeRequest({
      required Help help, required String message, required UserService us, required DBService dbs, required File file, required StorageService st}) async {
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
          'time': DateTime.now().toString(),
          'id': id
        };

        await _addExtraFile(dbs: dbs, file: file, st: st, uid: uid, id: id);

        String name = uid + DateTime.now().toString() + help.toString();

        await dbs.addEntryToDBWithName(
            path: 'adminNotification', entry: data, name: name);

        return true;
      } catch (e) {
        return false;
      }
    }
  }

  Future<List<dynamic>?> pickExtraFile() async {
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
  String _random10Digits() {
    String result = '';
    for (int i = 0; i < 10; i++) {
      result += (0 + (10 * (DateTime.now().microsecondsSinceEpoch % 1))).toString();
    }
    return result;
  }

  Future<String> _idGenerator(DBService dbs) async{
    String id = _random10Digits();
    bool isInDB = await dbs.isDataInDB(data: id, path: 'helps/');
    if(isInDB){
      return _idGenerator(dbs);
    } else {
      return id;
    }
  }

  Future<bool> _addExtraFile({required DBService dbs, required File file, required StorageService st, required String uid, required String id}) async {
    try {
      final data = {'id': id, 'uid': uid};
      bool stAddition = await st.addFile(file: file, data: id, path: 'helps/');
      if(stAddition){
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
