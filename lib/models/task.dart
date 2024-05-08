import 'package:flutter_guid/flutter_guid.dart';

class Task {
  final Guid id;
  final String name;
  final bool status;
  final String? description; // Nueva propiedad para la descripción de la tarea
  final Guid? user_id;
  final DateTime creation_date;

  Task({
    required this.id,
    required this.name,
    required this.status,
    this.description, // Parámetro opcional para la descripción de la tarea
    this.user_id,
    required this.creation_date
  });

  static Task fromJson(Map<String, dynamic> data) {
    return Task(
      id: Guid(data['id']),
      name: data['name'],
      status: data['status'],
      description: data['description'], // Obtener la descripción de los datos
      user_id: data['user_id'] == null ? null : Guid(data['user_id']),
      creation_date: DateTime.parse(data['creation_date']),
    );
  }

  static Map<String, dynamic> toJson(Task task) {
    return {
      "id": task.id.value,
      "name": task.name,
      "status": task.status,
      "description": task.description, // Agregar la descripción al mapa JSON
      "user_id": task.user_id == null ? null : task.user_id!.value,
      "creation_date": task.creation_date!.toIso8601String()
    };
  }
}
