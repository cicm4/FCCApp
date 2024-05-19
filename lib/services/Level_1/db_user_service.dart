import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:flutter/foundation.dart';

class DBUserService {
  final UserService userService;
  final DBService dbService;

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

  getProfilePicture() async {
    var user = await dbService.getFromDB(
        path: 'users', data: '${userService.user?.uid}');
    return user?['photoUrl'];
  }

  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
  try {
    // Define a list of disallowed fields
    List<String> disallowedFields = ['uid', 'photo', 'type'];

    // Fetch user data from the database
    var user = await dbService.getFromDB(path: 'users', data: '${userService.user?.uid}');
    if (user == null) {
      throw Exception('User not found');
    }

    // Update only allowed fields
    data.forEach((key, value) {
      if (!disallowedFields.contains(key)) {
        user[key] = value;
      }
    });

    // Update the database with the modified user data
    await dbService.addEntryToDBWithName(path: 'users', entry: user, name: '${userService.user?.uid}');

    return true;
  } catch (e) {
    if (kDebugMode) {
      print('An error occurred while updating user profile: $e');
    }
    return false;
  }
}

}
