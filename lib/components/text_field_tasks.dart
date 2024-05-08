import 'package:flutter/material.dart';

class TextFieldTasks extends StatefulWidget {
  final Function(String)? onSubmit;
  final Text? field;
  const TextFieldTasks({this.onSubmit, this.field, Key? key}) : super(key: key);

  @override
  State<TextFieldTasks> createState() => _TextFieldTasksState();
}

class _TextFieldTasksState extends State<TextFieldTasks> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.field?.data);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 200),
      child: TextField(
        controller: _controller,
        onSubmitted: (String value) {
          if (widget.onSubmit != null) {
            widget.onSubmit!(value);
          }
        },
      ),
    );
  }
}