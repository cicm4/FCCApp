import 'package:fccapp/pages/calendars/calendar_home.dart';
import 'package:fccapp/pages/files/files_home.dart';
import 'package:fccapp/pages/helps/help_home.dart';
import 'package:fccapp/pages/scholarships/scholarship_home.dart';
import 'package:fccapp/pages/users/user_home.dart';
import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/storage_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:fccapp/services/Level_1/authentication_service.dart';
import 'package:fccapp/services/Level_1/db_user_service.dart';
import 'package:fccapp/services/level_2/scholarships_service.dart';
import 'package:flutter/widgets.dart';

import '../pages/home/Home.dart';
import '../pages/home/login.dart';
import '../pages/home/register.dart';

Map<String, WidgetBuilder> getAppRoutes(
    AuthService auth, DBService dbs, StorageService st) {
  return {
    '/home': (context) => Home(dbs: dbs),
    '/login': (context) => Login(auth: auth),
    '/register': (context) => UserRegister(auth: auth),
    '/scholarshipsHome': (context) => ScholarshipHome(
          scholarshipService: ScholarshipService.create(
              userService: UserService(), dbService: dbs),
          st: st,
        ),
    '/calendarHome': (context) => const CalendarHome(),
    '/helpHome': (context) => const HelpHome(),
    '/filesHome': (context) => FilesHome(dbs: dbs),
    '/userHome': (context) => UserHome(dbu: DBUserService(userService: UserService(), dbService: dbs))
  };
}
