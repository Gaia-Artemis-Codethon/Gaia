import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/components/button.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/main.dart';
import 'package:flutter_application_huerto/models/task.dart';
import 'package:flutter_application_huerto/pages/plant/plantSearch.dart';
import 'package:flutter_application_huerto/service/task_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';
import '../components/plantedItem.dart';
import '../models/planted.dart';
import '../service/planted_supabase.dart';

class ListPlanted extends StatefulWidget {
  final Guid userId;

  ListPlanted(this.userId, {super.key});

  @override
  State<ListPlanted> createState() => _ListPlantedState();
}

class _ListPlantedState extends State<ListPlanted> {
  late Future<List<Map<String, dynamic>>?> _plantedListFuture;
  bool showFAB = true;

  @override
  void initState() {
    super.initState();
    _plantedListFuture = fetchPlanted(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          'No plants were found, do you want to add any plant?',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Button(
                          text: Text(
                            'Yes!',
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
          backgroundColor: OurColors().accent,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.add,
              color: OurColors().sectionBackground,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<List<Map<String, dynamic>>?> fetchPlanted(Guid userId) async {
    final response = await PlantedSupabase().getPlantedByUserId(userId);
    if (response.isEmpty) showFAB = false;
    return response;
  }
}
