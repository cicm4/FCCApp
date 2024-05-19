import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';

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

  updateUserProfile(Map<String, dynamic> data) async {
    try {
      //this expects all except UID, photo and type
      //this will first fetch the data with the DB, change all sections, then update the DB
      var user = await dbService.getFromDB(
          path: 'users', data: '${userService.user?.uid}');
      user?['displayName'] = data['displayName'];
      user?['email'] = data['email'];
      user?['gid'] = data['gid'];
      user?['location'] = data['location'];
      user?['phone'] = data['phone'];
      user?['sport'] = data['sport'];

      await dbService.addEntryToDBWithName(
          path: 'users', entry: user!, name: '${userService.user?.uid}');

      return true;
    } catch (e) {
      return false;
    }
  }
}
