import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/main.dart';
import 'package:flutter_application_huerto/models/task.dart';
import 'package:flutter_application_huerto/service/task_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';
import '../pages/toDo/edit_toDo.dart';

class TaskWidget extends StatefulWidget {
  final Task note;
  final VoidCallback onTaskStatusChanged; // Nuevo argumento para el callback

  const TaskWidget(this.note, this.onTaskStatusChanged, {super.key});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    bool isDone = widget.note.status;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // ignore: prefer_const_constructors
          image: DecorationImage(
            image: const AssetImage(
                'images/tarjeta.png'), // Imagen de textura de madera
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 17),
                          child: Text(
                            widget.note.name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Checkbox(
                            activeColor: Colors.green.shade200,
                            value: isDone,
                            onChanged: (value) async {
                              setState(() {
                                isDone = !isDone;
                              });
                              await TaskSupabase().taskIsDone(Task(
                                  id: widget.note.id,
                                  status: isDone,
                                  name: widget.note.name,
                                  user_id: widget.note.user_id));
                              widget.onTaskStatusChanged();
                            },
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    editTime(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget editTime() {
    return Padding(
      padding: const EdgeInsets.only(
          bottom:
              17), // Agregado para espacio entre los GestureDetectors y el borde inferior
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            direction: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: () async {
                  await TaskSupabase().deleteTask(widget.note.id);
                  widget.onTaskStatusChanged();
                },
                child: Container(
                  width: 130,
                  height: 45,
                  child: Stack(
                    children: [
                      Image.asset(
                        'images/boton.png',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        left: 30, // Ajusta esta coordenada según tu necesidad
                        top: 14, // Ajusta esta coordenada según tu necesidad
                        child: Text(
                          'Eliminar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF94B57C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditToDo(
                      widget.note,
                      userId!,
                      widget.onTaskStatusChanged,
                    ),
                  ));
                },
                child: Container(
                  width: 130,
                  height: 45,
                  child: Stack(
                    children: [
                      Image.asset(
                        'images/boton.png',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        left: 39, // Ajusta esta coordenada según tu necesidad
                        top: 14, // Ajusta esta coordenada según tu necesidad
                        child: Text(
                          'Editar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF94B57C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
