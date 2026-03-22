import 'package:flutter/material.dart';
import 'main.dart';

class Pixel extends StatelessWidget {
  final Color? color;
  const Pixel({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: nothingOScolorscheme.value
            ? BorderRadius.circular(90)
            : BorderRadius.circular(4),
      ),
      margin: nothingOScolorscheme.value ? EdgeInsets.all(0) : EdgeInsets.all(1),
    );
  }
}