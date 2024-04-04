import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/models/task.dart';
import 'package:flutter_application_huerto/service/task_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'task_widget.dart';

class StreamNote extends StatefulWidget {
 final bool done;
 final Guid userId;
 final VoidCallback onTaskStatusChanged; // Añadido para recibir el callback

 StreamNote(this.done, this.userId, this.onTaskStatusChanged, {Key? key}) : super(key: key);

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
          return CircularProgressIndicator();
        }
        final tasksList = snapshot.data!;
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
              child: Task_Widget(task, widget.onTaskStatusChanged), // Pasa el callback aquí
            );
          },
          itemCount: tasksList.length,
        );
      },
    );
 }
}


