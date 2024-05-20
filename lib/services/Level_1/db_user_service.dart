import 'dart:io';
import 'dart:typed_data';
import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/storage_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class DBUserService {
  final UserService userService;
  final DBService dbService;
  bool _filePickerActive = false;

  DBUserService({required this.userService, required this.dbService});

  Future<Map<String, dynamic>?> getUserData() async {
    return await dbService.getFromDB(
        path: 'users', data: '${userService.user?.uid}');
  }

  Future<String?> getUserName() async {
    var user = await dbService.getFromDB(
        path: 'users', data: '${userService.user?.uid}');
    return user?['displayName'];
  }

  Future<Uint8List?> getProfilePicture({required StorageService st}) async {
    var user = await dbService.getFromDB(
        path: 'users', data: '${userService.user?.uid}');
    if (user?['photoUrl'] == "" || user?['photoUrl'] == null) {
      return null;
    }
    return await st.getFileFromST(path: user?['photoUrl'], data: '${userService.user?.uid}');
  }

  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    try {
      List<String> disallowedFields = ['uid', 'photo', 'type'];
      var user = await dbService.getFromDB(
          path: 'users', data: '${userService.user?.uid}');
      if (user == null) {
        throw Exception('User not found');
      }
      data.forEach((key, value) {
        if (!disallowedFields.contains(key)) {
          user[key] = value;
        }
      });
      await dbService.addEntryToDBWithName(
          path: 'users', entry: user, name: '${userService.user?.uid}');
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred while updating user profile: $e');
      }
      return false;
    }
  }

  Future<List<dynamic>?> pickProfilePicture() async {
    if (_filePickerActive) return null;
    _filePickerActive = true;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
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
    } finally {
      _filePickerActive = false;
    }
  }

  Future<bool> addProfilePicture({required StorageService st, required File file}) async {
    try {
      final photoUrl = 'users/${userService.user?.uid}/profile_picture';
      await st.addFile(path: photoUrl, file: file, data: '${userService.user?.uid}');
      await updateUserProfile({'photoUrl': photoUrl});
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
        return false;
      }
    }
    return false;
  }
}
