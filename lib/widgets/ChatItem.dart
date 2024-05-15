import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../models/chat.dart';
import '../models/market.dart';
import '../pages/chat/chat.dart';

class ChatItem extends StatelessWidget {
  final ChatDto chatDto;
  final Market marketPost;

  ChatItem({required this.chatDto, required this.marketPost});

  void _showModifyPostDialog(BuildContext context, ChatDto chatDto) {
    TextEditingController titleController =
        TextEditingController(text: marketPost.title);
    TextEditingController descriptionController =
        TextEditingController(text: marketPost.description);

    bool isTitleEmpty = false; // Set to false because title is pre-filled
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
                      marketPost.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        marketPost.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        marketPost.description ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Visibility(
                      visible: true,
                        child: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          child: Text('Delete'),
                          value: 'Delete',
                        ),
                      ],
                      onSelected: (value) async {
                        if (value == 'Delete') {
                          // await MarketSupabase()
                          //     .deleteMarketPostById(marketPost.id);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         MarketPage(marketPost.community, userId),
                          //   ),
                          // );
                        } else {
                          return;
                        }
                      },
                    ),),
                    Visibility(
                      visible: true,
                      child: ElevatedButton(
                        onPressed: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(postId: marketPost.id, client: chatDto.client, seller: marketPost.user),
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