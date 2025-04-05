import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

const Color redColor = Color.fromRGBO(230, 46, 4, 1);
const Color lightGrey = Color.fromRGBO(239, 239, 239, 1);
const Color textfieldGrey = Color.fromRGBO(209, 209, 209, 1);

Widget customTextField({
  String? title,
  String? hint,
  required TextEditingController controller,
  bool isPass = false,
  String? errorText,
  IconData? prefixIcon,
  void Function(String)? onChanged, // 👈 added
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != null)
        title.text.color(redColor).fontFamily("sans_semibold").size(16).make(),
      5.heightBox,
      TextFormField(
        obscureText: isPass,
        controller: controller,
        onChanged: onChanged, // 👈 hooked
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontFamily: "sans_semibold",
            color: textfieldGrey,
          ),
          hintText: hint,
          isDense: true,
          fillColor: lightGrey,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: redColor),
          ),
          errorText: errorText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: textfieldGrey) : null,
        ),
      ),
    ],
  );
}

