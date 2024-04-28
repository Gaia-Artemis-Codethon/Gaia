import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/pages/home_page.dart';
import 'package:flutter_application_huerto/pages/plant/plantSearch.dart';
import 'package:flutter_application_huerto/widgets/streamPlants.dart';
import 'package:flutter_guid/flutter_guid.dart';

import '/const/colors.dart';

class UserPlants extends StatefulWidget {
  final Guid userId;
  const UserPlants(this.userId, {super.key});

  @override
  _UserPlantsState createState() => _UserPlantsState();
}

class _UserPlantsState extends State<UserPlants> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColors().backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text('Your Land'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(widget.userId)));;
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 20.0),
                child: ListPlanted(widget.userId),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
