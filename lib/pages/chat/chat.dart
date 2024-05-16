import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_huerto/models/userLoged.dart';
import 'package:flutter_application_huerto/pages/chat/custom_chat_theme.dart';
import 'package:flutter_application_huerto/service/chat_supabase.dart';
import 'package:flutter_application_huerto/service/user_supabase.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

import '../../const/colors.dart';
import '../../models/Auth.dart';
import '../../models/chat.dart';
import '../../service/supabaseService.dart';

class ChatPage extends StatefulWidget {
  final Guid postId;
  final Guid client;
  final Guid seller;
  final Guid userId;
  const ChatPage(
      {super.key,
      required this.postId,
      required this.client,
      required this.seller,
      required this.userId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String clientName = '';
  late List<types.Message> _messages = [];
  late Guid _postId;
  late Guid _clientId;
  late Guid _sellerId;
  late types.User _client;
  late types.User _seller;
  late Auth session;

  @override
  void initState() {
    session = Auth();
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
    if (_sellerId == widget.userId) {
      UserLoged? user = await UserSupabase().getUserById(_clientId);
      clientName = user!.name;
    } else {
      UserLoged? user = await UserSupabase().getUserById(_sellerId);
      clientName = user!.name;
    }

    ChatSupabase cs = new ChatSupabase();
    //ChatDto? data = await cs.getChatMessagesFromRoomAndUsers(_postId, _clientId, _sellerId);
    List<ChatDto>? data =
        await cs.getChatMessagesFromRoomAndUsers(_postId, _clientId, _sellerId);
    if (data == null) {
      return;
    }
    List<ChatDto> chatDao = data!;
    List<types.Message> messages = [];

    setState(() {
      for (ChatDto chatDto in data) {
        var message = types.Message.fromJson(
            jsonDecode(chatDto.messages) as Map<String, dynamic>);
        //if(message.author!=_client){message.author=_seller;}
        //messages.add(message);
        _messages.insert(0, message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text('Chat with ${clientName}'),
          elevation: 1,
          backgroundColor: OurColors().sectionBackground,
        ),
        body: _client != null && _seller != null
            ? Chat(
                messages: _messages,
                onSendPressed: _handleSendPressed,
                user: types.User(id: session.id.value),
                theme: GaiaChatTheme(),
              )
            : CircularProgressIndicator());
  }

  void _handleSendPressed(types.PartialText message) {
    print(session.username);
    final textMessage = types.TextMessage(
        author: types.User(id: session.id.value),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: message.text,
        roomId: _postId.value + _clientId.value + _sellerId.value);
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
