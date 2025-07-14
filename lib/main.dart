import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:norsk_tolk/firebase_options.dart';
import 'package:norsk_tolk/theme/dark_theme.dart';
import 'package:norsk_tolk/theme/light_theme.dart';
import 'package:norsk_tolk/views/splash/splash.dart';
//itranslator
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: light(context),
          darkTheme: dark(context),
          home: const SplashView(),
          navigatorObservers: [FlutterSmartDialog.observer],
        );
      },
    );
  }
}
