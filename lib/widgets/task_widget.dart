// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/main.dart';
import 'package:flutter_application_huerto/models/task.dart';
import 'package:flutter_application_huerto/service/task_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';
import '../pages/toDo/edit_toDo.dart';

class TaskWidget extends StatefulWidget {
  final Task note;
  final VoidCallback onTaskStatusChanged; // Nuevo argumento para el callback

  const TaskWidget(this.note, this.onTaskStatusChanged, {super.key});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  bool isDone = false;
  bool isDescriptionExpanded = false;
  late String description;

  @override
  void initState() {
    super.initState();
    isDone = widget.note.status;
    description = widget.note.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.note.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            AnimatedCrossFade(
                              duration: Duration(milliseconds: 300),
                              crossFadeState: isDescriptionExpanded
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              firstChild: SizedBox.shrink(),
                              secondChild: Text(
                                description,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditToDo(
                                  widget.note,
                                  userId!,
                                  widget.onTaskStatusChanged,
                                ),
                              ));
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              showConfirmationDialog(context);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(width: 8),
                          Checkbox(
                            activeColor: Colors.green.shade200,
                            value: isDone,
                            onChanged: (value) async {
                              setState(() {
                                isDone = !isDone;
                              });
                              await TaskSupabase().taskIsDone(Task(
                                id: widget.note.id,
                                status: isDone,
                                name: widget.note.name,
                                description: description,
                                user_id: widget.note.user_id,
                              ));
                              widget.onTaskStatusChanged();
                            },
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isDescriptionExpanded = !isDescriptionExpanded;
                              });
                            },
                            child: Icon(
                              isDescriptionExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                editTime(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget editTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            direction: Axis.horizontal,
            children: [],
          ),
        ),
      ),
    );
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar tarea"),
          content: Text("¿Estás seguro de querer eliminar esta tarea?"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await TaskSupabase().deleteTask(widget.note.id);
                widget.onTaskStatusChanged();
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: OurColors().primary,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Text(
                  "Si",
                  style: TextStyle(color: OurColors().primaryTextColor),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: OurColors().deleteButton,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Text(
                  "No",
                  style: TextStyle(color: OurColors().primaryTextColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
