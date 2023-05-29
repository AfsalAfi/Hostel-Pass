import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5));
    isToken(context);
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/ekc-logo.webp',
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}

Future<void> isToken(context) async {
  final token = await SharedPreferences.getInstance();
  final savedToken = token.getString('token');
  if (savedToken == null) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      'SCREEN_LOGIN',
      (route) => false,
    );
  } else {
    Navigator.of(context).pushNamedAndRemoveUntil(
      'SCREEN_CONTROL',
      (route) => false,
    );
  }
}



















// import 'package:flutter/material.dart';
// import 'package:sample/GatePass/QRForm/qr_requesr.dart';
// import 'package:sample/GatePass/QrCodeGeneration/qrcode_page.dart';
// import 'package:sample/GatePass/QrHistory/qr_history.dart';
// import 'package:sample/GatePass/sample/new_navigation_bar.dart';
// import 'package:sample/Home/home_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ScreenSplash extends StatelessWidget {
//   ScreenSplash({
//     super.key,
//   });
//   static ValueNotifier<int> currentIndexValueNotifier = ValueNotifier(0);
//   final pages = [
//     const ScreenHome(),
//     const ScreenQRHistory(),
//     const ScreenQr(),
//     ScreenQrRequest(),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     // showImage();
//     // getDelay();
//     isToken(context);
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFAFA),
//       body: Column(
//         children: [
//           SafeArea(
//             child: ValueListenableBuilder(
//               valueListenable: currentIndexValueNotifier,
//               builder: (BuildContext context, int updatedIndex, _) {
//                 return pages[updatedIndex];
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: const NavigationBarControl(),
//     );
//   }
// }

// Future<void> isToken(context) async {
//   final token = await SharedPreferences.getInstance();
//   final savedToken = token.getString('token');
//   if (savedToken == null) {
//     Navigator.of(context).pushNamed('SCREEN_HOME');
//   } else {
//     Navigator.of(context).pushNamed('SCREEN_LOGIN');
//   }
// }

// // Future<Widget> showImage() async {
// //   return Scaffold(
// //     body: Center(
// //       child: Image.asset(
// //         'assets/images/ekc-logo.webp',
// //         width: 300,
// //         height: 300,
// //       ),
// //     ),
// //   );
// // }

// // Future<void> getDelay() async {
// //   await Future.delayed(const Duration(seconds: 5));
// // }
