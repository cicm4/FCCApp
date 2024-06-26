import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/storage_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:fccapp/services/Level_1/authentication_service.dart';
import 'package:fccapp/shared/routes.dart';
import 'package:fccapp/shared/theme.dart';
import 'package:fccapp/wrapper.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

//REMEMBER TO GO TO IOS ON https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup#android WHEN YOU ARE READY TO BUILD FOR IOS

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase and Firebase App Check.
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    if (kDebugMode) {
      print('Firebase initialized successfully');
    }

    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.appAttest,
      );
      if (kDebugMode) {
        print('Firebase App Check activated successfully');
      }
      runApp(const MyApp());
    } catch (e) {
      if (kDebugMode) {
        print('Failed to activate Firebase App Check: $e');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Failed to initialize Firebase: $e');
    }
  }
}

// Now that both futures are resolved, run the app.

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //these services will be initialized only once
    DBService dbs = DBService();
    AuthService auth = AuthService(dbs);
    StorageService st = StorageService();

    //these services may be initialized multiple times
    UserService us = UserService();

    return StreamProvider<User?>.value(
      value: us.userStream,
      initialData: us.user,
      child: MaterialApp(
        routes: getAppRoutes(
          auth,
          dbs,
          st,
        ),
        theme: generalTheme,
        home: Wrapper(auth: auth, dbs: dbs),
      ),
    );
  }
}
