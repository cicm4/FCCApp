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
}
