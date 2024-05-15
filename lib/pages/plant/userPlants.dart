import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/models/task.dart';
import 'package:flutter_application_huerto/pages/home_page.dart';
import 'package:flutter_application_huerto/pages/map/mapPage.dart';
import 'package:flutter_application_huerto/pages/plant/plantSearch.dart';
import 'package:flutter_application_huerto/pages/toDo/toDo.dart';
import 'package:flutter_application_huerto/service/planted_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/button.dart';
import '../../components/plantedItem.dart';
import '../../models/planted.dart';
import '../../shared/bottom_navigation_bar.dart';

class UserPlants extends StatefulWidget {
  final Guid userId;

  const UserPlants(this.userId, {Key? key}) : super(key: key);

  @override
  _UserPlantsState createState() => _UserPlantsState();
}

class _UserPlantsState extends State<UserPlants> {
  late Future<List<Map<String, dynamic>>?> _plantedListFuture;
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _plantedListFuture = fetchPlanted(widget.userId);
  }

  Future<List<Map<String, dynamic>>?> fetchPlanted(Guid userId) async {
    final response = await PlantedSupabase().getPlantedByUserId(userId);
    return response.isEmpty ? null : response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColors().backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: OurColors().backgroundColor,
        elevation: 0,
        title: Center(
          child: Text('Your Plants'),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: _plantedListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              decoration: BoxDecoration(color: OurColors().backgroundColor),
              child: Center(
                child: Container(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 117),
                      Image.asset(
                        'images/junimo.png',
                        height: 200,
                        width: 200,
                      ),
                      Text(
                        'No plant was found, do you want to add any?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Button(
                        text: Text(
                          'Yeah!',
                          style: TextStyle(
                            color: OurColors().primaryTextColor,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            OurColors().primary,
                          ),
                          elevation: MaterialStateProperty.all<double>(2.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPage(widget.userId),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                color: OurColors().backgroundColor,
              ),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final planted = snapshot.data![index];
                  return PlantedItem(
                    plant: Planted(
                      id: Guid(planted['id']),
                      user_id: Guid(planted['user_id']),
                      crop_id: Guid(planted['crop_id']),
                      land_id: Guid(planted['land_id']),
                      planted_time: DateTime.parse(planted['planted_time']),
                      status: planted['status'],
                      perenual_id: planted['perenual_id'],
                    ),
                    userId: widget.userId,
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: ClipOval(
        child: Material(
          color: OurColors().primeWhite, // Button color
          child: InkWell(
            splashColor: Colors.white, // Splash color
            child: SizedBox(
                width: 56,
                height: 56,
                child: Icon(Icons.add, size: 35, color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(widget.userId),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() {
              _currentIndex = index;
            });
            if (_currentIndex == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(widget.userId),
                ),
              );
            } else if (_currentIndex == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ToDo(widget.userId),
                ),
              );
            } else if (_currentIndex == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapPage(widget.userId),
                ),
              );
            }
          }
        },
        currentIndex: _currentIndex,
      ),
    );
  }
}
