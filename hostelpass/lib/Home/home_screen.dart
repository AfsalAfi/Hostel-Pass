import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:hostelpass/GatePass/QrCodeGeneration/qr_page_new.dart';
import 'package:hostelpass/core.dart';
import 'package:http/http.dart' as http;

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
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
        Uri.parse('http://$serverURL:3001/student/hostel'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {},
      );
      final rr = jsonDecode(response.body);
      print(rr);

      return jsonDecode(response.body);
    } else {
      // Navigator.of(context).pushNamed('SCREEN_LOGIN');
      return null;
    }
  }

  Widget loadImageFromBase64(String base64String) {
    Uint8List bytes = base64Decode(base64String);
    return Image.memory(bytes);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHieght = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: FutureBuilder<dynamic>(
        future: _getDataFuture,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final responseJson = snapshot.data;
            String base64String =
                responseJson[0]['reducedImageBASE64'].split(',')[1];
            Map<String, dynamic>? hostelPasses;
            for (var obj in responseJson[0]['hostelPasses']) {
              if (obj.isNotEmpty) {
                hostelPasses = obj;
                break;
              } else {
                hostelPasses = {};
              }
            }
            print(hostelPasses?['status']);
            // final activeGatePass = responseJson[0]['gatePasses'][0];
            return SafeArea(
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 13, top: 13, right: 13),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Good Morning',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 16, 16, 16),
                              ),
                            ),
                            Text(
                              responseJson[0]['firstName'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w900,
                                color: Color.fromARGB(255, 16, 16, 16),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0,
                                        3), // changes the position of the shadow
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.memory(
                                  base64Decode(base64String),
                                  height: 55,
                                  width: 55,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // color: Colors.amberAccent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Simplify your student journey,',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 117, 115, 115),
                            ),
                          ),
                          Text(
                            'Everything thing you need at your fingertips',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 117, 115, 115),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 13, right: 2),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Hostel pass',
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 16, 16, 16),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('SCREEN_GATEPASS_HISTORY');
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'MY HISTORY',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange,
                                  ),
                                ),
                                SizedBox(
                                  width: 1,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 10,
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (hostelPasses?['status'] == 'Pending' ||
                      hostelPasses?['status'] == 'Tutor permission required' &&
                          hostelPasses?['key'] == null)
                    GatePassHomeCARD(
                      screenHieght: screenHieght,
                      status: "Pending",
                      checkOut: hostelPasses?['checkOut'],
                      checkIn: hostelPasses?['checkIn'],
                    )
                  else if (hostelPasses?['status'] == 'Approved' &&
                      hostelPasses?['key'] != null)
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScreenQRPage(
                                qrDataK: responseJson[0]['hostelPasses']),
                          ),
                        );
                      },
                      child: GatePassHomeCARD(
                        screenHieght: screenHieght,
                        status: hostelPasses?['status'],
                        checkOut: hostelPasses?['checkOut'],
                        checkIn: hostelPasses?['checkIn'],
                      ),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed('SCREEN_GATEPASS_REQUEST');
                      },
                      child: GatePassRequest(screenHieght: screenHieght),
                    ),
                  // activeGatePass.isEmpty
                  //     ? TextButton(
                  //         onPressed: () {
                  //           Navigator.of(context)
                  //               .pushNamed('SCREEN_GATEPASS_REQUEST');
                  //         },
                  //         child: GatePassRequest(screenHieght: screenHieght),
                  //       )
                  //     : GatePassHomeCARD(screenHieght: screenHieght),
                  // const SizedBox(
                  //   height: 28,
                  // ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  const Padding(
                    padding: EdgeInsets.only(left: 13, top: 15, right: 13),
                    child: Text(
                      'Food management',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 5, 5, 5),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 13, right: 13, top: 8),
                    child: Container(
                      width: double.infinity,
                      height: screenHieght * 0.17,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Good food is the foundation of genuine happiness.',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Order from',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Mulish',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 5, 5, 5),
                                      ),
                                    ),
                                    Text(
                                      '8:10 AM',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'Mulish',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 5, 5, 5),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 150,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF5D5C5C),
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 36.5,
                                          height: 36.5,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFFFFF),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Icon(
                                            FontAwesomeIcons.mendeley,
                                            size: 22,
                                            color: Color.fromARGB(
                                                255, 110, 110, 110),
                                          ),
                                        ),
                                        Row(
                                          children: const [
                                            Text(
                                              'Coming Soon',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Mulish',
                                                fontWeight: FontWeight.w900,
                                                color: Color.fromARGB(
                                                    255, 199, 199, 199),
                                              ),
                                            ),
                                            Icon(
                                              Icons.double_arrow,
                                              size: 14,
                                              color: Color.fromARGB(
                                                  255, 199, 199, 199),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 13, top: 15, right: 13),
                    child: Text(
                      'Complaints',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 5, 5, 5),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 13, right: 13, top: 8),
                    child: Container(
                      width: double.infinity,
                      height: screenHieght * 0.17,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Issue your complaints',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 1, 1, 1),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              // width: double.infinity,
                              child: TextFormField(
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(255, 201, 199, 199),
                                  // Background color
                                  hintText: 'Text here..',
                                  hintStyle: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 15),
                                  prefixIcon: const Icon(
                                    Icons.note_alt_outlined,
                                    size: 24,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF5D5C5C),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 255, 255,
                                          255), // set border color here
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class GatePassRequest extends StatelessWidget {
  const GatePassRequest({
    super.key,
    required this.screenHieght,
  });

  final double screenHieght;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        height: screenHieght * 0.18,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 96, 96, 96).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Icon(Icons.add, size: 70, color: Color(0xFFFAFAFA)),
      ),
    );
  }
}

