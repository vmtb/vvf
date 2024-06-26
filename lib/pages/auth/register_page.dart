import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:vvf/home_page.dart';
import 'package:vvf/pages/auth/login_page.dart';

import '../../components/app_button.dart';
import '../../components/app_image.dart';
import '../../components/app_input.dart';
import '../../components/app_text.dart';
import '../../utils/app_func.dart';
import '../../utils/providers.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final pseudoController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cpasswordController = TextEditingController();
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
                  url: "assets/img/logo.png",
                  width: getSize(context).width / 2,
                ),
                const SpacerHeight(
                  height: 30,
                ),

                SimpleFilledFormField(
                  controller: pseudoController,
                  validation: ValidationBuilder(),
                  inputType: TextInputType.name,
                  radius: 10,
                  hintText: "Votre surnom",),
                const SpacerHeight(),
                SimpleFilledFormField(
                  controller: emailController,
                  validation: ValidationBuilder().email(),
                  inputType: TextInputType.emailAddress,
                  radius: 10,
                  hintText: "Email",),
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
                  hintText: "Mot de passe",),
                const SpacerHeight(),

                SimpleFilledFormField(
                  controller: cpasswordController,
                  validation: ValidationBuilder().add((value) {
                    if (value!.trim() != passwordController.text.trim()) {
                      return "Les deux mots de passe ne correspondent pas";
                    }
                    return null;
                  }),
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
                  hintText: "Confirmer le Mot de passe",),
                const SpacerHeight(
                  height: 30,
                ),
                AppButtonRound(
                  text: "S'inscrire",
                  onTap: () async {
                    if (key.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      String error = await  ref.read(authController).register(emailController.text.trim(), passwordController.text.trim(), pseudoController.text.trim());
                      setState(() {
                        isLoading = false;
                      });
                      if(error.isEmpty){
                        showSuccessError(context, "Compte créé avec succès", widget: HomePage(), back: false);
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
                const SpacerHeight(
                  height: 40,
                ),
                InkWell(
                    onTap: () {
                      navigateToWidget(context, const LoginPage(), back: false);
                    },
                    child:
                        AppText("Vous avez  déjà un compte? Connectez-vous", align: TextAlign.center,)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
