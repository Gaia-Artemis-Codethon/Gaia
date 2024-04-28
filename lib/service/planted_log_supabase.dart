import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/main.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/planted.dart';
import '../models/planted_log.dart';
import '../models/crop.dart';
import 'supabaseService.dart';

class PlantedLogSupabase{
  final client = SupabaseService().client;

  Future<void> addPlantLog(PlantedLog plantLog) async {
    try {
      Map<String, dynamic> plantLogMap = {
        "id": plantLog.id.value,
        "user_id": plantLog.user_id.value,
        "planted_id": plantLog.planted_id.value,
        "name": plantLog.name,
        "description": plantLog.description,
        "date": plantLog.date.toIso8601String()
      };
      // Llamar a Supabase().addData con el Map del cultivo
      await SupabaseService().addData("Planted_log", plantLogMap);
      print('Añadido');
    } catch (e) {
      print('Error al insertar datos: $e');
    }
  }

  Future<PlantedLog?> getPlantedLogById(Guid id) async {
    final data = await SupabaseService().readDataById("Planted_log", id.value);
    if (data.length == 0) {
      return null;
    } else {
      final plant = PlantedLog(
        id: Guid(data[0]['id']),
        user_id: data[0]['user_id'],
        planted_id: data[0]['planted_id'],
        name: data[0]['name'],
        description: data[0]['desription'],
        date: data[0]['date']
      );
      return plant;
    }
  }

  Stream<List<PlantedLog>> getPlantedLogByUserId(Guid user_id) {
    return client
        .from('Planted_log')
        .select()
        .eq('user_id', user_id.value)
        .asStream()
        .map((event) => event as List<Map<String, dynamic>>)
        .map((list) => list.map((item) => PlantedLog.fromJson(item) as PlantedLog).toList());
  }
}