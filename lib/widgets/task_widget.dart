import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/main.dart';
import 'package:flutter_application_huerto/models/task.dart';
import 'package:flutter_application_huerto/service/task_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';
import '../pages/toDo/edit_toDo.dart';

class Task_Widget extends StatefulWidget {
 final Task _note;
 Task_Widget(this._note, {Key? key}) : super(key: key);

 @override
 State<Task_Widget> createState() => _Task_WidgetState();
}

class _Task_WidgetState extends State<Task_Widget> {
 @override
 Widget build(BuildContext context) {
    bool isDone = widget._note.status;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
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
              const SizedBox(width: 25),
              Expanded(
                child:
                 Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget._note.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Checkbox(
                          activeColor: Colors.green.shade200,
                          value: isDone,
                          onChanged: (value) {
                            setState(() {
                              isDone = !isDone;
                            });
                            TaskSupabase()
                                .taskIsDone(Task(id: widget._note.id, status: isDone, name: widget._note.name, user_id: widget._note.user_id));
                          },
                        )
                      ],
                    ),
                    const Spacer(),
                    edit_time(),
                 ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
 }
 
 Widget edit_time() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Wrap( // Use Wrap instead of Row
        spacing: 8.0, // gap between adjacent widgets
        runSpacing: 4.0, // gap between lines
        direction: Axis.horizontal, // main axis (rows or columns)
        children: [
          GestureDetector(
            onTap: () {
              TaskSupabase().deleteTask(widget._note.id);
            },
            child: 
          Container(
            width: 90,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.green.shade200,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: Row(
                children: [
                 //Image.asset('images/icon_time.png'),
                ],
              ),
            ),
          ),
      ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditToDo(widget._note, userId!),
              ));
            },
            child: Container(
              width: 90,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xffE2F6F1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                 horizontal: 12,
                 vertical: 6,
                ),
                child: Row(
                 children: [
                    //Image.asset('images/icon_edit.png'),
                    SizedBox(width: 10),
                    Text(
                      'edit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                 ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
 }
}
