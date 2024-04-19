import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/const/colors.dart';

class Button extends StatelessWidget {
  final Text? text;
  final Icon? icon;
  final Function? onPressed;
  final ButtonStyle? style;

  const Button({super.key, this.text, this.icon, this.onPressed, this.style});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed != null ? () => onPressed!() : null,
      style: style ??
          ElevatedButton.styleFrom(backgroundColor: OurColors().accent),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          text ?? const Text(''),
          //const SizedBox(width: 10),
        ],
      ),
    );
  }
}
