import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:vvf/components/app_button.dart';
import 'package:vvf/components/app_input.dart';
import 'package:vvf/components/app_text.dart';
import 'package:vvf/pages/auth/register_page.dart';
import 'package:vvf/utils/app_func.dart';

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
  bool isLoadingApple = false;
  bool isLoadingGoogle = false;

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
                  url: "assets/img/logo.png",
                  width: getSize(context).width / 2,
                ),
                const SpacerHeight(
                  height: 30,
                ),
                SimpleFilledFormField(
                  controller: emailController,
                  validation: ValidationBuilder().email(),
                  inputType: TextInputType.emailAddress,
                  radius: 10,
                  hintText: "Email",
                ),
                const SpacerHeight(),
                SimpleFilledFormField(
                  controller: passwordController,
                  validation: ValidationBuilder(),
                  inputType: TextInputType.emailAddress,
                  radius: 10,
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
                      String error = await ref.read(authController).login(
                          emailController.text.trim(),
                          passwordController.text.trim());
                      setState(() {
                        isLoading = false;
                      });
                      if (error.isEmpty) {
                        showSuccessError(
                            context, "Nous sommes ravis de vous revoir",
                            widget: const HomePage(), back: false);
                      } else {
                        showSnackbar(context, error);
                      }
                    }
                  },
                  isLoading: isLoading,
                ),
                const SpacerHeight(
                  height: 20,
                ),
                const AppText("Ou"),
                const SpacerHeight(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        setState(() {
                          isLoadingGoogle = true;
                        });
                        String error = await ref.read(authController).handleGoogleSignIn();
                        setState(() {
                          isLoadingGoogle = false;
                        });
                        if (error.isEmpty) {
                          showSuccessError(
                              context, "Nous sommes ravis de vous revoir..",
                              widget: const HomePage(), back: false);
                        } else {
                          showSnackbar(context, error);
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: isLoadingGoogle
                            ? const CupertinoActivityIndicator()
                            : Image.asset(
                                "assets/img/google.png",
                                width: 30,
                                height: 30,
                                color: Colors.white,
                              ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {

                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: isLoadingApple
                            ? const CupertinoActivityIndicator()
                            : Image.asset(
                                "assets/img/apple.png",
                                width: 30,
                                height: 30,
                                color: Colors.white,
                          ),
                      ),
                    ),
                  ],
                ),
                const SpacerHeight(
                  height: 40,
                ),
                InkWell(
                    onTap: () {
                      navigateToWidget(context, const RegisterPage(),
                          back: false);
                    },
                    child: const AppText(
                        "Vous n'avez pas un compte? Créer un compte", align: TextAlign.center,)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
