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
  Future<void>? _eventsFuture;

  @override
  initState() {
    super.initState();
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
      if (mounted) {
        setState(() {
          isAdmin = isAdminResult;
        });
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('An error occurred while checking admin status: $error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Mi beca',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: scholarshipStatus / 4,
              color: Colors.green[800],
              minHeight: 10.0,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/scholarshipsHome');
                initScholarshipService();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
              ),
              child: const Text('Subir archivos'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ayudas y papeles',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/helpHome');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                  ),
                  child: const Text('Mis ayudas'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/filesHome');
                    // Add your request certificate function here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                  ),
                  child: const Text('Pedir certificado'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/userHome');
                    // Add your request certificate function here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                  ),
                  child: const Text('usuario'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Test',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            //button
            ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/test');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
              ),
              child: const Text('Test'),
            ),
            const SizedBox(height: 10),
            const Spacer(),
            GestureDetector(
              onTap: () {
                // Call your sign-out function here
                signOutUser();
              },
              child: const Center(
                child: Text(
                  'Cambiar de cuenta',
                  style: TextStyle(
                    fontSize: 14, // Making text small
                    color: Colors.blue, // Text color blue
                    decoration: TextDecoration.underline, // Underlined text
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void signOutUser() {
    AuthService.signOut();
  }
}
