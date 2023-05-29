import 'package:flutter/material.dart';
import 'package:hostelpass/GatePass/sample/new_navigation_bar.dart';
import 'package:hostelpass/Home/home_screen.dart';
import 'package:hostelpass/coming_soon_page.dart';
import 'package:hostelpass/settings.dart';

class ControlApp extends StatelessWidget {
  ControlApp({
    super.key,
  });
  static ValueNotifier<int> currentIndexValueNotifier = ValueNotifier(0);
  final pages = [
    const ScreenHome(),
    const ScreenComingSoon(),
    const ScreenComingSoon(),
    const ScreenSettings(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: currentIndexValueNotifier,
          builder: (BuildContext context, int updatedIndex, _) {
            return pages[updatedIndex];
          },
        ),
      ),
      bottomNavigationBar: const NavigationBarControl(),
    );
  }
}



// Future<Widget> showImage() async {
//   return Scaffold(
//     body: Center(
//       child: Image.asset(
//         'assets/images/ekc-logo.webp',
//         width: 300,
//         height: 300,
//       ),
//     ),
//   );
// }

// Future<void> getDelay() async {
//   await Future.delayed(const Duration(seconds: 5));
// }
