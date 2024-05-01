import 'package:flutter_application_huerto/models/land.dart';
import 'supabaseService.dart';
import 'package:flutter_guid/flutter_guid.dart';

class LandSupabase {
 final client = SupabaseService().client;

 Future<List<Land>> readLands() async {
    try {
      final response = await client.from("Land").select();
      final data = response as List;
      return data.map((item) => Land.fromJson(item)).toList();
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
       final land = Land.fromJson(data);

       return land;
     }
   } catch (e) {
     print('Error en clase land_supabase al leer datos: $e');
     return null;
   }
 }

 Future<void> addLand(Land land) async {
   try {
     Map<String, dynamic> landMap = Land.toJson(land);

     await SupabaseService().addData("Land", landMap);
   } catch (e) {
     print('Error al insertar datos: $e');
   }
 }
}