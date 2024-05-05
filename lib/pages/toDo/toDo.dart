import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
  bool showFloatingButton = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColors().backgroundColor,
      appBar: AppBar(
        backgroundColor: OurColors().backgroundColor,
        // Hace que el AppBar sea transparente
        elevation: 0, // Elimina la sombra del AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black, // Color del ícono
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
            // Espacio entre el encabezado y la primera tarjeta
            const SizedBox(height: 20),
            // Encabezado "Is not done" con forma circular y color sugerido
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ), // Ajustar el padding aquí
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3), // Color sugerido
                  borderRadius: BorderRadius.circular(20.0), // Forma circular
                ),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                horizontal: 16.0,
              ), // Ajustar el padding aquí
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3), // Color sugerido
                  borderRadius: BorderRadius.circular(20.0), // Forma circular
                ),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
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
    );
  }

  void updateTasks() {
    setState(() {});
  }
}
