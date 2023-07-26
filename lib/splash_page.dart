import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/components/app_image.dart';
import 'package:vvf/components/app_text.dart';
import 'package:vvf/home_page.dart';
import 'package:vvf/pages/auth/login_page.dart';
import 'package:vvf/utils/app_func.dart';
import 'package:vvf/utils/providers.dart';


// ref.read()
final nbTimes = Provider<int>((ref) => 50);
final darkModeEnabled = StateProvider<bool>((ref) => false);

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {

  @override
  void initState() {
    super.initState();
    setupTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width : getSize(context) . width,
        height: getSize(context) . height,
        child: Stack(
          children: [
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: const AppImage(url: "assets/img/logo.png", width: 250, height: 250,)),
            ),

            Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Column(
                  children: const [
                    AppText("Votre indépendance financière est main...", weight: FontWeight.bold,),
                    SizedBox(height: 20,),
                    CupertinoActivityIndicator(),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void setupTimer() {
    Future.delayed(const Duration(seconds: 4), () async {
      //  bool homeP = PreferenceHelper.getBool("home");
      //
      ref.read(firebaseMessaging).subscribeToTopic("all_users");
      // String? token = await ref.read(firebaseMessaging).getToken();
      // if(user...is..femme)
      // ref.read(firebaseMessaging).subscribeToTopic("all_femmes");

      // if(ref.read(mAuth).currentUser==null){
      //   navigateToWidget(context, const LoginPage());
      // } else {
      //   log(ref.read(mAuth).currentUser!.uid);
      //   navigateToWidget(context, const HomePage(), back: false);
      // }
    });
  }
}


