import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/pages/chat/chat.dart';
import 'package:flutter_application_huerto/pages/start/home_page.dart';
import 'package:flutter_application_huerto/service/user_supabase.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_guid/flutter_guid.dart';

import '../../models/market.dart';
import '../../models/userLoged.dart';
import '../../service/market_supabase.dart';
import '../../widgets/marketPlace/marketCard.dart';
import 'chat_list.dart';

class MarketPage extends StatefulWidget {
  final Guid communityId;
  final Guid userId; // The userId of the own user

  MarketPage(this.communityId, this.userId);

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColors().backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text('Market Place'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Lleva siempre a la HomePage
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage(widget.userId)),
              (route) => false,
            );
          },
        ),
      ),
      body: StreamBuilder<List<Market>>(
        stream: MarketSupabase().getMarketByCommunityId(widget.communityId),
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
                      'Currently, there are no available posts at the market place :(',
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
                return MarketCard(
                  marketPost: snapshot.data![index],
                  userId: widget.userId,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePostDialog(context);
        },
        child: Icon(
          Icons.add,
          color: OurColors().backgroundColor,
          size: 40,
        ),
        backgroundColor: OurColors().primeWhite,
        shape: const CircleBorder(),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    TextEditingController createTitleController = TextEditingController();
    TextEditingController createDescriptionController = TextEditingController();

    bool isTitleEmpty = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Create new Post'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: createTitleController,
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
                    controller: createDescriptionController,
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
                      : () async {
                          // Get the entered title and description
                          String title = createTitleController.text;
                          String description = createDescriptionController.text;
                          // Add your action to create a new post here
                          // You can use the title and description variables
                          await MarketSupabase().addMarketPost(Market(
                              id: Guid.newGuid,
                              user: widget.userId,
                              title: title,
                              community: widget.communityId,
                              description: description,
                              username: (await UserSupabase()
                                      .getUserById(widget.userId) as UserLoged)
                                  .name));

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MarketPage(widget.communityId, widget.userId),
                            ),
                          );
                        },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          isTitleEmpty
                              ? Colors.grey
                              : OurColors().primaryButton)),
                  child: Text(
                    'Create',
                    style: TextStyle(color: OurColors().backgroundText),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          OurColors().deleteButton)),
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
}
