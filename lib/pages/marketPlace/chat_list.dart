import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/pages/chat/chat.dart';
import 'package:flutter_application_huerto/service/chat_supabase.dart';
import 'package:flutter_application_huerto/service/user_supabase.dart';
import 'package:flutter_application_huerto/widgets/ChatItem.dart';
import 'package:flutter_guid/flutter_guid.dart';

import '../../models/chat.dart';
import '../../models/market.dart';
import '../../models/userLoged.dart';
import '../../service/market_supabase.dart';

class ChatListPage extends StatefulWidget {
  final Market marketPost;
  final Guid clientId;

  ChatListPage({
    required this.marketPost,
    required this.clientId,
  });

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late Stream<List<ChatDto>?> _chatStream;
  @override
  void initState() {
    super.initState();
    _chatStream = Stream.fromFuture(ChatSupabase()
        .getRoomsFromPost(widget.marketPost.id, widget.marketPost.user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColors().backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('Post\'s chats'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<List<ChatDto>?>(
        stream: _chatStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 117),
                  Image.asset(
                    'images/junimo.png',
                    width: 200,
                    height: 200,
                  ),
                  Container(
                    width: 300,
                    child: const Text(
                      'You do not have any chat :(',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ChatItem(
                  chatDto: snapshot.data![index],
                  marketPost: widget.marketPost,
                  userId: widget.clientId,
                  updateChatList,
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> updateChatList() async {
    // Realizar la operación asíncrona fuera del setState
    List<ChatDto>? chatStream = await ChatSupabase()
        .getRoomsFromPost(widget.marketPost.id, widget.marketPost.user);

    // Actualizar el estado dentro de setState después de completar la operación asíncrona
    setState(() {
      _chatStream = Stream.value(chatStream);
    });
  }
}
