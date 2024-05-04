import 'package:flutter_guid/flutter_guid.dart';

class Community {
  final Guid id;
  final String name;

  Community({required this.id, required this.name});

  static Community fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'],
      name: json['name'],
    );
  }

  static Map<String, dynamic> toJson(Community data) {
    return {
      'id': data.id,
      'name': data.name,
    };
  }
}
