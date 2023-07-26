import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class SimpleFormField extends StatelessWidget {
  final TextEditingController controller;
  final ValidationBuilder? validation;
  final String? hintText;
  final String? helperText;
  final String? labelText;
  final Widget? prefixI;
  final Widget? suffixI;
  final bool obscure;
  final int? minLines;
  final int? maxLines;
  final double? radius;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Function(String)? onChanged;

  const SimpleFormField(
      {super.key,
      required this.controller,
      this.validation,
      this.hintText,
      this.helperText,
      this.labelText,
      this.prefixI,
      this.suffixI,
      this.obscure = false,
      this.minLines,
      this.maxLines,
      this.radius=10,
      this.inputType=TextInputType.text,
      this.inputAction=TextInputAction.next,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: inputAction,
      keyboardType: inputType,
      minLines: minLines,
      maxLines: obscure?1: maxLines,
      obscureText: obscure,
      controller: controller,
      validator: validation == null ? null : validation!.build(),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        prefixIcon: prefixI,
        suffixIcon: suffixI,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius!)),
      ),
    );
  }
}


class SimpleFilledFormField extends StatelessWidget {
  final TextEditingController controller;
  final ValidationBuilder? validation;
  final String? hintText;
  final String? helperText;
  final String? labelText;
  final Widget? prefixI;
  final Widget? suffixI;
  final bool obscure;
  final int? minLines;
  final int? maxLines;
  final double? radius;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Function(String)? onChanged;

  const SimpleFilledFormField(
      {super.key,
        required this.controller,
        this.validation,
        this.hintText,
        this.helperText,
        this.labelText,
        this.prefixI,
        this.suffixI,
        this.obscure = false,
        this.minLines,
        this.radius=10,
        this.maxLines=1,
        this.inputType=TextInputType.text,
        this.inputAction=TextInputAction.next,
        this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: inputAction,
      keyboardType: inputType,
      minLines: minLines,
      maxLines: maxLines,
      obscureText: obscure,
      controller: controller,
      validator: validation == null ? null : validation!.build(),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        prefixIcon: prefixI,
        suffixIcon: suffixI,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: BorderSide.none
        ),
      ),
    );
  }
}
