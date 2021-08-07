import 'package:flutter/material.dart';

void navigateTo(context, name) {
  Navigator.of(context).pushNamed(name);
}

void navigateToAndRemoveLast(context, name) {
  Navigator.of(context).pushNamedAndRemoveUntil(name, (route) => false);
}

TextTheme getTextTheme(BuildContext context) => Theme.of(context).textTheme;

Widget defaultFormField({
  required BuildContext context,
  required String label,
  required TextInputType inputType,
  required TextEditingController controller,
  void Function()? onSuffixTapped,
  IconData? prefix,
  IconData? suffix,
  bool obscure = false,
  String? Function(String?)? validator,
}) =>
    TextFormField(
      style: getTextTheme(context).bodyText1,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: label,
        border: OutlineInputBorder(gapPadding: 8),
        prefixIcon: Icon(prefix),
        suffixIcon: InkWell(
          child: Icon(suffix),
          onTap: onSuffixTapped,
        ),
      ),
      obscureText: obscure,
      keyboardType: inputType,
      controller: controller,
      validator: validator ??
          (input) {
            if (input?.isEmpty ?? true) {
              return 'input must not be empty';
            }
            return null;
          },
    );
