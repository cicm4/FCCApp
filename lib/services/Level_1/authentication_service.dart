import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// This class is responsible for handling user authentication using Firebase.
class AuthService {
  ///constructor that passes a database service to limit the number of database service objects
  AuthService(this.dbs);

  // Stream of Firebase User to track user authentication state

  //database service that is used to add new users to firestore
  DBService dbs;

  /// Sign in with email and password.
  ///
  /// This method attempts to sign in a user using their email and password.
  /// If the user is not found in the database, it adds them.
  ///
  /// @param emailAddress The email address of the user.
  /// @param password The password of the user.
  ///
  /// @return A Future that completes with a boolean if the sign-in process is successful, or with an error code if an error occurs.
  Future<dynamic> signInEmailAndPass(
      {required emailAddress, required password}) async {
    try {
      // Create a UserService instance
      UserService us = UserService();
      // Attempt to sign in the user using their email and password
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      // Check if the user is in the database
      bool isUserInDB = await _isUserInDB(uid: us.user?.uid);
      // If the user is not found in the database, add them
      if (isUserInDB == false) {
        await _addNewUserToDB();
      }
      // If the sign-in process is successful, return true
      return true;
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth exceptions
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          print('No user found for that email.');
        }
        // Return the error code
        return "No se encontro el usuario";
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
        // Return the error code
        return "Contraseña incorrecta";
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        if (kDebugMode) {
          print('invalid credentials for login');
        }
        // Return the error code
        return "Credenciales de inicio de sesión no válidas";
      } else {
        if (kDebugMode) {
          print(e.code);
        }
        // Return the error code
        return e.code;
      }
    }
  }

  /// Sign out the current user.
  ///
  /// This method then signs out the current user from the Firebase instance.
  static signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Adds a new user to the database.
  ///
  /// This method creates a new user document and a new calendar document in the database.
  /// It also adds an entry to the 'scholarships' collection for the new user.
  ///
  /// The new user document is added to the 'users' collection, and the new calendar document
  /// is added to the 'calendars' collection. The 'scholarships' entry is added to the 'scholarships' collection.
  ///
  /// The user document contains the following fields:
  /// * 'uid': the user's unique ID
  /// * 'email': the user's email address
  /// * 'displayName': the user's display name
  /// * 'photoUrl': the URL of the user's profile photo
  /// * 'type': the user's type (always 'donor')
  /// * 'phone': the user's phone number
  /// * 'sport': the user's sport
  /// * 'gid': the user's GID
  /// * 'location': the user's location
  /// * 'cid': the ID of the user's calendar
  ///
  /// The calendar document contains the following fields:
  /// * 'uid': the user's unique ID
  /// * 'cid': the ID of the calendar
  /// * 'isReady': a boolean indicating whether the calendar is ready (always false)
  ///
  /// The 'scholarships' entry contains the following field:
  /// * 'uid': the user's unique ID
  ///
  /// The [name], [phone], [sport], [gid], and [location] parameters are optional and can be null.
  /// If [name] is null, the user's display name is used as the name.
  /// If [phone], [sport], [gid], or [location] is null, the corresponding field in the user document is left empty.
  ///
  /// Throws an exception if an error occurs while adding the documents to the database.
  Future<void> _addNewUserToDB(
      {String? name,
      String? phone,
      String? sport,
      String? gid,
      String? location}) async {
    try {
      UserService us = UserService();
      String? uid = us.user!.uid;
      String? email = us.user!.email;
      String? displayName = us.user!.displayName;
      String? photoUrl = us.user!.photoURL;
      String? type = 'donor';

      displayName ??= name;

      photoUrl ??= '';

      var newUser = {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'type': type,
        'phone': phone,
        'sport': sport,
        'gid': gid,
        'location': location,
      };

      var newCalendar = {
        'uid': uid,
        'isReady': false,
      };

      await dbs.addEntryToDBWithName(path: 'users', entry: newUser, name: uid);

      await dbs.addEntryToDBWithName(
          path: 'scholarships', entry: {'uid': uid}, name: uid);

      await dbs.addEntryToDBWithName(
          path: 'calendars', entry: newCalendar, name: uid);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Check if a user is in the database.
  ///
  /// This private method checks if a user with a specific uid is in the database.
  ///
  /// @param uid The uid of the user to check.
  ///
  /// @return A Future that completes with a boolean. Returns true if the user is in the database, false otherwise.
  Future<bool> _isUserInDB({String? uid}) async {
    if (uid == null) {
      return false;
    }
    try {
      return dbs.isDataInDB(data: uid, path: 'users');
    } catch (e) {
      if (kDebugMode) {
        print(e);
        return false;
      }
    }
    return false;
  }

  /// Register a new user with email and password.
  ///
  /// This method attempts to register a new user using their email and password.
  /// If the user is already found in the database, it returns an error message.
  ///
  /// @param emailAddress The email address of the new user.
  /// @param password The password of the new user.
  /// @param name The name of the new user.
  ///
  /// @return A Future that completes with a String. Returns 'Success' if the user is successfully registered, an error message otherwise.
  Future<String> registerWithEmailAndPass(
      {required emailAddress,
      required password,
      required name,
      required phone,
      required sport,
      required gid,
      required location}) async {
    // Register with email and password
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      // Add the new user to the database
      await _addNewUserToDB(
          name: name, phone: phone, sport: sport, gid: gid, location: location);
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth exceptions
      if (e.code == 'weak-password') {
        return 'La contraseña proporcionada es demasiado débil..';
      } else if (e.code == 'email-already-in-use') {
        return 'La cuenta ya existe para ese correo electrónico.';
      } else if (e.code == 'invalid-email') {
        return 'Dirección de correo electrónico no válida';
      } else {
        return 'Error: ${e.toString()}';
      }
    } catch (e) {
      // Handle any other exceptions
      return 'Error: ${e.toString()}';
    }
    // If the user is successfully registered, return 'Success'
    return 'Success';
  }
}
