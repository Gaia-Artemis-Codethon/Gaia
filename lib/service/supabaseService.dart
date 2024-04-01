import 'package:flutter_guid/flutter_guid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static String supabaseUrl = "https://pxafmjqslgpswndqzfvm.supabase.co";
  static String supabaseKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB4YWZtanFzbGdwc3duZHF6ZnZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTAzNjYzNjIsImV4cCI6MjAyNTk0MjM2Mn0.xbGjWmYqPUO3i2g1_4tmE7sWhI_c9ymFqckSA_CaFOs";

  final client = Supabase.instance.client;

  Future<void> addData(String table, Map<String, dynamic> object) async {
    try {
      final data = await client.from(table).insert(object);
      print("Data added to supabase: $table");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<List<dynamic>> readData(String table) async {
    try {
      final data = await client.from(table).select();
      return data as List<dynamic>;
    } catch (e) {
      print('Error al leer datos: $e');
      return [];
    }
  }

  Future<dynamic> readDataById(String table, String id) async {
    try {
      final data = await client.from(table).select().eq("id", id);
      return data as List<dynamic>;
    } catch (e) {
      print('Error al leer datos: $e');
      return [];
    }
  }

  Future<void> updateData(
      String table, String id, Map<String, dynamic> newValues) async {
    final data = await client.from(table).update(newValues).eq('id', id);

    if (data != null) {
      print('Error al actualizar datos: ${data}');
    } else {
      print('Datos actualizados con éxito');
    }
  }

  Future<void> deleteData(String table, String id) async {
    final data = await client.from(table).delete().eq('id', id);

    if (data != null) {
      print('Error al eliminar datos: ${data}');
    } else {
      print('Datos eliminados con éxito');
    }
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final data = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error al iniciar sesión: $e');
    }
  }

  Future<Guid?> getUserId() async {
    try {
      final userId = client.auth.currentUser!.id;
      if (userId != null) {
        return Guid(userId);
      } else {
        throw Exception('No hay usuario autenticado');
      }
    } catch (e) {
      print('Error al obtener usuario: $e');
      return null;
    }
  }
}
