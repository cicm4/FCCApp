import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:fccapp/services/Level_1/admin_service.dart';
import 'package:fccapp/services/Level_1/authentication_service.dart';
import 'package:fccapp/services/level_2/scholarships_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final DBService dbs;
  const Home({super.key, required this.dbs});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAdmin = false;
  late ScholarshipService scholarshipService;
  num scholarshipStatus = 0;

  @override
  initState() {
    super.initState();
    // Call the checkAdmin function on widget creation
    checkAdmin();
    initScholarshipService();
  }

  Future<void> initScholarshipService() async {
    scholarshipService = await ScholarshipService.create(
        userService: UserService(), dbService: widget.dbs);
    scholarshipStatus = scholarshipService.getStatusNum();
    if (mounted) {
      setState(() {});
    }
  }

  void checkAdmin() {
    AdminService.isAdmin(dbService: widget.dbs, userService: UserService())
        .then((bool isAdminResult) {
      // Set state is called to rebuild the widget with the updated isAdmin value.
      if (mounted) {
        setState(() {
          isAdmin = isAdminResult;
        });
      }
    }).catchError((error) {
      // Handle any errors here
      if (kDebugMode) {
        print('An error occurred while checking admin status: $error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print('Home build');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Home'),
            const SizedBox(height: 20),
            Text('$isAdmin'),
            const SizedBox(height: 20), // Add some spacing
            GestureDetector(
              onTap: () {
                // Call your sign-out function here
                signOutUser();
              },
              child: const Text(
                'Sign out',
                style: TextStyle(
                  fontSize: 14, // Making text small
                  color: Colors.blue, // Text color blue
                  decoration: TextDecoration.underline, // Underlined text
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(context, '/scholarshipsHome');
                initScholarshipService();
              },
              child: const Text(
                'becas',
                style: TextStyle(
                  fontSize: 14, // Making text small
                  color: Colors.blue, // Text color blue
                  decoration: TextDecoration.underline, // Underlined text
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: LinearProgressIndicator(
                value: scholarshipStatus / 4,
                color: Colors.green[800],
                minHeight: 10.0,
              ),
            ),
            const SizedBox(height: 20),
            Text(UserService().user!.email!),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(context, '/calendarHome');
              },
              child: const Text(
                'Calendario',
                style: TextStyle(
                  fontSize: 14, // Making text small
                  color: Colors.blue, // Text color blue
                  decoration: TextDecoration.underline, // Underlined text
                ),
              ),
            ),
            const SizedBox(height: 20), // Add some spacing
          ],
        ),
      ),
    );
  }

  void signOutUser() {
    // Replace this function with your sign-out logic
    AuthService.signOut();
  }
}
