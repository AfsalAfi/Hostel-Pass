import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hostelpass/core.dart';
import 'package:http/http.dart' as http;

class ScreenQrRequest extends StatelessWidget {
  ScreenQrRequest({super.key});
  final _checkOutController = TextEditingController();
  final _checkInController = TextEditingController();
  final _locationController = TextEditingController();
  final _reasonController = TextEditingController();

  postRequest(context) async {
    try {
      print(_checkOutController.text.toString());
      print(_checkInController.text.toString());
      print(_locationController.text.toString());
      print(_reasonController.text.toString());

      final token = await getToken();
      if (token != null) {
        var response = await http.post(
          Uri.parse('http://$serverURL:3001/student/gatePass/get-my-pass'),
          headers: {
            'Authorization': 'Bearer $token',
          },
          body: {
            "checkOut": _checkOutController.text.toString(),
            "checkIn": _checkInController.text.toString(),
            "reason": _locationController.text.toString(),
            "location": _reasonController.text.toString(),
          },
        );
        final responseJson = jsonDecode(response.body);
        print(responseJson);
        if (responseJson["status"] == "ok") {
          Navigator.of(context).pushNamedAndRemoveUntil(
            'SCREEN_CONTROL',
            (Route<dynamic> route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Request Sended 👍'),
              action: SnackBarAction(
                label: '',
                onPressed: () {},
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'Your GatePass request failed try after Sometime...😁'),
              action: SnackBarAction(
                label: '',
                onPressed: () {},
              ),
            ),
          );
        }
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          'SCREEN_LOGIN',
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHieght = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Text(
            'Gate Pass Request',
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Center(
          child: Container(
            width: screenWidth * 0.85,
            height: screenHieght * 0.85,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListView(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          'assets/images/ekc-logo.webp',
                          width: screenWidth * 0.85,
                          height: screenHieght * 0.85,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Text(
                              'APR 18',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 15,
                        // ),
                        TextFormField(
                          controller: _checkOutController,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent, // Background color
                              labelText: 'CHECK OUT TIME',
                              labelStyle: const TextStyle(
                                  color: Color(0xFF334463), fontSize: 15),
                              prefixIcon: const Icon(
                                Icons.directions_walk_outlined,
                                color: Color(0xFF334463),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 0),
                                borderRadius: BorderRadius.circular(15),
                              )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _checkInController,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent, // Background color
                              labelText: 'CHECK IN TIME',
                              labelStyle: const TextStyle(
                                  color: Color(0xFF334463), fontSize: 15),
                              prefixIcon: const Icon(
                                Icons.wheelchair_pickup_outlined,
                                color: Color(0xFF334463),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 0),
                                borderRadius: BorderRadius.circular(15),
                              )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _locationController,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent, // Background color
                              labelText: 'LOCATION',
                              labelStyle: const TextStyle(
                                  color: Color(0xFF334463), fontSize: 15),
                              prefixIcon: const Icon(
                                Icons.place_outlined,
                                color: Color(0xFF334463),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 0),
                                borderRadius: BorderRadius.circular(15),
                              )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          maxLines: 5,
                          maxLength: 200,
                          controller: _reasonController,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent, // Background color
                              labelText: 'REASON',
                              labelStyle: const TextStyle(
                                  color: Color(0xFF334463), fontSize: 15),
                              prefixIcon: const Icon(
                                Icons.wysiwyg_sharp,
                                color: Color(0xFF334463),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 0),
                                borderRadius: BorderRadius.circular(15),
                              )),
                        ),
                        SizedBox(
                          height: 50,
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              postRequest(context);
                            },
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 89, 216, 4),
                              ),
                            ),
                            child: const Text(
                              'Request',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
