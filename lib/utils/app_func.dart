import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vvf/components/app_text.dart';
import 'package:vvf/utils/providers.dart';

import '../components/app_button.dart';

Size getSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

void log(dynamic e) {
  if (kDebugMode) {
    print(e);
  }
}

void navigateToWidget(BuildContext context, Widget newPage,
    {bool back = true}) {
  if (back) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => newPage),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => newPage),
    );
  }
}

void showSuccessError(BuildContext context, String text,
    {String okText = "OK", onTap, bool error = false, widget, bool back = false }) {
  Alert(
    context: context,
    type: error ? AlertType.error : AlertType.success,
    title: error ? "Oops" : "Félicitations",
    desc: text,
    buttons: [
      DialogButton(
        onPressed: onTap ?? (){
          if(widget==null) {
            Navigator.pop(context);
          }else{
            // Navigator.pop(context);
            navigateToWidget(context, widget, back: back);
          }
        },
        width: 120,
        child: Text(
          okText,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      )
    ],
  ).show();
}

void showConfirm(BuildContext context, String text, confirmTap,
    {String okText = "Oui", String noText = "Non"}) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: "Confirmation",
    desc: text,
    buttons: [
      if (okText.isNotEmpty)
        DialogButton(
          onPressed: confirmTap ?? () => Navigator.pop(context),
          color: const Color.fromRGBO(0, 179, 134, 1.0),
          child: Text(
            okText,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      if (noText.isNotEmpty)
        DialogButton(
          onPressed: () => Navigator.pop(context),
          gradient: const LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
          child: Text(
            noText,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
    ],
  ).show();
}

void showSnackbar(BuildContext context, String message) {
  final snackbar = SnackBar(
    content: AppText(message, color: Colors.white, size: 16),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

class SpacerHeight extends StatelessWidget {
  final double height;
  const SpacerHeight({super.key, this.height=10});

  @override
  Widget build(BuildContext context) {
    return   SizedBox(
      height: height,
    );
  }
}

Widget errorLoading(e, stack){
  log(e);
  log(stack);
  return Text("Une erreur s'est produite... ${e.toString()}");
}


Widget loadingError(){
  return const CupertinoActivityIndicator();
}

DateTime getFirstDayOfWeek(DateTime date) {
  date = DateTime(date.year, date.month, date.day);
  int weekDay = date.weekday;
  return date.subtract(Duration(days: weekDay - 1));
}
DateTime getFirstDayOfMonth(DateTime date) {
  return DateTime(date.year, date.month, 1);
}
DateTime getLastDayOfWeek(DateTime date) {
  date = DateTime(date.year, date.month, date.day);
  int weekDay = date.weekday;
  return date.add(Duration(days: DateTime.daysPerWeek - weekDay));
}
DateTime getLastDayOfMonth(DateTime date) {
  int lastDayOfMonth = DateTime(date.year, date.month + 1, 0).day;
  return DateTime(date.year, date.month, lastDayOfMonth);
}
DateTime getLastDayOfYear(DateTime date) {
  return DateTime(date.year + 1, 1, 0);
}


void showLogoutDialog(WidgetRef ref, BuildContext context) {
  showDialog(context: context, builder: (context){
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      content: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const AppText("Voulez-vous vraiment vous déconnecter?", size: 18, align: TextAlign.center,),
            AppButtonRound(text: "Non, annuler", onTap: (){
              Navigator.pop(context);
            }),
            TextButton(onPressed: () async {
              await ref.read(mAuth).signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                    (route) => false, // This will remove all previous routes
              );
            }, child: const Text("Continuer la déconnexion", style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 18
            ),))
          ],
        ),
      ),
    );
  });
}


void showDeleteAccount(WidgetRef ref, BuildContext context) {
  showDialog(context: context, builder: (context){
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      content: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const AppText("Voulez-vous vraiment supprimer votre compte? Elle est irréversible..", size: 18, align: TextAlign.center,),
            AppButtonRound(text: "Non, annuler", onTap: (){
              Navigator.pop(context);
            }),
            TextButton(onPressed: () async {
              await ref.read(userController).deleteUser();
              await ref.read(mAuth).signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                    (route) => false, // This will remove all previous routes
              );
            }, child: const Text("Continuer la déconnexion", style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 18
            ),))
          ],
        ),
      ),
    );
  });
}


