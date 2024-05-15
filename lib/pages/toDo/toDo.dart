// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/models/task.dart';
import 'package:flutter_application_huerto/pages/home_page.dart';
import 'package:flutter_application_huerto/pages/map/mapPage.dart';
import 'package:flutter_application_huerto/pages/plant/userPlants.dart';
import 'package:flutter_application_huerto/pages/toDo/add_task.dart';
import 'package:flutter_application_huerto/service/task_supabase.dart';
import 'package:flutter_application_huerto/shared/bottom_navigation_bar.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/strem_note.dart';

class ToDo extends StatefulWidget {
  final Guid userId;

  const ToDo(this.userId, {Key? key}) : super(key: key);

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  late Stream<List<Task>> _pendingTasksStream;
  late Stream<List<Task>> _completedTasksStream;
  int _currentIndex = 1;

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
          automaticallyImplyLeading: false,
          backgroundColor: OurColors().backgroundColor,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: OurColors().primaryButton,
            tabs: [
              Tab(
                child: Text(
                  'To Do',
                  style: TextStyle(color: OurColors().primeWhite, fontSize: 20),
                ),
              ),
              Tab(
                child: Text(
                  'Done',
                  style: TextStyle(color: OurColors().primeWhite, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ClipOval(
          child: Material(
            color: OurColors().primeWhite, // Button color
            child: InkWell(
              splashColor: Colors.white, // Splash color
              child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(Icons.add, size: 35, color: Colors.white)),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Add_Task(widget.userId, updateTasks),
                ));
              },
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList(false),
            _buildTaskList(true),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          onTap: (index) {
            if (index != _currentIndex) {
              setState(() {
                _currentIndex = index;
              });
              if (_currentIndex == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(widget.userId),
                  ),
                );
              } else if (_currentIndex == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserPlants(widget.userId),
                  ),
                );
              } else if (_currentIndex == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(widget.userId),
                  ),
                );
              }
            }
          },
          currentIndex: _currentIndex,
        ),
      ),
    );
  }

  Widget _buildTaskList(bool completed) {
    return Padding(
      padding:
          //ajustamos el padding respecto las tarjetas desde aqui
          const EdgeInsets.fromLTRB(2, 19.0, 2, 0),
      // Ajuste del padding
      child: StreamBuilder<List<Task>>(
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
      ),
    );
  }

  Widget _emptyTask() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 117),
          Image.asset(
            'images/junimo.png',
            width: 200,
            height: 200,
          ),
          Text(
            'Don\'t you have tasks to do?',
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
