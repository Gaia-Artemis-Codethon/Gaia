// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_huerto/models/task.dart';
import 'package:flutter_application_huerto/pages/toDo/add_task.dart';
import 'package:flutter_application_huerto/service/task_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';

import '../../const/colors.dart';
import '../../widgets/strem_note.dart';

class ToDo extends StatefulWidget {
  final Guid userId;
  const ToDo(this.userId, {super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  bool showFloatingButton = true;
  late Stream<List<Task>> _tasksStream;

  @override
  void initState() {
    super.initState();
    _tasksStream = TaskSupabase().getPendingTasks(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColors().backgroundColor,
      appBar: AppBar(
        backgroundColor: OurColors().backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButton: ClipOval(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Add_Task(widget.userId, updateTasks),
            ));
          },
          backgroundColor: OurColors().primaryButton,
          child: const Icon(
            Icons.add,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 10, 77, 43).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(114, 2, 133, 70),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: Text(
                    'Por hacer',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Task>>(
                stream: _tasksStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return _emptyTask();
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: StreamNote(false, widget.userId, updateTasks),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 10, 77, 43).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(114, 2, 133, 70),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: Text(
                    'Hecho',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: StreamNote(true, widget.userId, updateTasks),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyTask() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Image.asset(
              'images/junimo.png',
              width: 200,
              height: 200,
            ),
          ),
          Text(
            '¿No tienes tareas por hacer?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void updateTasks() {
    setState(() {
      _tasksStream = TaskSupabase().getPendingTasks(widget.userId);
    });
  }
}
