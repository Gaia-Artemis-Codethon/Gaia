import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/models/task.dart';
import 'package:flutter_application_huerto/pages/home_page.dart';
import 'package:flutter_application_huerto/pages/toDo/toDo.dart';
import 'package:flutter_guid/flutter_guid.dart';

import '../../service/task_supabase.dart';

class EditToDo extends StatefulWidget {
  final Task _note;
  final Guid userId;
  final VoidCallback onTaskStatusChanged;
  const EditToDo(this._note, this.userId, this.onTaskStatusChanged,
      {super.key});

  @override
  State<EditToDo> createState() => _EditToDoState();
}

class _EditToDoState extends State<EditToDo> {
  TextEditingController? title;
  TextEditingController? description;

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  int indexx = 0;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget._note.name);
    description = TextEditingController(text: widget._note.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColors().backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title_widgets(),
            const SizedBox(height: 20),
            description_widgets(),
            const SizedBox(height: 20),
            button(),
          ],
        ),
      ),
    );
  }

  Widget button() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: title!,
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade200,
                minimumSize: const Size(170, 48),
              ),
              onPressed: value.text.isEmpty
                  ? null
                  : () async {
                      await TaskSupabase().updateTask(Task(
                        id: widget._note.id,
                        name: title!.text,
                        status: widget._note.status,
                        description: description!.text,
                        user_id: widget._note.user_id,
                      ));
                      widget.onTaskStatusChanged();
                      Navigator.pop(context);
                    },
              child: Text(
                'Editar tarea',
                style: TextStyle(color: OurColors().primaryTextColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(170, 48),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancelar',
                style: TextStyle(color: OurColors().primaryTextColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget title_widgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: title,
          focusNode: _focusNode1,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'Title',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xffc5c5c5),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.green.shade200,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget description_widgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: description,
          focusNode: _focusNode2,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'Description',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xffc5c5c5),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.green.shade200,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
