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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColors().backgroundColor,
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Hace que el AppBar sea transparente
        elevation: 0, // Elimina la sombra del AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black, // Color del ícono
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
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
              // Espacio entre el encabezado y la primera tarjeta
              const SizedBox(height: 20),
              // Encabezado "Is not done" con forma circular y color sugerido
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Ajustar el padding aquí
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3), // Color sugerido
                    borderRadius: BorderRadius.circular(20.0), // Forma circular
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    'Por hacer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Espacio entre el encabezado y la lista
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: StreamNote(false, widget.userId, updateTasks),
                ),
              ),
              // Separador "isDone"
              // Espacio entre el separador y la segunda lista
              const SizedBox(height: 10),
              // Encabezado "isDone" con forma circular y color sugerido
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Ajustar el padding aquí
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3), // Color sugerido
                    borderRadius: BorderRadius.circular(20.0), // Forma circular
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Hecho',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Espacio entre el encabezado y la segunda lista
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
      ),
    );
  }
}
