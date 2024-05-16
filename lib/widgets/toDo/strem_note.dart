import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/models/task.dart';
import 'package:flutter_application_huerto/service/task_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'task_widget.dart';

class StreamNote extends StatefulWidget {
  final bool done;
  final Guid userId;
  final VoidCallback onTaskStatusChanged; // Añadido para recibir el callback

  StreamNote(this.done, this.userId, this.onTaskStatusChanged, {Key? key})
      : super(key: key);

  @override
  State<StreamNote> createState() => _StreamNoteState();
}

class _StreamNoteState extends State<StreamNote> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Task>>(
      stream: TaskSupabase().stream(widget.userId, widget.done),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Container(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Ordenar las tareas por prioridad y luego por fecha de creación dentro de cada prioridad
        final tasksList = snapshot.data!
          ..sort((a, b) {
            // Definir el orden de prioridad: rojo (0) -> amarillo (1) -> verde (2)
            final priorityOrder = {0: 0, 1: 1, 2: 2};
            // Primero, ordenar por prioridad según la prioridad definida
            final priorityComparison = priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
            if (priorityComparison != 0) {
              return priorityComparison;
            }
            // Si las prioridades son iguales, ordenar por fecha de creación (de más reciente a más antigua)
            return b.creation_date.compareTo(a.creation_date);
          });

        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final task = tasksList[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                TaskSupabase().deleteTask(task.id);
                setState(() {
                  tasksList.removeAt(index);
                });
                // Actualiza el stream después de eliminar una tarea
              },
              child: TaskWidget(
                task,
                widget.onTaskStatusChanged, // Pasar el callback aquí
              ),
            );
          },
          itemCount: tasksList.length,
        );
      },
    );
  }
}