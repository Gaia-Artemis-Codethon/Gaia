import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/main.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/crop.dart';
import 'supabaseService.dart';

class CropSupabase {
  final client = SupabaseService().client;

  Future<void> addCrop(Crop crop) async {
    try {
      Map<String, dynamic> cropMap = Crop.toJson(crop);
      // Llamar a Supabase().addData con el Map del cultivo
      await SupabaseService().addData("Crop", cropMap);
    } catch (e) {
      print('Error al insertar datos: $e');
    }
  }

  Future<Crop?> getCropById(Guid id) async {
    final data = await SupabaseService().readDataById("Crop", id.value);
    if (data.length == 0) {
      return null;
    } else {
      final crop = Crop.fromJson(data);
      return crop;
    }
  }
}
