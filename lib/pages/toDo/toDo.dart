import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_huerto/pages/toDo/add_task.dart';
import 'package:flutter_guid/flutter_guid.dart';

import '../../const/colors.dart';
import '../../widgets/strem_note.dart';

class ToDo extends StatefulWidget {
 final Guid userId;
 const ToDo(this.userId, {super.key});

 @override
 State<ToDo> createState() => _ToDoState();
}

bool show = true;

class _ToDoState extends State<ToDo> {

 void updateTasks() {
    setState(() {});
 }

 @override
 void initState() {
    super.initState();
    setState(() {
    });
 }

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColors().backgroundColor,
      floatingActionButton: Visibility(
        visible: show,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Add_Task(widget.userId, updateTasks),
            ));
          },
          backgroundColor: Colors.green.shade200,
          child: const Icon(Icons.add, size: 30),
        ),
      ),
      body: SafeArea(
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              setState(() {
                show = true;
              });
            }
            if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                show = false;
              });
            }
            return true;
          },
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                 height: 200, // Ajusta la altura según sea necesario
                 child: StreamNote(false, widget.userId, updateTasks),
                ),
              ),
                Text(
                 'isDone',
                 style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                 ),
                ),
              Expanded(
                child: SizedBox(
                 height: 200, // Ajusta la altura según sea necesario
                 child: StreamNote(true, widget.userId, updateTasks),
                ),
              ),
            ],
          ),
        ),
      ),
    );
 }
}
