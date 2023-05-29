import 'package:flutter/material.dart';
import 'package:hostelpass/GatePass/QRForm/qr_request_from.dart';
import 'package:hostelpass/GatePass/QrHistory/qr_history.dart';
import 'package:hostelpass/Login/login_new.dart';
import 'package:hostelpass/Splash/splash_screen.dart';
import 'package:hostelpass/coming_soon_page.dart';
import 'package:hostelpass/control_app.dart';
import 'package:hostelpass/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences token;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  token = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primaryColor: Colors.green, primarySwatch: Colors.blueGrey),
      home: const ScreenSplash(),
      routes: {
        'SCREEN_LOGIN': (ctx) => ScreenLogin(),
        'SCREEN_CONTROL': (ctx) => ControlApp(),
        'SCREEN_GATEPASS_HISTORY': (ctx) => const ScreenQRHistory(),
        'SCREEN_GATEPASS_REQUEST': (ctx) => const ScreenQrForm(),
        'SCREEN_PROFILE': (ctx) => const ScreenProfile(),
        'SCREEN_COMING_SOON': (ctx) => const ScreenComingSoon(),
        // 'SCREEN_EDIT_POPUP': (ctx) => const PopupPage(),
        // 'SCREEN_GATEPASS_QRCODE': (ctx) => const ScreenQRPage(),
      },
    );
  }
}
