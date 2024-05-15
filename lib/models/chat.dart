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
    // var messageJson = json[0]['messages'];
    //
    // messages.author= types.User(id: Guid(messageJson['author']['id']).value);
    // messages.createdAt= messageJson['createdAt'];
    // messages.id= Guid(messageJson['id']);
    // messages.text= messageJson['text'];
    // messages.type= messageJson['type'];

    return ChatDto(
      id: Guid(json[0]['id']),
      client: Guid(json[0]['client']),
      seller: Guid(json[0]['seller']),
      messages: json[0]['messages']
      //messages: Map<int, String>.from(json['messages']),
    );
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
