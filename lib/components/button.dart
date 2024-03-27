import 'package:flutter/material.dart';

class Button extends StatelessWidget {
 final String? text;
 final Icon? icon;
 final Function? onPressed;
 final ButtonStyle? style;

 Button({Key? key, this.text, this.icon, this.onPressed, this.style}) : super(key: key);

 @override
 Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed != null ? () => onPressed!() : null,
      style: style?? ElevatedButton.styleFrom(
        backgroundColor: Colors.orange
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text ?? ''),
          icon ?? const Icon(Icons.add),
        ],
      ),
    );
 }
}
