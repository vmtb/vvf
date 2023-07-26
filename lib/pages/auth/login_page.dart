import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:testproject/components/app_button.dart';
import 'package:testproject/components/app_input.dart';
import 'package:testproject/components/app_text.dart';
import 'package:testproject/pages/auth/register_page.dart';
import 'package:testproject/utils/app_func.dart';

import '../../components/app_image.dart';
import '../../home_page.dart';
import '../../utils/providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var key = GlobalKey<FormState>();

  bool hidePassword = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: getSize(context).width,
          height: getSize(context).height,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage(
                  url: "assets/img/login.png",
                  width: getSize(context).width / 2,
                ),
                const AppText(
                  "Welcome here",
                  size: 26,
                  weight: FontWeight.bold,
                  isNormal: false,
                ),
                const AppText(
                  "Login into your existant account",
                  isNormal: false,
                ),
                const SpacerHeight(
                  height: 30,
                ),
                SimpleFormField(
                  controller: emailController,
                  validation: ValidationBuilder().email(),
                  inputType: TextInputType.emailAddress,
                  radius: 30,
                  hintText: "Email",
                ),
                const SpacerHeight(),
                SimpleFormField(
                  controller: passwordController,
                  validation: ValidationBuilder(),
                  obscure: hidePassword,
                  suffixI: IconButton(
                      onPressed: () {
                        hidePassword = !hidePassword;
                        log(hidePassword);
                        setState(() {});
                      },
                      icon: hidePassword
                          ? const Icon(Icons.remove_red_eye)
                          : const Icon(Icons.password_outlined)),
                  radius: 30,
                  hintText: "Password",
                ),
                const SpacerHeight(
                  height: 30,
                ),
                AppButtonRound(
                  text: "Se connecter",
                  onTap: () async {
                    if (key.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      String error = await  ref.read(authController).login(emailController.text.trim(), passwordController.text.trim());
                      setState(() {
                        isLoading = false;
                      });
                      if(error.isEmpty){
                        showSuccessError(context, "Nous sommes ravis de vous revoir", widget: HomePage(), back: false);
                      }else{
                        showSnackbar(context, error);
                      }
                    }
                  },
                  isLoading: isLoading,
                ),
                const SpacerHeight(
                  height: 20,
                ),
                AppText("Ou"),
                const SpacerHeight(
                  height: 20,
                ),
                AppButtonRound(
                  text: "Google",
                  prefix: Image.asset(
                    "assets/img/google.png",
                    width: 30,
                    height: 30,
                    color: Colors.white,
                  ),
                  onTap: () {
                    if (key.currentState!.validate()) {}
                  },
                  backgroundColor: Colors.red,
                ),
                const SpacerHeight(
                  height: 40,
                ),
                InkWell(
                    onTap: (){
                      navigateToWidget(context, const RegisterPage(), back: false);
                    },
                    child: AppText("Vous n'avez pas un compte? Créer un compte")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
