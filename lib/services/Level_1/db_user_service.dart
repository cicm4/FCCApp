//user class/service that acts as an extension of the userService class
//this class can fetch all data from the current user
//it can also update the user's data
//due to single responsibility principle, this class will not retrieve event data

import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';

class DBUserService {
  final UserService userService;
  final DBService dbService;

  DBUserService({required this.userService, required this.dbService});

  getUserData() async {
    return await dbService.getFromDB(
        path: 'users', data: '${userService.user?.uid}');
  }
}
