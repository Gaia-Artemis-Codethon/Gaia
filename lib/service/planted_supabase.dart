import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/main.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/planted.dart';
import '../models/planted_log.dart';
import '../models/crop.dart';
import 'supabaseService.dart';

class PlantedSupabase {
  final client = SupabaseService().client;

  Future<void> addPlant(Planted plant) async {
    try {
      Map<String, dynamic> plantMap = Planted.toJson(plant);
      // Llamar a Supabase().addData con el Map del cultivo
      await SupabaseService().addData("Planted", plantMap);
    } catch (e) {
      print('Error al insertar datos: $e');
    }
  }

  Future<Planted?> getPlantedById(Guid id) async {
    final data = await SupabaseService().readDataById("Planted", id.value);
    if (data.length == 0) {
      return null;
    } else {
      final plant = Planted.fromJson(data);
      return plant;
    }
  }

  Stream<List<Planted>> getPlantedByLandId(Guid land_id) {
    return client
        .from('Planted')
        .select()
        .eq('land_id', land_id.value)
        .asStream()
        .map((event) => event as List<Map<String, dynamic>>)
        .map((list) =>
            list.map((item) => Planted.fromJson(item) as Planted).toList());
  }

  Future<List<Map<String, dynamic>>> getPlantedByUserId(Guid user_id) async {
    print('Receiving');

    final response =
        await client.from('Planted').select().eq('user_id', user_id.value);

    print(response.toString());

    return response;
  }

  Future<void> deletePlantedById(Guid id) async {
    await SupabaseService().deleteData("Planted", id.value);
  }
}
