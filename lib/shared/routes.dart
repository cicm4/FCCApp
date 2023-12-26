import 'package:fccapp/pages/scholarships/scholarship_home.dart';
import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/storage_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:fccapp/services/Level_1/authentication_service.dart';
import 'package:fccapp/services/level_2/scholarships_service.dart';
import 'package:flutter/widgets.dart';

import '../pages/home/Home.dart';
import '../pages/home/login.dart';
import '../pages/home/register.dart';

Map<String, WidgetBuilder> getAppRoutes(AuthService auth, DBService dbs,
    StorageService st, VoidCallback onUploadComplete) {
  return {
    '/home': (context) => Home(dbs: dbs),
    '/login': (context) => Login(auth: auth),
    '/register': (context) => UserRegister(auth: auth),
    '/scholarshipsHome': (context) => ScholarshipHome(
          scholarshipService:
              ScholarshipService.create(userService: UserService()),
          st: st,
          onUploadComplete: onUploadComplete,
        )
  };
}
