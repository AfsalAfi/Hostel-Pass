import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScreenComingSoon extends StatelessWidget {
  const ScreenComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    const svgImage = 'assets/images/comingsoon.svg';

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgImage,
              width: screenWidth * 0.15,
              height: screenHeight * 0.3,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Coming soon...',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
