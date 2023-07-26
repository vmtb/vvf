import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:testproject/components/app_text.dart';

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
    content: AppText(message, color: Colors.white, size: 20,),
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
