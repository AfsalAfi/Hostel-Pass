import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hostelpass/core.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ScreenQrForm extends StatefulWidget {
  const ScreenQrForm({super.key});

  @override
  State<ScreenQrForm> createState() => _ScreenQrFormState();
}

class _ScreenQrFormState extends State<ScreenQrForm> {
  TextEditingController startDayController = TextEditingController();
  TextEditingController endDayController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  // var _endDayController = "Pick Days";
  // var _startDayController = "Pick Days";
  // final _endDayController = TextEditingController();

  postRequest(context) async {
    try {
      print(startDayController.text.toString());
      print(endDayController.text.toString());
      print(startTimeController.text.toString());
      print(endTimeController.text.toString());
      print(locationController.text.toString());
      print(reasonController.text.toString());

      final token = await getToken();
      if (token != null) {
        var response = await http.post(
          Uri.parse(
              'http://$serverURL:3001/student/hostel/hostel-request-my-leave'),
          headers: {
            'Authorization': 'Bearer $token',
          },
          body: {
            "checkOut": startTimeController.text.toString(),
            "checkIn": endTimeController.text.toString(),
            "reason": reasonController.text.toString(),
            "location": locationController.text.toString(),
            "startingDay": startDayController.text.toString(),
            "endingDay": endDayController.text.toString(),
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
                  'Your Hostel request failed try after Sometime...😁'),
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

  // TimeOfDay _timeOfCheckOUT = const TimeOfDay(hour: 10, minute: 30);
  // TimeOfDay _timeOfCheckIN = const TimeOfDay(hour: 11, minute: 30);

  // void _showTimePickerCheckIN() {
  //   showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   ).then((value) {
  //     setState(() {
  //       _timeOfCheckIN = value!;
  //     });
  //   });
  // }

  // void _showTimePickerCheckOUT() {
  //   showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   ).then((value) {
  //     setState(() {
  //       _timeOfCheckOUT = value!;
  //     });
  //   });
  // }

  void _showTimePickerCheckOUT() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          startTimeController.text = value.format(context);
          print(startTimeController);
        });
      }
    });
  }

  void _showTimePickerCheckIN() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          endTimeController.text = value.format(context);
          print(endTimeController);
        });
      }
    });
  }

  void _showDayPickerCheckOUT() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    ).then((value) {
      if (value != null) {
        setState(() {
          startDayController.text = DateFormat('yyyy-MM-dd').format(value);
          print(startDayController);
        });
      }
    });
  }

  void _showDayPickerCheckIN() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    ).then((value) {
      if (value != null) {
        setState(() {
          endDayController.text = DateFormat('yyyy-MM-dd').format(value);
          print(endDayController);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHieght = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
                child: Container(
                  color: Colors.black,
                  width: screenWidth,
                  height: screenHieght * 0.33,
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    'assets/images/college-img.png',
                    width: screenWidth,
                    height: screenHieght * 0.33,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: ListView(
              children: [
                SizedBox(
                  height: screenHieght * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        leading: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 25,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        title: const Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            'Hostel Pass Request',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Inter',
                              fontSize: 23,
                            ),
                          ),
                        ),
                        centerTitle: true,
                      ),
                      Center(
                        child: Container(
                          width: screenWidth * 0.9,
                          height: screenHieght * 0.68,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Check out Day',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      // color: Colors.amber,
                                      child: TextField(
                                        controller: startDayController,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Montserrat',
                                        ),
                                        decoration: const InputDecoration(
                                          icon:
                                              Icon(Icons.edit_calendar_rounded),
                                          labelText: '',
                                        ),
                                        onTap: () {
                                          _showDayPickerCheckOUT();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Check In Day',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      // color: Colors.amber,
                                      child: TextField(
                                        controller: endDayController,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Montserrat',
                                        ),
                                        decoration: const InputDecoration(
                                          icon:
                                              Icon(Icons.edit_calendar_rounded),
                                          labelText: '',
                                        ),
                                        onTap: () {
                                          _showDayPickerCheckIN();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Check out Time',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      // color: Colors.amber,
                                      child: TextField(
                                        controller: startTimeController,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Montserrat',
                                        ),
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.timelapse_sharp),
                                          labelText: '',
                                        ),
                                        onTap: () {
                                          _showTimePickerCheckOUT();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Check in Time',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: TextField(
                                        controller: endTimeController,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Montserrat',
                                        ),
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.timer_off_outlined),
                                          labelText: '',
                                        ),
                                        onTap: () {
                                          _showTimePickerCheckIN();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Place to visit',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: TextField(
                                        controller: locationController,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Montserrat',
                                        ),
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.place_outlined),
                                          labelText: '',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Reason',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: TextField(
                                        controller: reasonController,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Montserrat',
                                        ),
                                        decoration: const InputDecoration(
                                          icon:
                                              Icon(Icons.new_releases_outlined),
                                          labelText: '',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     const Text(
                                //       'Place to visit',
                                //       style: TextStyle(
                                //         fontSize: 12.5,
                                //         fontFamily: 'Inter',
                                //         fontWeight: FontWeight.w700,
                                //         color: Colors.black,
                                //       ),
                                //     ),
                                //     TextFormField(
                                //       controller: locationController,
                                //       style: const TextStyle(
                                //         color: Colors.black,
                                //         fontSize: 15,
                                //         fontWeight: FontWeight.w500,
                                //         fontFamily: 'Montserrat',
                                //       ),
                                //       decoration: const InputDecoration(
                                //         hintText: 'Manjeri',
                                //         hintStyle: TextStyle(
                                //           fontFamily: 'SourceCodePro',
                                //         ),
                                //         prefixIcon: Icon(
                                //           Icons.place_rounded,
                                //         ),
                                //         border: UnderlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.black),
                                //         ),
                                //         focusedBorder: UnderlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.grey),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     const Text(
                                //       'Reason',
                                //       style: TextStyle(
                                //         fontSize: 12.5,
                                //         fontFamily: 'Inter',
                                //         fontWeight: FontWeight.w700,
                                //         color: Colors.black,
                                //       ),
                                //     ),
                                //     TextFormField(
                                //       controller: reasonController,
                                //       style: const TextStyle(
                                //         color: Colors.black,
                                //         fontSize: 15,
                                //         fontWeight: FontWeight.w500,
                                //         fontFamily: 'Montserrat',
                                //       ),
                                //       decoration: const InputDecoration(
                                //         hintText: 'Going to buy food',
                                //         hintStyle: TextStyle(
                                //           fontFamily: 'SourceCodePro',
                                //         ),
                                //         prefixIcon: Icon(
                                //           Icons.new_releases_rounded,
                                //         ),
                                //         border: UnderlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.black),
                                //         ),
                                //         focusedBorder: UnderlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.grey),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     const Text(
                                //       'Check In Day',
                                //       style: TextStyle(
                                //         fontSize: 12.5,
                                //         fontFamily: 'Inter',
                                //         fontWeight: FontWeight.w700,
                                //         color: Colors.black,
                                //       ),
                                //     ),
                                //     TextFormField(
                                //       onTap: _showTimePickerCheckIN,
                                //       readOnly: true,
                                //       decoration: InputDecoration(
                                //         hintText: _timeOfCheckIN
                                //             .format(context)
                                //             .toString(),
                                //         hintStyle: const TextStyle(
                                //           fontFamily: 'SourceCodePro',
                                //         ),
                                //         border: const UnderlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.black),
                                //         ),
                                //         focusedBorder:
                                //             const UnderlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.grey),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     const Text(
                                //       'Check Out Time',
                                //       style: TextStyle(
                                //         fontSize: 12.5,
                                //         fontFamily: 'Inter',
                                //         fontWeight: FontWeight.w700,
                                //         color: Colors.black,
                                //       ),
                                //     ),
                                //     TextFormField(
                                //       onTap: _showTimePickerCheckOUT,
                                //       readOnly: true,
                                //       decoration: InputDecoration(
                                //         hintText: _timeOfCheckOUT
                                //             .format(context)
                                //             .toString(),
                                //         hintStyle: const TextStyle(
                                //           fontFamily: 'SourceCodePro',
                                //         ),
                                //         border: const UnderlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.black),
                                //         ),
                                //         focusedBorder:
                                //             const UnderlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.grey),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     const Text(
                                //       'Check In Time',
                                //       style: TextStyle(
                                //         fontSize: 12.5,
                                //         fontFamily: 'Inter',
                                //         fontWeight: FontWeight.w700,
                                //         color: Colors.black,
                                //       ),
                                //     ),
                                //     TextFormField(
                                //       onTap: _showTimePickerCheckIN,
                                //       readOnly: true,
                                //       decoration: InputDecoration(
                                //         hintText: _timeOfCheckIN
                                //             .format(context)
                                //             .toString(),
                                //         hintStyle: const TextStyle(
                                //           fontFamily: 'SourceCodePro',
                                //         ),
                                //         border: const UnderlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.black),
                                //         ),
                                //         focusedBorder:
                                //             const UnderlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.grey),
                                //         ),
                                //       ),
                                //     ),
                                //     // const Text(
                                //     //   'Check In Time',
                                //     //   style: TextStyle(
                                //     //     fontSize: 12.5,
                                //     //     fontFamily: 'Inter',
                                //     //     fontWeight: FontWeight.w700,
                                //     //     color: Colors.black,
                                //     //   ),
                                //     // ),
                                //     // TextFormField(
                                //     //   controller: _checkInController,
                                //     //   decoration: const InputDecoration(
                                //     //     hintText: '1:30 PM',
                                //     //     hintStyle: TextStyle(
                                //     //       fontFamily: 'SourceCodePro',
                                //     //     ),
                                //     //     border: UnderlineInputBorder(
                                //     //       borderSide:
                                //     //           BorderSide(color: Colors.black),
                                //     //     ),
                                //     //     focusedBorder: UnderlineInputBorder(
                                //     //       borderSide:
                                //     //           BorderSide(color: Colors.grey),
                                //     //     ),
                                //     //   ),
                                //     // ),
                                //   ],
                                // ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     const Text(
                                //       'Place to visit',
                                //       style: TextStyle(
                                //         fontSize: 12.5,
                                //         fontFamily: 'Inter',
                                //         fontWeight: FontWeight.w700,
                                //         color: Colors.black,
                                //       ),
                                //     ),
                                //     TextFormField(
                                //       controller: locationController,
                                //       decoration: const InputDecoration(
                                //         hintText: 'Manjeri',
                                //         hintStyle: TextStyle(
                                //           fontFamily: 'SourceCodePro',
                                //         ),
                                //         border: UnderlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.black),
                                //         ),
                                //         focusedBorder: UnderlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.grey),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     const Text(
                                //       'Reason',
                                //       style: TextStyle(
                                //         fontSize: 12.5,
                                //         fontFamily: 'Inter',
                                //         fontWeight: FontWeight.w700,
                                //         color: Colors.black,
                                //       ),
                                //     ),
                                //     TextFormField(
                                //       controller: reasonController,
                                //       decoration: const InputDecoration(
                                //         hintText: 'Going to buy food',
                                //         hintStyle: TextStyle(
                                //           fontFamily: 'SourceCodePro',
                                //         ),
                                //         border: UnderlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.black),
                                //         ),
                                //         focusedBorder: UnderlineInputBorder(
                                //           borderSide:
                                //               BorderSide(color: Colors.grey),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),

                                Center(
                                  child: SizedBox(
                                    width: screenWidth * 0.50,
                                    height: screenHieght * 0.065,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        side: MaterialStateProperty.all(
                                          const BorderSide(
                                              width: 1, color: Colors.black),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          const Color.fromARGB(
                                              255, 232, 229, 229),
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                          const Color.fromARGB(
                                              255, 210, 38, 38),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (locationController
                                                .text.isNotEmpty &&
                                            reasonController.text.isNotEmpty) {
                                          postRequest(context);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  const Text('Fill all feilds'),
                                              action: SnackBarAction(
                                                label: '',
                                                onPressed: () {},
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'Request',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
