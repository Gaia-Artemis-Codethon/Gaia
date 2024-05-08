import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/models/task.dart';
import 'package:flutter_application_huerto/service/task_supabase.dart';

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
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late String title;
  late String description;
  late String tempTitle;
  int selectedPriority = -1;
  int previousPriority = -1;

  @override
  void initState() {
    super.initState();
    isDone = widget.note.status;
    title = widget.note.name;
    description = widget.note.description ?? '';
    titleController = TextEditingController(text: title);
    descriptionController = TextEditingController(text: description);
    selectedPriority = widget.note.priority; // Establecer la prioridad inicial
    previousPriority = widget.note.priority; // Establecer la prioridad
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
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
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 3, 15, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            _editTaskPopup(context);
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(fontSize: 16),
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
                                  creation_date: widget.note.creation_date,
                                  priority: selectedPriority));
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
                if (isDescriptionExpanded)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 15, 5),
                    child: InkWell(
                      onTap: () {
                        _editTaskPopup(context);
                      },
                      child: Text(
                        description,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                editTime(),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: priorityCircle(), // Mostrar el círculo de prioridad
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

  Widget priorityCircle() {
    Color circleColor;
    switch (selectedPriority) {
      case 0:
        circleColor = Colors.red;
        break;
      case 1:
        circleColor = Colors.yellow;
        break;
      case 2:
        circleColor = Colors.green;
        break;
      default:
        circleColor = Colors.grey;
    }

    return CircleAvatar(
      radius: 8,
      backgroundColor: circleColor,
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

  void _editTaskPopup(BuildContext context) {
    tempTitle = title;
    titleController.text = title;
    descriptionController.text = description;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                      onChanged: (value) {
                        setState(() {
                          tempTitle = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                      onChanged: (value) {
                        setState(() {
                          description = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    prioritySelection(), // Mostrar la selección de prioridad
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Revert changes
                            titleController.text = title;
                            descriptionController.text = description;
                            selectedPriority = previousPriority;
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            await _updateTask();
                            Navigator.pop(context);
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _updateTask() async {
    // Update task on the server
    await TaskSupabase().updateTask(Task(
      id: widget.note.id,
      name: tempTitle,
      status: widget.note.status,
      description: description,
      user_id: widget.note.user_id,
      creation_date: widget.note.creation_date,
      priority: selectedPriority, // Asignar la prioridad seleccionada
    ));

    // Update task locally
    setState(() {
      title = tempTitle;
      widget.onTaskStatusChanged();
    });
  }

  Widget prioritySelection() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: selectedPriority == 0
              ? Colors.red
              : Colors.grey, // Color para prioridad 0
          child: IconButton(
            onPressed: () {
              selectedPriority = selectedPriority == 0
                  ? -1
                  : 0; // Si está seleccionado, lo deselecciona, de lo contrario, lo selecciona
            },
            icon: Icon(Icons.circle_sharp),
            color: Colors.white,
          ),
        ),
        CircleAvatar(
          backgroundColor: selectedPriority == 1
              ? Colors.yellow
              : Colors.grey, // Color para prioridad 1
          child: IconButton(
            onPressed: () {
              selectedPriority = selectedPriority == 1
                  ? -1
                  : 1; // Si está seleccionado, lo deselecciona, de lo contrario, lo selecciona
            },
            icon: Icon(Icons.circle_sharp),
            color: Colors.white,
          ),
        ),
        CircleAvatar(
          backgroundColor: selectedPriority == 2
              ? Colors.green
              : Colors.grey, // Color para prioridad 2
          child: IconButton(
            onPressed: () {
              selectedPriority = selectedPriority == 2
                  ? -1
                  : 2; // Si está seleccionado, lo deselecciona, de lo contrario, lo selecciona
            },
            icon: Icon(Icons.circle_sharp),
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
