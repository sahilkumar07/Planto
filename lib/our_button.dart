import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

Widget OurButton({onPress, Color?color, Color?textColor, String?title}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(12),
      ),
      onPressed: onPress,
      child: title!.text.color(textColor).white.fontFamily("sans_bold").make());
}
