import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/main.dart';
import 'package:flutter_application_huerto/models/task.dart';
import 'package:flutter_application_huerto/service/task_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/text_field_tasks.dart';
import '../pages/toDo/edit_toDo.dart';

class TaskWidget extends StatefulWidget {
  final Task note;
  final VoidCallback onTaskStatusChanged;

  const TaskWidget(this.note, this.onTaskStatusChanged, {Key? key})
      : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  bool isDone = false;
  bool isDescriptionExpanded = false;
  bool isEditingTitle = false; // Estado para controlar la edición del título
  bool isEditingDescription = false; // Estado para controlar la edición de la descripción
  late String description;
  late String title; // Variable para almacenar el título editado

  @override
  void initState() {
    super.initState();
    isDone = widget.note.status;
    description = widget.note.description ?? '';
    title = widget.note.name;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEditingTitle = false;
          isEditingDescription = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinear los iconos a la derecha
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isEditingTitle = true;
                                isEditingDescription = false; // Asegurarse de que la edición de la descripción esté desactivada
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Usa un Text hasta que se haga clic en él
                                isEditingTitle
                                    ? TextField(
                                        controller: TextEditingController(text: title),
                                        onChanged: (value) {
                                          setState(() {
                                            title = value;
                                          });
                                        },
                                        onSubmitted: (value) {
                                          setState(() {
                                            isEditingTitle = false;
                                          });
                                          _updateTaskName();
                                        },
                                      )
                                    : Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                SizedBox(height: 5),
                                AnimatedCrossFade(
                                  duration: Duration(milliseconds: 300),
                                  crossFadeState: isDescriptionExpanded
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                                  firstChild: SizedBox.shrink(),
                                  secondChild: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isEditingTitle = false;
                                        isEditingDescription = true;
                                      });
                                    },
                                    child: TextField(
                                      controller: TextEditingController(text: description),
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          description = value;
                                        });
                                      },
                                      onSubmitted: (value) {
                                        setState(() {
                                          isEditingDescription = false;
                                        });
                                        _updateTaskDescription();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEditingTitle = false; // Ocultar la barra de edición del título
                                  isEditingDescription = false; // Ocultar la barra de edición de la descripción
                                });
                                TaskSupabase().updateTask(Task(
                                  id: widget.note.id,
                                  name: title,
                                  status: widget.note.status,
                                  description: description,
                                  user_id: widget.note.user_id,
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
                                  name: title,
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

  void _updateTaskName() {
    TaskSupabase().updateTask(Task(
      id: widget.note.id,
      name: title,
      status: widget.note.status,
      description: description,
      user_id: widget.note.user_id,
    ));
  }

  void _updateTaskDescription() {
    TaskSupabase().updateTask(Task(
      id: widget.note.id,
      name: title,
      status: widget.note.status,
      description: description,
      user_id: widget.note.user_id,
    ));
  }
}
