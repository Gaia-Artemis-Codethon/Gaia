import 'package:flutter_application_huerto/models/community.dart';
import 'package:flutter_application_huerto/service/supabase.dart';
import 'package:supabase/supabase.dart';

class CommunitySupabase {
  final client = Supabase().client;

  Future<dynamic> readCommunityById(String id) async {
    try {
      print("readCommunityById");
      final data = await client.from("Community").select("*").eq("id", id);
      return data as dynamic;
    } catch (e) {
      print('Error al leer datos: $e');
      return null;
    }
  }

  Future<void> addCommunityByName(String communityName) async {
      try {
        print("addCommunityByName");
        // Crear un objeto Community con el nombre obtenido
        // Convertir el objeto Community a un Map para pasarlo a addData
        Map<String, dynamic> communityMap = {"name": communityName};
        // Llamar a Supabase().addData con el Map de la comunidad
        await Supabase().addData("Community", communityMap);
      } catch (e) {
        print('Error al insertar datos: $e');
      }
    }
}
