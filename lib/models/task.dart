import 'package:flutter_guid/flutter_guid.dart';

class Task {
  final Guid id;
  final String name;
  final bool status;
  final Guid? user_id;

  Task(
      {required this.id,
      required this.name,
      required this.status,
      this.user_id});

  static Task fromJson(Map<String, dynamic> data) {
    return Task(
        id: Guid(data['id']),
        name: data['name'],
        status: data['status'],
        user_id: data['user_id'] == null ? null : Guid(data['user_id']));
  }

  static Map<String, dynamic> toJson(Task task) {
    return {
      "id": task.id.value,
      "name": task.name,
      "status": task.status,
      "user_id": task.user_id == null ? null : task.user_id!.value,
    };
  }
}
