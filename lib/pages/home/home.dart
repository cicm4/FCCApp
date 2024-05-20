import 'package:fccapp/pages/home/help_papers_section.dart';
import 'package:fccapp/pages/home/logout_button.dart';
import 'package:fccapp/pages/home/profile_button.dart';
import 'package:fccapp/pages/home/scholarship_section.dart';
import 'package:fccapp/pages/home/test_section.dart';
import 'package:flutter/material.dart';
import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/level_2/scholarships_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';

class Home extends StatefulWidget {
  final DBService dbs;
  const Home({super.key, required this.dbs});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScholarshipService scholarshipService;
  num scholarshipStatus = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initScholarshipService();
  }

  Future<void> initScholarshipService() async {
    scholarshipService = await ScholarshipService.create(
        userService: UserService(), dbService: widget.dbs);
    scholarshipStatus = scholarshipService.getStatusNum();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final fontSizeAdaptive = MediaQuery.of(context).size.width * 0.07;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(0, 137, 123, 1),
              Color.fromRGBO(129, 199, 132, 1),
              Color.fromRGBO(29, 233, 182, 1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const ProfileButton(),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    "Inicio",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: fontSizeAdaptive,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: index < scholarshipStatus
                              ? Colors.green.shade700
                              : Colors.grey.shade800,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: bottomInset),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    height: MediaQuery.of(context).size.height * 0.6, // Adjusted height
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(height: 30), // Increased space to lower the section
                          ScholarshipSection(dbs: widget.dbs, scholarshipService: scholarshipService),
                          const HelpPapersSection(),
                          const TestSection(),
                          const Spacer(),
                          const LogoutButton(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
