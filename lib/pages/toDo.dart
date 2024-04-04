import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_huerto/pages/add_note.dart';
import 'package:flutter_guid/flutter_guid.dart';

import '../const/colors.dart';
import '../widgets/strem_note.dart';

class ToDo extends StatefulWidget {
  final Guid userId;
  const ToDo(this.userId, {super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

bool show = true;

class _ToDoState extends State<ToDo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColors().backgroundColor,
      floatingActionButton: Visibility(
        visible: show,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Add_Task(),
            ));
          },
          backgroundColor: Colors.green.shade200,
          child: Icon(Icons.add, size: 30),
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
              SizedBox(
                height: 200, // Ajusta la altura según sea necesario
                child: StreamNote(false, widget.userId),
              ),
              Text(
                'isDone',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 200, // Ajusta la altura según sea necesario
                child: StreamNote(true, widget.userId),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
