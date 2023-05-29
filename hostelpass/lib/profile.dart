import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hostelpass/core.dart';
import 'package:http/http.dart' as http;

var _emailController = TextEditingController();
var _contactNumberController = TextEditingController();
final _oldPasswordController = TextEditingController();
final _newPasswordController = TextEditingController();

class ScreenProfile extends StatefulWidget {
  const ScreenProfile({super.key});

  @override
  State<ScreenProfile> createState() => _ScreenProfileState();
}

class _ScreenProfileState extends State<ScreenProfile> {
  Future<dynamic>? _getDataFuture;
  @override
  void initState() {
    super.initState();
    _getDataFuture = _getData();
  }

  Future<dynamic> _getData() async {
    final token = await getToken();
    if (token != null) {
      final response = await http.post(
        Uri.parse('http://$serverURL:3001/student/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {},
      );
      final rr = jsonDecode(response.body);
      print(rr);

      return jsonDecode(response.body);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        'SCREEN_LOGIN',
        (route) => false,
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<dynamic>(
      future: _getDataFuture,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F8FA),
            body: SafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 25,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final responseJson = snapshot.data;
          print(responseJson[0]['email']);
          var email;
          var studentNumber;
          String base64String =
              responseJson[0]['reducedImageBASE64'].split(',')[1];

          if (responseJson[0]['email'] != null) {
            email = responseJson[0]['email'] as String;
          } else {
            email = " ";
          }
          if (responseJson[0]['studentNumber'] != null) {
            studentNumber = responseJson[0]['studentNumber'];
          } else {
            studentNumber = " ";
          }
          if (responseJson[0]['roomNo'] != null &&
              responseJson[0].containsValue('roomNo')) {
            studentNumber = responseJson[0]['studentNumber'];
          } else {
            studentNumber = "No Hostel room found";
          }
          print(email);

          return Scaffold(
            backgroundColor: const Color(0xFFF7F8FA),
            body: SafeArea(
              child: ListView(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 40,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  size: 25,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Center(
                            child: ProfileImage(image64: base64String),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Center(
                    child: Text(
                      '${responseJson[0]['firstName']} ${responseJson[0]['lastName']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Department of ',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                        Text(getDiscipline(responseJson[0]['department']),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  //basic details
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDFDFD),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: screenWidth,
                      height: screenHeight * 0.2,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 13,
                              left: 13,
                              right: 13,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Register number",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    // fontFamily: 'Inter',
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  responseJson[0]['regNo'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 13),
                            child: Divider(
                              color: Colors.grey.withOpacity(0.4),
                              thickness: 1.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 13,
                              right: 13,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Semester",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    // fontFamily: 'Inter',
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  responseJson[0]['classRoom'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 13),
                            child: Divider(
                              color: Colors.grey.withOpacity(0.4),
                              thickness: 1.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 13,
                              right: 13,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Batch",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    // fontFamily: 'Inter',
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  formatYearRange(responseJson[0]['year']),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  //edit detials
                  InkWell(
                    onTap: () {
                      // Add your button action here
                      editDetails(
                        context,
                        screenWidth,
                        screenHeight,
                        email,
                        studentNumber,
                      );
                      print('Button tapped!');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Ink(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          color: const Color(0xFFFDFDFD),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          width: screenWidth,
                          height: screenHeight * 0.09,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: Colors.pink,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    const Text('Edit Details'),
                                  ],
                                ),
                                const Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  //Change passowrd
                  InkWell(
                    onTap: () {
                      changePassword(
                        context,
                        screenWidth,
                        screenHeight,
                      );
                      print('Button tapped!');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Ink(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          color: const Color(0xFFFDFDFD),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          width: screenWidth,
                          height: screenHeight * 0.09,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 253, 134, 7),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.vpn_lock_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    const Text('Change password'),
                                  ],
                                ),
                                const Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  //Gneder,email,conatct numbers
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDFDFD),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: screenWidth,
                      height: screenHeight * 0.26,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 13,
                              left: 13,
                              right: 13,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Gender",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    // fontFamily: 'Inter',
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  responseJson[0]['gender'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 13),
                            child: Divider(
                              color: Colors.grey.withOpacity(0.4),
                              thickness: 1.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 13,
                              right: 13,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Email:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    // fontFamily: 'Inter',
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  email,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 13),
                            child: Divider(
                              color: Colors.grey.withOpacity(0.4),
                              thickness: 1.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 13,
                              right: 13,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Contact number",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    // fontFamily: 'Inter',
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  studentNumber,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 13),
                            child: Divider(
                              color: Colors.grey.withOpacity(0.4),
                              thickness: 1.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 13,
                              right: 13,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Parents number",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    // fontFamily: 'Inter',
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  responseJson[0]['parentsNumber'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //hostel
                  if (studentNumber == "No Hostel room found")
                    HostelCard(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      room: studentNumber,
                    ),

                  const SizedBox(
                    height: 6,
                  ),
                  const Center(
                    child: Text(
                      'ERANAD KNOWLEDGE CITY',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'TECHNICAL CAMPUS',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class HostelCard extends StatelessWidget {
  const HostelCard({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.room,
  });

  final double screenWidth;
  final double screenHeight;
  final String room;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFDFDFD),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          width: screenWidth,
          height: screenHeight * 0.15,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 13,
              left: 13,
              right: 13,
            ),
            child: Column(
              children: [
                const Text(
                  'Hostel',
                  style: TextStyle(
                    color: Color.fromARGB(255, 84, 83, 83),
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Divider(
                    color: Colors.grey.withOpacity(0.4),
                    thickness: 1.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Room number",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        // fontFamily: 'Inter',
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      room,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

class ProfileImage extends StatelessWidget {
  final String image64;
  const ProfileImage({
    super.key,
    required this.image64,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Image.memory(
            base64Decode(image64),
            width: 120.0,
            height: 120.0,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 196, 124, 148),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.black,
                size: 16.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String getDiscipline(String argument) {
  if (argument == 'CSE') {
    return 'Computer Science and Engineering';
  } else if (argument == 'ME') {
    return 'Mechanical Engineering';
  } else if (argument == 'CE') {
    return 'Civil Engineering';
  } else if (argument == 'SFE') {
    return 'Fire and Safety Engineering';
  } else if (argument == 'EE') {
    return 'Electrical and Electronics Engineering';
  } else {
    return 'Unknown Department';
  }
}

String formatYearRange(String yearString) {
  int year = int.parse(yearString);
  int startYear = year - 4;
  return '$startYear-$year';
}

class PopupPage extends StatelessWidget {
  const PopupPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Contact Number',
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update button logic here
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}

Future changePassword(context, screenWidth, screenHeight) =>
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      builder: (BuildContext context) {
        return ListView(
          children: [
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Update',
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 159, 158, 158)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Old Password',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: _oldPasswordController,
                          decoration: const InputDecoration(
                            hintText: 'ABSBJS6DWND',
                            hintStyle: TextStyle(
                              fontFamily: 'SourceCodePro',
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'New Password',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: _newPasswordController,
                          decoration: const InputDecoration(
                            hintText: '!@#EWQDFCVJD',
                            hintStyle: TextStyle(
                              fontFamily: 'SourceCodePro',
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: screenWidth * 0.50,
                          height: screenHeight * 0.065,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                              ),
                              side: MaterialStateProperty.all(
                                const BorderSide(width: 2, color: Colors.black),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 255, 255, 255),
                              ),
                              foregroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 249, 248, 248),
                              ),
                            ),
                            onPressed: () async {
                              print(_oldPasswordController.text);
                              print(_newPasswordController.text);
                              final token = await getToken();
                              if (token != null) {
                                final response = await http.post(
                                  Uri.parse(
                                      'http://$serverURL:3001/student/profile/changePassword'),
                                  headers: {
                                    'Authorization': 'Bearer $token',
                                  },
                                  body: {
                                    "currentPassword":
                                        _oldPasswordController.text.toString(),
                                    "newPassword":
                                        _newPasswordController.text.toString()
                                  },
                                );
                                final responseJSON = jsonDecode(response.body);
                                if (responseJSON.containsKey('status')) {
                                  if (responseJSON['status'] == "ok") {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                            'Password changed successfully 😊'),
                                        action: SnackBarAction(
                                          label: '',
                                          onPressed: () {},
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('try again 🤷‍♂️'),
                                        action: SnackBarAction(
                                          label: '',
                                          onPressed: () {},
                                        ),
                                      ),
                                    );
                                  }
                                } else if (responseJSON
                                    .containsKey('message')) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(responseJSON['message']),
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
                                  (route) => false,
                                );
                              }
                            },
                            child: const Text(
                              'Change Password',
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );

// Center(

Future editDetails(context, screenWidth, screenHeight, email, contactNumber) =>
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      builder: (BuildContext context) {
        // _contactNumberController.text = contactNumber;
        // _emailController.text = email;
        return ListView(
          children: [
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Update',
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 159, 158, 158)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'example@gmail.com',
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contact Number',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        TextFormField(
                          controller: _contactNumberController,
                          decoration: const InputDecoration(
                            hintText: '9087654321',
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: screenWidth * 0.50,
                          height: screenHeight * 0.065,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                              ),
                              side: MaterialStateProperty.all(
                                const BorderSide(width: 2, color: Colors.black),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 255, 255, 255),
                              ),
                              foregroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 249, 248, 248),
                              ),
                            ),
                            onPressed: () async {
                              if (_emailController.text.isEmpty) {
                                _emailController.text = email;
                              }
                              if (_contactNumberController.text.isEmpty) {
                                _contactNumberController.text = contactNumber;
                              }
                              print(_contactNumberController.text);
                              print(_emailController.text);
                              final token = await getToken();
                              if (token != null) {
                                final response = await http.post(
                                  Uri.parse(
                                      'http://$serverURL:3001/student/profile/update'),
                                  headers: {
                                    'Authorization': 'Bearer $token',
                                  },
                                  body: {
                                    "email": _emailController.text.toString(),
                                    "studentNumber":
                                        _contactNumberController.text.toString()
                                  },
                                );
                                final responseJSON = jsonDecode(response.body);
                                print(responseJSON);
                                if (responseJSON.containsKey('status')) {
                                  if (responseJSON['status'] == "ok") {
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ScreenProfile(),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                            'Details updated seccesfully 🤗'),
                                        action: SnackBarAction(
                                          label: '',
                                          onPressed: () {},
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Try again 😒'),
                                        action: SnackBarAction(
                                          label: '',
                                          onPressed: () {},
                                        ),
                                      ),
                                    );
                                  }
                                } else if (responseJSON
                                    .containsKey('message')) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(responseJSON['message']),
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
                                  (route) => false,
                                );
                              }
                            },
                            child: const Text(
                              'Update',
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );

// Center(
//               child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text('data'))),
//         );
