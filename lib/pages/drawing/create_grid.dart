import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_huerto/components/button.dart';
import 'package:flutter_application_huerto/service/grid_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';

import '../../models/Auth.dart';
import '../../models/grid.dart';
import '../../models/owner.dart';

class GridPage extends StatefulWidget {
  const GridPage({Key? key}) : super(key: key);

  @override
  _GridPageState createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  List<Owner> owners = <Owner>[
    Owner("Gabriel",Colors.blue,<int>[]),
    Owner("Laijie",Colors.red,<int>[]),
    Owner("Dani",Colors.green,<int>[]),
    Owner("Luis",Colors.yellow,<int>[]),
  ];

  Owner currentOwner = Owner("Artemis",Colors.grey,<int>[]);

  Map<Owner,List<int>> belongsTo = Map<Owner,List<int>>();

  late Auth session;
  late GridDto gridDao = GridDto(id: Guid.defaultValue, communityId: Guid.defaultValue, dimensionsX: -1, dimensionsY: -1, tileDistribution: {},);

  @override
  void initState() {
    super.initState();
    session = Auth();
    _getGridData();
  }

  void _getGridData() async {
    Auth session = Auth();
    print("Here");
    GridDto? data= await GridSupabase().getGridDataByCommunityId(session.community);
    setState(() {
      gridDao = data!;
      owners =<Owner>[];
      gridDao.tileDistribution.forEach((key, value) {
        owners.add(Owner(key,getRandomColor(),value));
      });
      build(context);
      print("Data: ${gridDao.communityId}");
    });
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256), // Red value
      random.nextInt(256), // Green value
      random.nextInt(256), // Blue value
      1.0, // Alpha value (fully opaque)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Community's farm"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: 100,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: (){
                      if(session.isAdmin){
                        print("Container ${index} pressed");
                        setState(() {
                          currentOwner.addProperty(index);
                          build(context);
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: getColorByOwner(index),// Change color when pressed
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.blueAccent)),
                      child: Text("${index}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  );
            }),
            SizedBox(
              height: 300,
              child: gridDao.communityId != Guid.defaultValue ?
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: owners.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentOwner = owners[index];
                        });
                      },
                      child: Text(owners[index].name),
                    ),
                  );
                },
              ) : Container(child:CircularProgressIndicator())
            )
          ],
        ));
  }

  Color getColorByOwner(int index){
    Color c = Colors.black;
    owners.forEach((owner) {
      owner.getProperties().forEach((property) {
        if(property==index){c = owner.getColor();}
      });
    });
    return c;
  }
}
