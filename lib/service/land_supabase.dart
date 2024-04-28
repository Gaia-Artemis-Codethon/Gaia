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

 Future<Land?> getLandsByUserId(Guid userId) async {
   try {
     final data = await client.from("Land")
         .select()
         .eq('user_id', userId.value);

     if(data.isEmpty) {
       return null;
     } else {
       final land = Land(
         id: Guid(data[0]['id']),
         size: data[0]['size'],
         location: data[0]['location'],
         planted_id: data[0]['planted_id'],
         owner_id: data[0]['owner_id'],
         longitude: data[0]['longitude'],
         latitude: data[0]['latitude']
       );

       return land;
     }
   } catch (e) {
     print('Error en clase land_supabase al leer datos: $e');
     return null;
   }
 }

 Future<void> addLand(Land land) async {
   try {
     Map<String, dynamic> landMap = {
       "id": land.id.value,
       "size": land.size,
       "location": land.location,
       "planted_id": land.planted_id,
       "owner_id": land.owner_id,
       "longitude": land.longitude,
       "latitude": land.latitude
     };

     await SupabaseService().addData("Land", landMap);
   } catch (e) {
     print('Error al insertar datos: $e');
   }
 }
}