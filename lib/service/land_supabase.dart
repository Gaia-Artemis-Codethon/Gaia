import 'package:flutter_application_huerto/models/land.dart';
import 'supabaseService.dart';
import 'package:flutter_guid/flutter_guid.dart';

class LandSupabase {
 final client = SupabaseService().client;

 Future<List<Land>> readLands() async {
    try {
      final response = await client.from("Land").select();
      final data = response as List;
      return data.map((item) => Land(
        id: Guid(item['id']),
        size: item['size'],
        location: item['location'],
        planted_id: item['planted_id'] != null ? Guid(item['planted_id']) : null,
        owner_id: item['owner_id'] != null ? Guid(item['owner_id']) : null,
        longitude: item['longitude'],
        latitude: item['latitude'],
      )).toList();
    } catch (e) {
      print('Error al leer datos: $e');
      return [];
    }
 }
}