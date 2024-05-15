import 'dart:convert';

import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatDto {
  final Guid id;
  final Guid client;
  final Guid seller;
  final String messages;
  //final Map<int, String> messages; //UserA sends odd and UserB sends even

  ChatDto({
    required this.id,
    required this.client,
    required this.seller,
    required this.messages,
  });

  static ChatDto fromJson(json) {


    return ChatDto(
      id: Guid(json[0]['id']),
      client: Guid(json[0]['client']),
      seller: Guid(json[0]['seller']),
      messages: json[0]['messages']

    );
  }

  static List<ChatDto> fromJsonList(List<dynamic> jsonList) {
    List<ChatDto> chatList = [];

    for (var json in jsonList) {
      ChatDto chatDto = ChatDto(
        id: Guid(json['id']),
        client: Guid(json['client']),
        seller: Guid(json['seller']),
        messages: json['messages'],
      );

      chatList.add(chatDto);
    }

    return chatList;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'client': client.toString(),
      'seller': seller.toString(),
      'messages': messages,
    };
  }
}
