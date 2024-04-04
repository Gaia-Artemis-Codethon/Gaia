import 'package:flutter_guid/flutter_guid.dart';

class Task {
  final Guid id;
  final String name;
  final bool status;
  final Guid? user_id;

  Task({required this.id, required this.name, required this.status, this.user_id});

  static fromJson(Map<String, dynamic> json){
    return Task(
      id: Guid(json['id']),
      name: json['name'],
      status: json['status'],
      user_id: json['user_id'] == null? null : Guid(json['user_id']),
    );
  }
}
