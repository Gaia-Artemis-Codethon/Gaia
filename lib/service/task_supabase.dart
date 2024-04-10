import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/main.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/task.dart';
import 'supabaseService.dart';

class TaskSupabase {
  final client = SupabaseService().client;

  Future<void> updateTask(Task task) async {
    Map<String, dynamic> newValues = {
      "id": task.id.value,
      "name": task.name,
      "status": task.status,
      "user_id": task.user_id == null ? null : task.user_id!.value,
    };
    await SupabaseService().updateData("Task", task.id.value, newValues);
  }

  List<Task> getTasks(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    try {
      final notesList = snapshot.data!.map((doc) {
        final data = doc as Map<String, dynamic>;
        return Task(
            id: Guid(data['id']),
            name: data['name'],
            status: data['status'],
            user_id: data['user_id'] == null ? null : Guid(data['user_id']));
      }).toList();
      return notesList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> addTask(Task task) async {
    try {
      // Crear un objeto Community con el nombre obtenido
      // Convertir el objeto Community a un Map para pasarlo a addData
      Map<String, dynamic> taskMap = {
        "id": task.id.value,
        "name": task.name,
        "status": task.status,
        "user_id": task.user_id == null ? null : task.user_id!.value,
      };
      // Llamar a Supabase().addData con el Map de la comunidad
      await SupabaseService().addData("Task", taskMap);
    } catch (e) {
      print('Error al insertar datos: $e');
    }
  }

  Future<void> deleteTask(Guid id) async {
    await SupabaseService().deleteData("Task", id.value);
  }

  Future<bool> taskIsDone(Task task) async {
    Map<String, dynamic> newValues = {
      "id": task.id.value,
      "name": task.name,
      "status": task.status,
      "user_id": task.user_id == null ? null : task.user_id!.value,
    };
    await SupabaseService().updateData("Task", task.id.value, newValues);
    return task.status;
  }

  Stream<List<Task>> getCompletedTasks(Guid userId) {
    return client
        .from('Task')
        .select()
        .eq('user_id', userId.value)
        .eq('status', 'true')
        .asStream()
        .map((event) => event as List<Map<String, dynamic>>)
        .map(
            (list) => list.map((item) => Task.fromJson(item) as Task).toList());
  }

  Stream<List<Task>> getPendingTasks(Guid userId) {
    return client
        .from('Task')
        .select()
        .eq('user_id', userId.value)
        .eq('status', 'false')
        .asStream()
        .map((event) => event as List<Map<String, dynamic>>)
        .map(
            (list) => list.map((item) => Task.fromJson(item) as Task).toList());
  }

  Stream<List<Task>> stream(Guid userId, bool status) {
    return client
        .from('Task')
        .select('*')
        .eq('user_id', userId.value)
        .eq('status', '$status')
        .asStream()
        .map((event) => event as List<Map<String, dynamic>>)
        .map((list) => list.map((item) => Task.fromJson(item) as Task).toList())
        .map((tasks) {
      // Verifica si la lista de tareas está vacía después de la eliminación
      if (tasks.isEmpty) {
        // Si está vacía, emite una lista vacía
        return <Task>[];
      } else {
        // Si no está vacía, devuelve la lista de tareas
        return tasks;
      }
    });
  }
}
