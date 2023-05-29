// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:http/http.dart' as http;
// import 'package:sample/control_app.dart';
// import 'package:sample/core.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// const svgImage = 'assets/images/loginSVG.svg';

// class ScreenLogin extends StatelessWidget {
//   ScreenLogin({super.key});

//   final _registerNumberController = TextEditingController();
//   final _passwordController = TextEditingController();

//   postLogin(context) async {
//     try {
//       print(_passwordController.text.toString());
//       _registerNumberController.text =
//           _registerNumberController.text.trim().toUpperCase();
//       print(_registerNumberController.text.toString());
//       var response = await http.post(
//         Uri.parse('http://$serverURL:3001/student/auth'),
//         body: {
//           "regNo": _registerNumberController.text.toString(),
//           "password": _passwordController.text.toString(),
//         },
//       );
//       final responseJson = jsonDecode(response.body);
//       if (responseJson.containsKey('message')) {
//         final message = responseJson['message'];
//         if (message == 'Invalid regNo') {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Text('wrong register number'),
//               action: SnackBarAction(
//                 label: '',
//                 onPressed: () {},
//               ),
//             ),
//           );
//         } else if (message == 'Invalid password') {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Text('wrong password'),
//               action: SnackBarAction(
//                 label: '',
//                 onPressed: () {},
//               ),
//             ),
//           );
//         }
//       } else if (responseJson.containsKey('token')) {
//         final token = responseJson['token'];
//         print(token);
//         storeToken(token);
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ControlApp()),
//         );
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: const Color(0xFF2A2A2A),
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(23.0),
//             child: ListView(children: [
//               SvgPicture.asset(
//                 svgImage,
//                 height: 200,
//                 width: 300,
//               ),
//               Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text(
//                         'Login',
//                         style: TextStyle(
//                           color: Color(0xFFDCDCE0),
//                           fontSize: 40,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         'Please sign in to continue',
//                         style: TextStyle(
//                           color: Color.fromARGB(255, 155, 151, 163),
//                           fontSize: 15,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 17,
//               ),
//               TextFormField(
//                 controller: _registerNumberController,
//                 style: const TextStyle(
//                   color: Color.fromARGB(255, 9, 9, 9),
//                 ),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: const Color(0xFFDCDCE0), // Background color
//                   labelText: 'REGISTER NUMBER',
//                   labelStyle: const TextStyle(
//                       color: Color.fromARGB(255, 66, 66, 66), fontSize: 15),
//                   prefixIcon: const Icon(
//                     Icons.directions_walk_outlined,
//                     color: Color.fromARGB(255, 66, 66, 66),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(
//                       color: Color(0xFF5D5C5C),
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(
//                       color: Color(0xFF5D5C5C), // set border color here
//                     ),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: TextFormField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   style: const TextStyle(
//                     color: Color.fromARGB(255, 0, 0, 0),
//                   ),
//                   decoration: InputDecoration(
//                       filled: true,
//                       fillColor: const Color(0xFFDCDCE0), // Background color
//                       labelText: 'PASSWORD',
//                       labelStyle: const TextStyle(
//                           color: Color.fromARGB(255, 66, 66, 66), fontSize: 15),
//                       prefixIcon: const Icon(
//                         Icons.vpn_lock_outlined,
//                         color: Color.fromARGB(255, 66, 66, 66),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(
//                           color: Color(0xFF5D5C5C),
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(
//                           color: Color(0xFF5D5C5C), // set border color here
//                         ),
//                         borderRadius: BorderRadius.circular(15),
//                       )),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   postLogin(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 24, horizontal: 100),
//                   backgroundColor: const Color(0xFFDCDCE0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(40), // Rounded corners
//                   ),
//                 ),
//                 child: const Text(
//                   'LOGIN',
//                   style: TextStyle(
//                     color: Color(0xFF424242), // Text color
//                     fontSize: 17,
//                     fontWeight: FontWeight.bold, // Text size
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               const Text('Forgot Password?',
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 159, 159, 170), // Text color
//                     fontSize: 15,
//                   )),
//               const SizedBox(
//                 height: 35,
//               ),
//             ]),
//           ),
//         ));
//   }
// }

// // Storing the token
// Future<void> storeToken(String jwt) async {
//   final token = await SharedPreferences.getInstance();
//   token.setString('jwt', jwt);
// }
