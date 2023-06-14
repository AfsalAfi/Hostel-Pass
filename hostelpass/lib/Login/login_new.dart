import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hostelpass/control_app.dart';
import 'package:hostelpass/core.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const svgImage = 'assets/images/loginSVG.svg';

class ScreenLogin extends StatelessWidget {
  ScreenLogin({super.key});

  final _registerNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  postLogin(context) async {
    try {
      print(_passwordController.text.toString());
      _registerNumberController.text =
          _registerNumberController.text.trim().toUpperCase();
      print(_registerNumberController.text.toString());
      var response = await http.post(
        Uri.parse('http://$serverURL:3001/student/auth'),
        body: {
          "regNo": _registerNumberController.text.toString(),
          "password": _passwordController.text.toString(),
        },
      );
      final responseJson = jsonDecode(response.body);
      if (responseJson.containsKey('message')) {
        final message = responseJson['message'];
        if (message == 'Invalid regNo') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('wrong register number'),
              action: SnackBarAction(
                label: '',
                onPressed: () {},
              ),
            ),
          );
        } else if (message == 'Invalid password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('wrong password'),
              action: SnackBarAction(
                label: '',
                onPressed: () {},
              ),
            ),
          );
        }
      } else if (responseJson.containsKey('token')) {
        final token = responseJson['token'];
        print(token);
        storeToken(token);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ControlApp()),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: screenHeight * 0.6,
            // color: Colors.amber,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/ekclogo.png',
                  width: 105,
                  height: 85,
                  fit: BoxFit.contain,
                ),
                Column(
                  children: const [
                    Text(
                      'Hello!',
                      style: TextStyle(
                        color: Color.fromARGB(255, 45, 45, 45),
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      'Login with your regsiter number',
                      style: TextStyle(
                        color: Color.fromARGB(255, 95, 95, 95),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Mulish',
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: SizedBox(
                        child: TextFormField(
                          controller: _registerNumberController,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 9, 9, 9),
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor:
                                const Color(0xFFFAFAFA), // Background color
                            labelText: 'Register Number',
                            labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 42, 42, 43),
                                fontSize: 15),
                            prefixIcon: const Icon(
                              Icons.ac_unit_sharp,
                              color: Color.fromARGB(255, 42, 42, 43),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFF5D5C5C),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color:
                                    Color(0xFF5D5C5C), // set border color here
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: SizedBox(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    const Color(0xFFFAFAFA), // Background color
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 42, 42, 43),
                                    fontSize: 15),
                                prefixIcon: const Icon(
                                  Icons.vpn_lock_outlined,
                                  color: Color.fromARGB(255, 42, 42, 43),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFF5D5C5C),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(
                                        0xFF5D5C5C), // set border color here
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'By logging in you are agree to ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 33, 33, 33),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                            fontSize: 14),
                      ),
                      TextSpan(
                        text: 'T&C',
                        style: TextStyle(
                            color: Color.fromARGB(255, 108, 4, 199),
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: ElevatedButton(
                    onPressed: () {
                      postLogin(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Set the desired border radius here
                      ),
                      backgroundColor: const Color.fromARGB(255, 108, 4, 199),
                      minimumSize: Size(screenWidth,
                          55.0), // Set the desired background color here
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          color: Color.fromARGB(255, 204, 204, 204),
                          fontWeight: FontWeight.w700,
                          fontSize: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Storing the token
Future<void> storeToken(String jwt) async {
  final token = await SharedPreferences.getInstance();
  token.setString('jwt', jwt);
}
