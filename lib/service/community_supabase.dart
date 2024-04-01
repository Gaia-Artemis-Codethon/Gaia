import 'package:flutter_application_huerto/models/community.dart';
import 'package:flutter_application_huerto/models/userLoged.dart';
import 'package:flutter_application_huerto/service/supabaseService.dart';
import 'package:flutter_application_huerto/service/user_supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';

class CommunitySupabase {
  final client = SupabaseService().client;

  Future<Community?> readCommunityById(Guid id) async {
    try {
      final data =
          await client.from("Community").select("*").eq("id", id.value);
      final community = Community(
          id: Guid(data[0]
              ['id']), // Asegúrate de convertir el ID a Guid si es necesario
          name: data[0][
              'name']); // Asegúrate de que 'community_id' es opcional y maneja el caso en que no esté presente

      return community;
    } catch (e) {
      print('Error al leer datos: $e');
      return null;
    }
  }

  Future<String?> readCommunityNameByUserCommunityId(Guid id) async {
    try {
      UserLoged user = await UserSupabase().getUserById(id) as UserLoged;
      final data = await client
          .from("Community")
          .select("name")
          .eq("id", user.community_id!.value);
      final name = data[0]['name'] as String;
      return name;
    } catch (e) {
      print('Error al leer datos: $e');
      return null;
    }
  }

  Future<void> addCommunityByNameAndId(Guid id, String communityName) async {
    try {
      // Crear un objeto Community con el nombre obtenido
      // Convertir el objeto Community a un Map para pasarlo a addData
      Map<String, dynamic> communityMap = {
        "id": id.value,
        "name": communityName
      };
      // Llamar a Supabase().addData con el Map de la comunidad
      await SupabaseService().addData("Community", communityMap);
    } catch (e) {
      print('Error al insertar datos: $e');
    }
  }
}
