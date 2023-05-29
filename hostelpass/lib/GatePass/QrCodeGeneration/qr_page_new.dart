import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hostelpass/core.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ScreenQRPage extends StatelessWidget {
  final List<dynamic> qrDataK;
  const ScreenQRPage({
    super.key,
    required this.qrDataK,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? approvedData = qrDataK.firstWhere(
      (element) => element['status'] == 'Approved',
      orElse: () => null,
    );

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
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: screenHieght * 0.8,
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
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    'SCREEN_CONTROL', (route) => false);
                              },
                            ),
                            title: const Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Text(
                                "Gate Pass",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Inter',
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            centerTitle: true,
                          ),
                          QrCard(
                            screenWidth: screenWidth,
                            screenHieght: screenHieght,
                            checkOut: approvedData?['checkOut'],
                            checkIn: approvedData?['checkIn'],
                            startingDay: approvedData?['startingDay'],
                            endingDay: approvedData?['endingDay'],
                            reason: approvedData?['reason'],
                            location: approvedData?['location'],
                            qrKey: approvedData?['key'],
                            status: approvedData?['status'],
                            currentDate: approvedData?['currentDate'],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 35.0),
                            child: Text(
                              'Disclaimer: "Students are advised to prioritize their safety when leaving campus, following local laws and taking necessary precautions. The institution holds no liability for any incidents that may occur outside the campus premises."',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  color: Color(0xFFFF5757)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QrCard extends StatelessWidget {
  const QrCard({
    super.key,
    required this.screenWidth,
    required this.screenHieght,
    required this.checkOut,
    required this.checkIn,
    required this.startingDay,
    required this.endingDay,
    required this.reason,
    required this.location,
    required this.qrKey,
    required this.status,
    required this.currentDate,
  });

  final double screenWidth;
  final double screenHieght;
  final String checkOut;
  final String checkIn;
  final String startingDay;
  final String endingDay;
  final String reason;
  final String location;
  final String qrKey;
  final String status;
  final String currentDate;

  @override
  Widget build(BuildContext context) {
    DateTime dateTimeFormat = DateFormat('dd/MM/yyyy H:mm').parse(currentDate);
    DateTime DayFromFormat = DateFormat('yyyy-MM-dd').parse(startingDay);
    DateTime DayToFormat = DateFormat('yyyy-MM-dd').parse(endingDay);
    String convertedDate = DateFormat('MMMM dd yyyy').format(dateTimeFormat);
    String DayFrom = DateFormat('MMMM dd yyyy').format(DayFromFormat);
    String DayTo = DateFormat('MMMM dd yyyy').format(DayToFormat);
    return Center(
      child: Column(
        children: [
          Container(
            width: screenWidth * 0.9,
            height: screenHieght * 0.58,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset:
                      const Offset(0, 3), // changes the position of the shadow
                ),
              ],
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      QRCodeScreen(qrKey: '$clientURL$qrKey'),
                      const Text(
                        'NB: This Qr is only for one-time use',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF85858F),
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              const SizedBox(
                                height: 1.5,
                              ),
                              Text(
                                convertedDate,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Reason',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF85858F),
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              const SizedBox(
                                height: 1.5,
                              ),
                              Text(
                                reason,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Day From',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF85858F),
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              const SizedBox(
                                height: 1.5,
                              ),
                              Text(
                                DayFrom,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Day To',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF85858F),
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              const SizedBox(
                                height: 1.5,
                              ),
                              Text(
                                DayTo,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Venue',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF85858F),
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              const SizedBox(
                                height: 1.5,
                              ),
                              Text(
                                location,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Check Out',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF85858F),
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              const SizedBox(
                                height: 1.5,
                              ),
                              Text(
                                checkOut.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Check In',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF85858F),
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              const SizedBox(
                                height: 1.5,
                              ),
                              Text(
                                checkIn.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF85858F),
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              const SizedBox(
                                height: 1.5,
                              ),
                              Text(
                                status,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 49, 198, 26),
                                  fontFamily: 'Inter',
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      // height: 100,
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          cancelHostelPass(context, qrKey, checkOut, checkIn,
                              startingDay, endingDay);
                        },
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Color(0xFFf90608),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({super.key, required this.qrKey});
  final String qrKey;

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: qrKey,
      version: QrVersions.auto,
      size: 150.0,
    );
  }
}

Future<void> cancelHostelPass(
    context, qrKey, checkOut, checkIn, startingDay, endingDay) async {
  final token = await getToken();
  if (token != null) {
    final response = await http.post(
      Uri.parse(
          'http://$serverURL:3001/student/hostel/cancel-ActiveHostelPass'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        "key": qrKey,
        "checkOutTime": checkOut,
        "checkInTime": checkIn,
        "startingDay": startingDay,
        "endingDay": endingDay,
      },
    );
    final backendData = jsonDecode(response.body);
    print(backendData);
    if (backendData['status'] == "ok") {
      Navigator.of(context).pushNamedAndRemoveUntil(
        'SCREEN_CONTROL',
        (route) => false,
      );
    } else {
      Navigator.of(context).popAndPushNamed(
        'SCREEN_CONTROL',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Request failed 🤣'),
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
}
