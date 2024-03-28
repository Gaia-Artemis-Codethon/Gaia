import 'package:flutter/material.dart';

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
      style: style?? ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF6917B),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          text?? const Text(''),
          const SizedBox(width: 10),
          icon ?? const Icon(Icons.add),
        ],
      ),
    );
 }
}
