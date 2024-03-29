import 'package:flutter_guid/flutter_guid.dart';

class Community {
  final Guid id;
  final String name;

  Community({required this.id, required this.name});

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
