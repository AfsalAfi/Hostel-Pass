import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hostelpass/control_app.dart';

class NavigationBarControl extends StatelessWidget {
  const NavigationBarControl({super.key});

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
      valueListenable: ControlApp.currentIndexValueNotifier,
      builder: (BuildContext context, int updatedIndex, _) {
        return SizedBox(
          height: 70,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFFffffff),
            selectedItemColor: const Color.fromARGB(255, 2, 2, 2),
            unselectedItemColor: const Color.fromARGB(234, 137, 137, 137),
            showUnselectedLabels: false,
            showSelectedLabels: true,
            selectedFontSize: 11.0,
            unselectedFontSize: 12.0,
            onTap: (newindex) {
              ControlApp.currentIndexValueNotifier.value = newindex;
            },
            currentIndex: updatedIndex,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/home.png',
                  height: 20,
                  width: 20,
                ),
                backgroundColor: Colors.blue,
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/bookmark-.png',
                  height: 20,
                  width: 20,
                ),
                label: 'Info',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/notification-.png',
                  height: 20,
                  width: 20,
                ),
                label: 'Notification',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/settings-.png',
                  height: 20,
                  width: 20,
                ),
                backgroundColor: Colors.blue,
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
