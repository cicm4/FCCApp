
// import 'package:flutter/material.dart';

// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF0b512d), // Set the background color as green
//         leading: Padding(
//           padding: const EdgeInsets.only(top: 8.0), // Lower the icon
//           child: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ),
//         title: Text(
//           "Perfil de usuario",
//           style: TextStyle(
//             fontFamily: 'Montserrat',
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF0b512d),
//                 Color(0xFFe6e6e3),
//                 Color(0xFF22c0c6),
//             ],
//           ),
//         ),
//         padding: const EdgeInsets.all(4.0), // Set a solid green background color
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: AssetImage('assets/defaultimage.jpg'),
//             ),
//             SizedBox(height: 20),
//             _buildProfileRow('assets/nameicon.png', 'Name:'),
//             SizedBox(height: 10),
//             SizedBox(height: 10),
//             _buildProfileRow('assets/emailicon.png', 'Email: emailplaceholder@gmail.com'),
//             SizedBox(height: 10),
//             _buildProfileRow('assets/idicon.png', 'Government ID: ID placeholder'),
//             SizedBox(height: 10),
//             _buildProfileRow('assets/locationicon.png', 'Location: Location placeholder'),
//             SizedBox(height: 10),
//             _buildProfileRow('assets/phoneicon.png', 'Phone: Phone placeholder'),
//             SizedBox(height: 10),
//             _buildProfileRow('assets/sporticon.png', 'Sport: Sport placeholder'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle profile editing
//               },
//               child: Text(
//                 "Editar Perfil",
//                 style: TextStyle(
//                   fontFamily: 'Montserrat',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Color(0xFF0b512d), // Set text color to green
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.white, // Set background color to white
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 side: BorderSide(color: Color(0xFF0b512d), width: 2), // Optional: add border
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileRow(String iconPath, String text) {
//     return Row(
//       children: [
//         Image.asset(
//           iconPath,
//           width: 24,
//           height: 24,
//           color: Colors.white, // Ensures the icon color matches the text color
//         ),
//         SizedBox(width: 10),
//         Text(
//           text,
//           style: TextStyle(
//             fontFamily: 'Montserrat',
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }
// }