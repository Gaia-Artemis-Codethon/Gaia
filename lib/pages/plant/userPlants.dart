import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/pages/home_page.dart';
import 'package:flutter_application_huerto/pages/plant/plantSearch.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/button.dart';
import '../../components/plantedItem.dart';
import '../../models/planted.dart';
import '../../service/planted_supabase.dart';
import '../map/mapPage.dart';
import '../toDo/toDo.dart';
import '/const/colors.dart';

class UserPlants extends StatefulWidget {
  final Guid userId;

  const UserPlants(this.userId, {super.key});

  @override
  _UserPlantsState createState() => _UserPlantsState();
}

class _UserPlantsState extends State<UserPlants> {
  late Future<List<Map<String, dynamic>>?> _plantedListFuture;
  bool showFAB = true;

  @override
  void initState() {
    super.initState();
    _plantedListFuture = fetchPlanted(widget.userId);
  }

  Future<List<Map<String, dynamic>>?> fetchPlanted(Guid userId) async {
    final response = await PlantedSupabase().getPlantedByUserId(userId);
    if (response.isEmpty) showFAB = false;
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColors().backgroundColor,
      appBar: AppBar(
        backgroundColor: OurColors().backgroundColor,
        elevation: 0,
        title: Text('Tus Plantas'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(widget.userId)));
            ;
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: _plantedListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            showFAB = false;
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            showFAB = false;
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            showFAB = false;
            return Container(
              decoration: BoxDecoration(color: OurColors().backgroundColor),
              child: Center(
                child: Container(
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No se ha encontrado ninguna planta ¿Quieres añadir alguna?',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Button(
                          text: Text(
                            'Si!',
                            style:
                                TextStyle(color: OurColors().primaryTextColor),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  OurColors().primary),
                              elevation:
                                  MaterialStateProperty.all<double>(2.0)),
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
                    )),
              ),
            );
          } else {
            showFAB = true;
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
                        status: planted['status']),
                    userId: widget.userId,
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: Visibility(
        visible: showFAB,
        child: ClipOval(
          child: FloatingActionButton(
            mini: false,
            heroTag: null,
            tooltip: 'Add more plants',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(widget.userId),
                ),
              );
            },
            backgroundColor: OurColors().primaryButton,
            child: Icon(
              Icons.add,
              size: 35,
              color: OurColors().sectionBackground,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: SvgPicture.asset(
                "images/todo.svg",
                width: 30,
                height: 30,
                color: OurColors().primaryButton,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ToDo(widget.userId),
                  ),
                );
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                "images/planta.svg",
                width: 30,
                height: 30,
                color: OurColors().primaryButton,
              ),
              onPressed: () {
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                "images/mapa.svg",
                width: 30,
                height: 30,
                color: OurColors().primaryButton,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(widget.userId),
                  ),
                );
              },
            ),
          ],
        ),
      )
      
    );
  }
}
