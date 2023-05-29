import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:hostelpass/core.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHieght = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: screenHieght * 0.18,
                width: screenWidth,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  color: const Color(0xFFFAFAFA),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 35,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: screenHieght * 0.43,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: ListView(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'General',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: screenHieght * 0.02,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed('SCREEN_PROFILE');
                                  },
                                  child: const SettingsTile(
                                    icon: Icons.lock_person_rounded,
                                    text: 'Account',
                                  ),
                                ),
                                SizedBox(
                                  height: screenHieght * 0.01,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed('SCREEN_COMING_SOON');
                                  },
                                  child: const SettingsTile(
                                    icon: Icons.notifications_on_rounded,
                                    text: 'Notifications',
                                  ),
                                ),
                                SizedBox(
                                  height: screenHieght * 0.01,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed('SCREEN_COMING_SOON');
                                  },
                                  child: const SettingsTile(
                                    icon: Icons.move_down_rounded,
                                    text: 'Theme',
                                  ),
                                ),
                                SizedBox(
                                  height: screenHieght * 0.035,
                                ),
                                const Text(
                                  'Support',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: screenHieght * 0.02,
                                ),
                                const SettingsTile(
                                  icon: Icons.warning_rounded,
                                  text: 'Report an issue',
                                ),
                                SizedBox(
                                  height: screenHieght * 0.01,
                                ),
                                const SettingsTile(
                                  icon: FontAwesomeIcons.questionCircle,
                                  text: 'FAQ',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SizedBox(
                        width: screenWidth * 0.50,
                        height: screenHieght * 0.065,
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
                          onPressed: () {
                            logOut(context);
                          },
                          child: const Text(
                            'Log out',
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
            ],
          ),
        ));
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const SettingsTile({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                ),
                const SizedBox(width: 8.0),
                Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 13,
            ),
          ],
        ),
      ),
    );
  }
}


// ListView.builder(
              //   itemCount: 3,
              //   itemBuilder: (BuildContext context, int index) {
              //     final item = "yourDataSource[index]";

              //     return ListTile(
              //       title: Text(item.title),
              //       subtitle: Text(item.subtitle),
              //       onTap: () {},
              //     );
              //   },
              // ),