import 'package:flutter_guid/flutter_guid.dart';

class Land {
  final Guid id;
  final int size;
  final String location;
  final Guid? planted_id;
  final Guid? owner_id;
  final double longitude;
  final double latitude;

  Land({required this.id, required this.size, required this.location, required this.planted_id, required this.owner_id, required this.longitude, required this.latitude});
}