class GatePassHomeCARD extends StatelessWidget {
  const GatePassHomeCARD({
    super.key,
    required this.screenHieght,
    required this.status,
    required this.checkOut,
    required this.checkIn,
  });

  final double screenHieght;
  final String status;
  final String checkOut;
  final String checkIn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Container(
        width: double.infinity,
        height: screenHieght * 0.21,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.transparent,
                height: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 25,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF464646),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Hostel Pass ',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 249, 249, 249),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Mulish',
                                          fontSize: 14),
                                    ),
                                    TextSpan(
                                      text: status.toUpperCase(),
                                      style: const TextStyle(
                                          color: Color(0xFFA7C93F),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Approved by',
                            style: TextStyle(
                              color: Color.fromRGBO(4, 4, 4, 0.882),
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Department of CSE',
                            style: TextStyle(
                              color: Color.fromARGB(255, 5, 5, 5),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'FROM',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 5, 5, 5),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Mulish',
                                  fontSize: 9,
                                ),
                              ),
                              Text(
                                checkOut.toUpperCase(),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 5, 5, 5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 13.5,
                            color: Colors.grey,
                          ),
                          const Icon(
                            Icons.directions_walk,
                            size: 25,
                            color: Color.fromARGB(255, 120, 120, 120),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 13.5,
                            color: Colors.grey,
                          ),
                          Column(
                            children: [
                              const Text(
                                'TO',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 5, 5, 5),
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              ),
                              Text(
                                checkIn.toUpperCase(),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 5, 5, 5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
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
            const VerticalDivider(
              color: Colors.grey,
              thickness: 1,
              // width: 20,
              indent: 10,
              endIndent: 10,
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Image.asset(
                  'assets/images/ekc-logo.webp',
                  width: double.infinity,
                  height: double.infinity,
                  // height: 80,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color getStatusColor(status) {
  if (status == "Approved") {
    return Colors.green;
  } else if (status == "Rejected") {
    return Colors.red;
  } else if (status == "Pending") {
    return Colors.orange;
  } else {
    return Colors.yellow;
  }
}
