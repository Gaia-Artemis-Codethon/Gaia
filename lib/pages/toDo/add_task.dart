import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';

import '../../const/colors.dart';
import '../../models/task.dart';
import '../../service/supabaseService.dart';
import '../../service/task_supabase.dart';

class Add_Task extends StatefulWidget {
  final Guid userId;
  final VoidCallback onTaskStatusChanged;

  const Add_Task(this.userId, this.onTaskStatusChanged, {super.key});

  @override
  State<Add_Task> createState() => _Add_TaskState();
}

class _Add_TaskState extends State<Add_Task> {
  final title = TextEditingController();
  final description = TextEditingController();

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  int indexx = 0;
  int priority = 0; // Variable para almacenar la prioridad seleccionada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColors().backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            name_widgets(),
            const SizedBox(height: 20),
            description_widgets(),
            const SizedBox(height: 20),
            prioritySelection(), // Agregar la selección de prioridad
            const SizedBox(height: 20),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: title,
              builder: (context, value, child) {
                return button(value.text.isNotEmpty);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget button(bool isEnabled) {
  final isPrioritySelected = priority != -1; // Verificar si se ha seleccionado una prioridad
  
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade200,
          minimumSize: const Size(170, 48),
        ),
        onPressed: isEnabled && isPrioritySelected // Habilitar solo si hay texto y se ha seleccionado una prioridad
            ? () async {
                await TaskSupabase().addTask(Task(
                  id: Guid.newGuid,
                  name: title.text,
                  status: false,
                  description: description.text,
                  user_id: widget.userId,
                  creation_date: DateTime.now(),
                  priority: priority, // Asignar la prioridad seleccionada
                ));
                widget.onTaskStatusChanged();
                Navigator.pop(context);
              }
            : null,
        child: Text(
          'Add task',
          style: TextStyle(color: OurColors().primaryTextColor, fontSize: 16),
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
          'Cancel',
          style: TextStyle(color: OurColors().primaryTextColor, fontSize: 16),
        ),
      ),
    ],
  );
}

  Widget name_widgets() {
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
            hintText: 'Name',
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
          maxLines: 3,
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

  Widget prioritySelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          backgroundColor: Colors.red, // Color para prioridad 0
          child: IconButton(
            onPressed: () {
              setState(() {
                priority = 0; // Asignar prioridad 0
              });
            },
            icon: Icon(Icons.circle_sharp),
            color: Colors.white,
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.yellow, // Color para prioridad 1
          child: IconButton(
            onPressed: () {
              setState(() {
                priority = 1; // Asignar prioridad 1
              });
            },
            icon: Icon(Icons.circle_sharp),
            color: Colors.white,
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.green, // Color para prioridad 2
          child: IconButton(
            onPressed: () {
              setState(() {
                priority = 2; // Asignar prioridad 2
              });
            },
            icon: Icon(Icons.circle_sharp),
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}