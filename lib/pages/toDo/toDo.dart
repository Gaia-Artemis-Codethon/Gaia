// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_huerto/models/task.dart';
import 'package:flutter_application_huerto/pages/plant/userPlants.dart';
import 'package:flutter_application_huerto/pages/toDo/add_task.dart';
import 'package:flutter_application_huerto/service/task_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../const/colors.dart';
import '../../widgets/strem_note.dart';
import '../home_page.dart';
import '../map/mapPage.dart';

class ToDo extends StatefulWidget {
  final Guid userId;
  const ToDo(this.userId, {super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  late Stream<List<Task>> _pendingTasksStream;
  late Stream<List<Task>> _completedTasksStream;

  @override
  void initState() {
    super.initState();
    _pendingTasksStream = TaskSupabase().getPendingTasks(widget.userId);
    _completedTasksStream = TaskSupabase().getCompletedTasks(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          bottom: TabBar(
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'Por hacer'),
              Tab(text: 'Hecho'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
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
        body: TabBarView(
          children: [
            _buildTaskList(false),
            _buildTaskList(true),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: SvgPicture.asset(
                "images/mapa.svg",
                width: 30,
                height: 30,
                color: OurColors().primaryButton,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(widget.userId),
                  ),
                );
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                "images/todo.svg",
                width: 30,
                height: 30,
                color: OurColors().primaryButton,
              ),
              onPressed: () {
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                "images/planta.svg",
                width: 30,
                height: 30,
                color: OurColors().primaryButton,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserPlants(widget.userId),
                  ),
                );
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                "images/mapa.svg",
                width: 30,
                height: 30,
                color: OurColors().primaryButton,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(widget.userId),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildTaskList(bool completed) {
    return StreamBuilder<List<Task>>(
      stream: completed ? _completedTasksStream : _pendingTasksStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return _emptyTask();
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: StreamNote(
              completed,
              widget.userId,
              updateTasks,
            ),
          );
        }
      },
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
      _pendingTasksStream = TaskSupabase().getPendingTasks(widget.userId);
      _completedTasksStream = TaskSupabase().getCompletedTasks(widget.userId);
    });
  }
}
