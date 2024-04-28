import 'package:flutter_guid/flutter_guid.dart';

class PlantedLog{
  final Guid id;
  final Guid user_id;
  final Guid planted_id;
  final String name;
  final String description;
  final DateTime date;

  PlantedLog({required this.id, required this.user_id, required this.planted_id, required this.name, required this.description, required this.date});

  static fromJson(Map<String, dynamic> json) {
    return PlantedLog(
        id: Guid(json['id']),
        user_id: Guid(json['user_id']),
        planted_id: Guid(json['planted_id']),
        name: json['name'],
        description: json['description'],
        date: json['date']
    );
  }
}