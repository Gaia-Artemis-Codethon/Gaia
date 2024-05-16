import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';

import '../../const/colors.dart';
import '../../models/market.dart';
import '../../pages/chat/chat.dart';
import '../../pages/marketPlace/chat_list.dart';
import '../../pages/marketPlace/marketPlace.dart';
import '../../service/market_supabase.dart';

class MarketCard extends StatelessWidget {
  final Market marketPost; // Each post of the market, note that they also have
  //  user property, which contains id of the poster
  final Guid userId; // userId of the own user

  MarketCard({required this.marketPost, required this.userId});

  void _showModifyPostDialog(BuildContext context, Market marketPost) {
    TextEditingController titleController =
        TextEditingController(text: marketPost.title);
    TextEditingController descriptionController =
        TextEditingController(text: marketPost.description);

    bool isTitleEmpty = false; // Set to false because title is pre-filled

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Modify Post'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    onChanged: (value) {
                      setState(() {
                        isTitleEmpty = value.isEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: OurColors().primaryBorderColor),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: OurColors().primaryBorderColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: OurColors().primaryBorderColor),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: OurColors().primaryBorderColor),
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: isTitleEmpty
                      ? null
                      : () {
                          String title = titleController.text;
                          String description = descriptionController.text;
                          // You also need to pass the marketPost.id to identify which post to modify
                          MarketSupabase().updateMarketPostById(
                              marketPost.id,
                              Market(
                                  id: marketPost.id,
                                  user: marketPost.user,
                                  title: title,
                                  community: marketPost.community,
                                  description: description,
                                  username: marketPost.username));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MarketPage(marketPost.community, userId),
                            ),
                          );
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      isTitleEmpty ? Colors.grey : OurColors().primaryButton,
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(color: OurColors().backgroundText),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      OurColors().deleteButton,
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: OurColors().backgroundText),
                  ),
                ),
              ],
            );
          },
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
      surfaceTintColor: (marketPost.user == userId)
          ? OurColors().primary
          : OurColors().sectionBackground,
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
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        marketPost.user == userId
                            ? 'images/granjero.png'
                            : 'images/user.png',
                      ),
                    ),
                    Text(
                      (marketPost.user == userId)
                          ? 'Yourself'
                          : marketPost.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Transform.translate(
                    offset: Offset(10, -10), // Move the text up
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.translate(
                          offset: Offset(4, 0), // Move the text to the right
                          child: Text(
                            marketPost.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Transform.translate(
                          offset: Offset(4, 0), // Move the text to the right
                          child: Text(
                            marketPost.description ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Visibility(
                      visible: (marketPost.user == userId),
                      child: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                          PopupMenuItem(
                            child: Text('Modify'),
                            value: 'Modify',
                          ),
                          PopupMenuItem(
                            child: Text('Delete'),
                            value: 'Delete',
                          ),
                        ],
                        onSelected: (value) async {
                          if (value == 'Delete') {
                            await MarketSupabase()
                                .deleteMarketPostById(marketPost.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MarketPage(marketPost.community, userId),
                              ),
                            );
                          } else if (value == 'Modify') {
                            _showModifyPostDialog(context, marketPost);
                          } else {
                            return;
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: IconButton(
                        icon: Icon(
                          Icons.message,
                          color: OurColors().primeWhite,
                        ),
                        onPressed: () => {
                          if (marketPost.user == userId)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatListPage(
                                    marketPost: marketPost,
                                    clientId: marketPost.user,
                                  ),
                                ),
                              )
                            }
                          else
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    postId: marketPost.id,
                                    client: userId,
                                    seller: marketPost.user,
                                    userId: userId,
                                  ),
                                ),
                              )
                            }
                        },
                      ),

                      /*ElevatedButton(
                        onPressed: () {
                          if (marketPost.user == userId) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatListPage(
                                  marketPost: marketPost,
                                  clientId: marketPost.user,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  postId: marketPost.id,
                                  client: userId,
                                  seller: marketPost.user,
                                  userId: userId,
                                ),
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            OurColors().sectionBackground,
                          ),
                        ),
                        child: Icon(
                          Icons.message,
                          color: OurColors().primeWhite,
                        ),
                      ),*/
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
