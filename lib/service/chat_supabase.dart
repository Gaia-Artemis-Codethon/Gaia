import 'package:flutter_application_huerto/service/supabaseService.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../models/chat.dart';



class ChatSupabase {
  final service = SupabaseService().client;

  Future<List<ChatDto>?> getChatMessagesFromRoomAndUsers(Guid postId, Guid clientId, Guid sellerId) async {
    try {
      final data =
      await service.from("ChatRooms").select("*").eq(
          "postId", postId.value).eq(
          "client", clientId).eq(
          "seller", sellerId);

      return ChatDto.fromJsonList(data);
    } catch (e) {
      print('Error en clase chat_supabase al leer datos: $e');
      return null;
    }
  }

  Future<List<ChatDto>?> getRoomsFromPost(Guid postId, Guid sellerId) async{
    try {
      final data =
      await service.from("ChatRooms").select("*").eq(
          "postId", postId.value).eq(
          "seller", sellerId);

      return ChatDto.fromJsonList(data);
    } catch (e) {
      print('Error en clase chat_supabase al leer rooms: $e');
      return null;
    }
  }

  Future<bool> insertMessage(Guid postId, Guid clientId, Guid sellerId, types.Message messages) async {
    try {
      String id = await checkNewChat(postId,clientId,sellerId);
      if(id.isEmpty || id==null){
        Map<String, dynamic> newData =
        {
          'id': Guid.newGuid.value,
          'postId': postId.value,
          'client': clientId.value,
          'seller': sellerId.value,
          'messages': messages,
        };
        await SupabaseService().addData("ChatRooms",newData);
        return true;
      }else{
        Map<String, dynamic> newData =
        {
          'id': Guid.newGuid.value,
          'postId': postId.value,
          'client': clientId.value,
          'seller': sellerId.value,
          'messages': messages,
        };
        await SupabaseService().addData("ChatRooms",newData);
        return true;
      }
    } catch (e) {
      print('Error en clase chat_supabase al insertar mensaje: $e');
      return false;
    }
  }

  Future<String> checkNewChat(Guid postId, Guid clientId, Guid sellerId) async{
    try {
      final data =
      await service.from("ChatRooms").select("*").eq(
          "postId", postId.value).eq(
          "client", clientId).eq(
          "seller", sellerId);

      if (data.isEmpty) {
        return "";
      } else {
        return ChatDto.fromJson(data).id.value;
      }
    } catch (e) {
      print('Error en clase chat_supabase al comprobar si es primer mensaje: $e');
      return "";
    }
  }
}
