import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vvf/components/app_image.dart';
import 'package:vvf/components/app_text.dart';
import 'package:vvf/controllers/user_controller.dart';
import 'package:vvf/home_page.dart';
import 'package:vvf/models/devise_model.dart';
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
                    AppText("Votre indépendance financière en main...", weight: FontWeight.bold,),
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
    Future.delayed(const Duration(milliseconds: 500), () async {
      //  bool homeP = PreferenceHelper.getBool("home");
      //
      // String? token = await ref.read(firebaseMessaging).getToken();
      // if(user...is..femme)
      // ref.read(firebaseMessaging).subscribeToTopic("all_femmes");

      await ref.read(deviseController).setupDevise();

      if(ref.read(mAuth).currentUser==null){
        navigateToWidget(context, const LoginPage());
      } else {
        await ref.read(userController).setupUser();
        navigateToWidget(context, const HomePage(), back: false);
      }
    });
  }

  void setupDevises() {
    Devise d = Devise(name: "Franc CFA", symbol: "XOF", rate: 0.0015, type: "", key: "");
    Devise d2 = Devise(name: "Euro", symbol: "€", rate: 1, type: "main", key: "");
    Devise d3 = Devise(name: "Dollar", symbol: "\$", rate: 0.91, type: "", key: "");

    ref.read(deviseController).addDevise(d);
    ref.read(deviseController).addDevise(d2);
    ref.read(deviseController).addDevise(d3);
  }
}


