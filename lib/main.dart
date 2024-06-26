import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/splash_page.dart';
import 'package:vvf/utils/app_const.dart';
import 'package:vvf/utils/app_pref.dart';
import 'package:vvf/utils/app_styles.dart';

import 'pages/auth/login_page.dart';
import 'utils/config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  /*Init notifications*/
  await initializeNotifications();
  await initializeFirebaseMessaging();
  configureFirebaseMessaging();

  /*Init shared preferences*/
  await PreferenceHelper.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'VV Finance',
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginPage(),
      },
      theme: ThemeData(
        primarySwatch: customPrimaryColor,
      ),
      home: SplashPage(),
    );
  }
}
