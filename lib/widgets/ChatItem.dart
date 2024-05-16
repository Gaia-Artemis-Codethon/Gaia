import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_huerto/service/user_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';

import '../const/colors.dart';
import '../models/chat.dart';
import '../models/market.dart';
import '../pages/chat/chat.dart';
import '../service/chat_supabase.dart';
import '../service/market_supabase.dart';

class ChatItem extends StatefulWidget {
  final ChatDto chatDto;
  final Market marketPost;
  final Guid userId;
  final VoidCallback onChatStatusChanged;

  ChatItem(this.onChatStatusChanged,
      {required this.chatDto,
      required this.marketPost,
      required this.userId});

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this post?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                await ChatSupabase().deleteChatRoomById(widget.chatDto.id);
                widget.onChatStatusChanged();
                Navigator.of(context).pop();
                //añade aqui el codigo
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: OurColors().sectionBorder, // Set the border color here
          width: 3.0, // Set the border width here
        ),
        borderRadius: BorderRadius.circular(15.0), // Set the border radius here
      ),
      elevation: 3,
      surfaceTintColor: OurColors().sectionBackground,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                          'images/user.png'), // Specify your image path here
                    ),
                    Text(
                      'Yourself',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                    width:
                        24), // Increased width to move the 'Yourself' avatar right
                Icon(Icons.chevron_right),
                SizedBox(width: 12), // Added to move the arrow icon left
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                          'images/farmer-avatar.png'), // Specify your image path here
                    ),
                    Text(
                      'Client',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Visibility(
                      visible: true,
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: _showDeleteConfirmationDialog,
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                postId: widget.marketPost.id,
                                client: widget.chatDto.client,
                                seller: widget.marketPost.user,
                                userId: widget.userId,
                              ),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            OurColors().sectionBackground,
                          ),
                        ),
                        child: Icon(
                          Icons.message,
                          color: OurColors().primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
