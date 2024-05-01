import 'package:flutter_guid/flutter_guid.dart';

class Land {
  final Guid id;
  final int size;
  final String location;
  final Guid? planted_id;
  final Guid? owner_id;
  final double longitude;
  final double latitude;

  Land(
      {required this.id,
      required this.size,
      required this.location,
      required this.planted_id,
      required this.owner_id,
      required this.longitude,
      required this.latitude});

  static Land fromJson(item) {
    return Land(
      id: Guid(item['id']),
      size: item['size'],
      location: item['location'],
      planted_id: item['planted_id'] != null ? Guid(item['planted_id']) : null,
      owner_id: item['owner_id'] != null ? Guid(item['owner_id']) : null,
      longitude: item['longitude'],
      latitude: item['latitude'],
    );
  }

  static Map<String, dynamic> toJson(Land land){
    return {
       "id": land.id.value,
       "size": land.size,
       "location": land.location,
       "planted_id": land.planted_id,
       "owner_id": land.owner_id,
       "longitude": land.longitude,
       "latitude": land.latitude
     };
  }
}
