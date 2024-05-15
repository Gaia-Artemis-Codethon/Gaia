import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_huerto/pages/chat/custom_chat_theme.dart';
import 'package:flutter_application_huerto/service/chat_supabase.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

import '../../models/chat.dart';
import '../../service/supabaseService.dart';

class ChatPage extends StatefulWidget{
  final Guid postId;
  final Guid client;
  final Guid seller;
  const ChatPage({super.key,required this.postId, required this.client, required this.seller});

  @override
  _ChatPageState createState() => _ChatPageState();

}

  class _ChatPageState extends State<ChatPage> {
    late List<types.Message> _messages = [];
    late Guid _postId;
    late Guid _clientId;
    late Guid _sellerId;
    late types.User _client;
    late types.User _seller;

    @override
    void initState() {
      super.initState();
      _postId = widget.postId;
      _clientId = widget.client;
      _sellerId = widget.seller;
      _client = types.User(id: widget.client.value);
      _seller = types.User(id: widget.seller.value);
      _messages = [];
      _loadMessages();
      build(context);
    }

    void _loadMessages() async {
      ChatSupabase cs = new ChatSupabase();
      //ChatDto? data = await cs.getChatMessagesFromRoomAndUsers(_postId, _clientId, _sellerId);
      ChatDto? data = await cs.getChatMessagesFromRoomAndUsers(Guid('dff6ea21-e5a9-4331-ab3d-c10a714cd63f')
          , Guid('70ee2b58-108b-4d5e-a40f-322eca2e2415')
        , Guid('a9a7d6a8-95e7-41b9-b580-ccfb171b6828'));
      print(data);
      if(data==null){return;}
      ChatDto chatDao = data!;
      final message = types.Message.fromJson(jsonDecode(chatDao.messages) as Map<String, dynamic>);
      final List<types.Message> messages = [message];
      messages.forEach((element) {print(element);});
      setState(() {
        _messages = messages;
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: _client != null && _seller != null
          ? Chat(
          messages: _messages, onSendPressed: _handleSendPressed, user: _client, theme: GaiaChatTheme(),)
          : CircularProgressIndicator()
      );
    }

    void _handleSendPressed(types.PartialText message) {
      final textMessage = types.TextMessage(
        author: _client,
        createdAt: DateTime
            .now()
            .millisecondsSinceEpoch,
        id: '525d9a72-c93f-40e1-8f5d-77cb826e62fe',
        text: message.text,
        //roomId: _postId+_client+_seller
      );
      _addMessage(textMessage);
    }

    void _addMessage(types.Message message) {
      setState(() {
        _messages.insert(0, message);
      });
      ChatSupabase cs = new ChatSupabase();
      cs.insertMessage(_postId, _clientId, _sellerId, message);
    }
  }