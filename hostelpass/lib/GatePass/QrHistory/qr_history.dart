import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hostelpass/core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<dynamic>? getDataFuture;

class ScreenQRHistory extends StatelessWidget {
  const ScreenQRHistory({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      backgroundColor: Color(0xFFFAFAFA),
      body: SafeArea(
        child: GatePassTabs(),
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          'Hostel Pass',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            Icons.search,
            color: Colors.black87,
            size: 27,
          ),
        ),
      ],
    );
  }
}

class GatePassTabs extends StatefulWidget {
  const GatePassTabs({super.key});

  @override
  State<GatePassTabs> createState() => _GatePassTabsState();
}

late TabController _tabController;

class _GatePassTabsState extends State<GatePassTabs>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    getDataFuture = _getHistory();
  }

  // @override
  // void initState() {
  //   super.initState();

  // }

  Future<dynamic> _getHistory() async {
    final token = await getToken();
    if (token != null) {
      final response = await http.post(
        Uri.parse('http://$serverURL:3001/student/hostel/Pass-history'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {},
      );
      final rr = jsonDecode(response.body);

      return jsonDecode(response.body);
    } else {
      // Navigator.of(context).pushNamed('SCREEN_LOGIN');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22, top: 0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF384BD5),
              ),
              tabs: const [
                Tab(text: "All"),
                Tab(text: "Departed"),
                Tab(text: "Rejected"),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              SizedBox(
                child: FutureBuilder<dynamic>(
                  future: getDataFuture,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final result = snapshot.data['history'];
                      return GatePassHistoryCard(
                          result: result,
                          screenHeight: screenHeight,
                          screenWidth: screenWidth);
                    }
                  },
                ),
              ),
              SizedBox(
                child: FutureBuilder<dynamic>(
                  future: getDataFuture,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final result = snapshot.data['history']
                          .where((item) => item['status'] == 'Departed')
                          .toList();
                      return GatePassHistoryCard(
                          result: result,
                          screenHeight: screenHeight,
                          screenWidth: screenWidth);
                    }
                  },
                ),
              ),
              SizedBox(
                child: FutureBuilder<dynamic>(
                  future: getDataFuture,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final result = snapshot.data['history']
                          .where((item) => item['status'] == 'Rejected')
                          .toList();
                      return GatePassHistoryCard(
                          result: result,
                          screenHeight: screenHeight,
                          screenWidth: screenWidth);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GatePassHistoryCard extends StatelessWidget {
  const GatePassHistoryCard({
    super.key,
    required this.result,
    required this.screenHeight,
    required this.screenWidth,
  });

  final List result;
  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: result.length,
      itemBuilder: (BuildContext context, int index) {
        Color statusColor = getStatusColor(result[index]['status']);
        return Padding(
          padding: const EdgeInsets.only(left: 22, right: 22, top: 10),
          child: Container(
            width: double.infinity,
            height: 155,
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
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatDate(
                              result[index]['currentTime'].split(' ')[0]),
                          style: const TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xD2060606),
                          ),
                        ),
                        Text(
                          result[index]['reason'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(210, 61, 61, 61),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Place to visit :',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                                color: Color.fromARGB(210, 105, 104, 104),
                              ),
                            ),
                            Text(
                              result[index]['location'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(210, 61, 61, 61),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                  result[index]['checkOut'].toUpperCase(),
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 5, 5, 5),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 10,
                              color: Color.fromARGB(255, 5, 5, 5),
                            ),
                            const Icon(
                              Icons.directions_walk,
                              size: 25,
                              color: Color.fromARGB(255, 5, 5, 5),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 10,
                              color: Color.fromARGB(255, 5, 5, 5),
                            ),
                            const SizedBox(
                              width: 5,
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
                                  result[index]['checkIn'].toUpperCase(),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  getStatus(result[index]['status']),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            getTextFromStatus(result[index]['status']),
                            style: const TextStyle(
                              color: Color.fromARGB(210, 105, 104, 104),
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Text(
                              'Department of CSE',
                              style: TextStyle(
                                color: Color.fromARGB(210, 61, 61, 61),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          getQrImage(result[index]['status']),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
            // height: 5.0,
            );
      },
    );
  }
}

Future<String?> getToken() async {
  final token = await SharedPreferences.getInstance();
  final savedToken = token.getString('jwt');
  return savedToken;
}

Color getStatusColor(status) {
  if (status == "Approved") {
    return Colors.green;
  } else if (status == "Rejected") {
    return Colors.red;
  } else if (status == "Departed") {
    return Colors.orange;
  } else {
    return Colors.yellow;
  }
}

Image getQrImage(status) {
  if (status == "Approved") {
    return Image.asset(
      'assets/images/qrCode.png',
      width: 80,
    );
  } else if (status == "Rejected") {
    return Image.asset(
      'assets/images/greyQrcode.png',
      width: 80,
    );
  } else if (status == "Departed") {
    return Image.asset(
      'assets/images/qrCode.png',
      width: 80,
    );
  } else {
    return Image.asset(
      'assets/images/qrCode.png',
      width: 80,
    );
  }
}

String getTextFromStatus(String status) {
  if (status == 'Rejected') {
    return 'Rejected by';
  } else {
    return 'Approved by';
  }
}

String formatDate(String inputDate) {
  DateTime date = DateFormat('dd/MM/yyyy').parse(inputDate);
  String formattedDate = DateFormat('dd MMM yyyy').format(date);
  return formattedDate;
}

String getStatus(String status) {
  if (status == 'Rejected') {
    return 'Rejected';
  } else if (status == 'Approved') {
    return 'Approved by';
  } else if (status == 'Departed') {
    return 'Departed';
  } else if (status == 'Pending' || status == 'Tutor permission required') {
    return 'Pending';
  } else {
    return "status";
  }
}
