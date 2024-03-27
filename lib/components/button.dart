import 'package:flutter/material.dart';

class Button extends StatelessWidget {
 final Text? text;
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
          text?? const Text(''),
          const SizedBox(width: 10),
          icon ?? const Icon(Icons.add),
        ],
      ),
    );
 }
}
