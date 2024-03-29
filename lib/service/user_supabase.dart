import 'package:flutter_application_huerto/models/userLoged.dart';
import 'package:flutter_application_huerto/service/supabaseService.dart';
import 'package:flutter_guid/flutter_guid.dart';

class UserSupabase {
  final client = SupabaseService().client;

  Future<void> updateUser(Guid id, UserLoged newValue) async {
    Map<String, dynamic> newValues = {
      "id": id.value,
      "name": newValue.name,
      "email": newValue.email,
      "community_id": newValue.community_id!.value,
    };
    await SupabaseService().updateData("User", id.value, newValues);
  }

  Future<UserLoged> getUserById(Guid id) async {
    final data = await SupabaseService().readData("User", id.value);
    final user = UserLoged(
      id: Guid(data[0]['id']), // Asegúrate de convertir el ID a Guid si es necesario
      name: data[0]['name'],
      email: data[0]['email'],
      community_id: Guid(data[0]['community_id']), // Asegúrate de que 'community_id' es opcional y maneja el caso en que no esté presente
    );
    return user;
  }
}
