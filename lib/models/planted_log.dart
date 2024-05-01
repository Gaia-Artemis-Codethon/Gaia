import 'package:flutter_guid/flutter_guid.dart';

class PlantedLog {
  final Guid id;
  final Guid user_id;
  final Guid planted_id;
  final String name;
  final String description;
  final DateTime date;

  PlantedLog(
      {required this.id,
      required this.user_id,
      required this.planted_id,
      required this.name,
      required this.description,
      required this.date});

  static PlantedLog fromJson(Map<String, dynamic> data) {
    return PlantedLog(
        id: Guid(data[0]['id']),
        user_id: data[0]['user_id'],
        planted_id: data[0]['planted_id'],
        name: data[0]['name'],
        description: data[0]['desription'],
        date: data[0]['date']
      );
  }

  static Map<String, dynamic> toJson(PlantedLog plantLog) {
    return {
        "id": plantLog.id.value,
        "user_id": plantLog.user_id.value,
        "planted_id": plantLog.planted_id.value,
        "name": plantLog.name,
        "description": plantLog.description,
        "date": plantLog.date.toIso8601String()
      };
  }
}
