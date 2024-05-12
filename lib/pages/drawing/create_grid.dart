import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_huerto/components/button.dart';
import 'package:flutter_application_huerto/const/colors.dart';
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
    Owner("Gabriel", Colors.blue, <int>[]),
    Owner("Laijie", Colors.red, <int>[]),
    Owner("Dani", Colors.green, <int>[]),
    Owner("Luis", Colors.yellow, <int>[]),
  ];

  Owner currentOwner = Owner("Artemis", Colors.grey, <int>[]);

  Map<Owner, List<int>> belongsTo = Map<Owner, List<int>>();
  static const DEFAULT_GRID_SIZE = 100;
  late Auth session;
  late GridDto gridDao = GridDto(
    id: Guid.defaultValue,
    communityId: Guid.defaultValue,
    dimensionsX: -1,
    dimensionsY: -1,
    tileDistribution: {},
  );

  @override
  void initState() {
    super.initState();
    session = Auth();
    _getGridData();
  }

  void _getGridData() async {
    Auth session = Auth();
    GridDto? data =
        await GridSupabase().getGridDataByCommunityId(session.community);
    setState(() {
      gridDao = data!;
      owners = <Owner>[];
      gridDao.tileDistribution.forEach((key, value) {
        owners.add(Owner(key, getRandomColor(), value));
      });
      build(context);
      print("Data: ${gridDao.communityId}");
    });
  }

  void _updateGridData() async{
    bool isUpdated = await GridSupabase().updateGridDataByCommunityId(gridDao);
    if(isUpdated){
      _getGridData();
    }
  }

  Color getRandomColor() {
    Random random = Random();
    Color targetColor = OurColors().primaryButton;
    const int threshold = 50;

    Color generatedColor;
    do {
      generatedColor = Color.fromRGBO(
        random.nextInt(256), // Red value
        random.nextInt(256), // Green value
        random.nextInt(256), // Blue value
        1.0, // Alpha value (fully opaque)
      );
    } while (_colorDifference(generatedColor, targetColor) < threshold);

    return generatedColor;
  }

  int _colorDifference(Color color1, Color color2) {
    return ((color1.red - color2.red).abs() +
        (color1.green - color2.green).abs() +
        (color1.blue - color2.blue).abs()) ~/
        3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Community's farm"),
        ),
        body: gridDao.id != Guid.defaultValue
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GridView.builder(
                      shrinkWrap: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      itemCount: //In case of being bigger than 100 tiles or smaller than 0 takes default size
                          gridDao.dimensionsX * gridDao.dimensionsY > 10 ||
                                  gridDao.dimensionsX * gridDao.dimensionsY < 0
                              ? DEFAULT_GRID_SIZE
                              : gridDao.dimensionsX * gridDao.dimensionsY,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10, //Do not change
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            if (session.isAdmin) {
                              setState(() {
                                currentOwner.addProperty(index);
                                build(context);
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: getColorByOwner(
                                    index), // Change color when pressed
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
                      height: 350,
                      child: gridDao.communityId != Guid.defaultValue
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: owners.length,
                              itemBuilder: (context, index) {
                                return Button(
                                    onPressed: () {
                                      if(session.isAdmin){
                                        setState(() {
                                          currentOwner = owners[index];
                                        });
                                      }
                                    },
                                    text: Text(owners[index].name),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(owners[index].getColor()),
                                      foregroundColor: MaterialStateProperty.all(getFontColorForText(owners[index].getColor()))
                                    ),
                                  );
                              },
                            )
                          : Container(child: CircularProgressIndicator())),
                  session.isAdmin ?
                      Button(
                        text: Text(
                            "Save changes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(OurColors().primaryButton),
                            foregroundColor: MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Save changes'),
                                content: Text('Are you sure you want to update the distribution?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _updateGridData();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Yes'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ) :
                      Container()
                ],
              )
            : CircularProgressIndicator());
  }

  Color getFontColorForText(Color background) {
    return (background.computeLuminance() > 0.179)? Colors.black : Colors.white;
  }

  Color getColorByOwner(int index) {
    Color c = Colors.black;
    owners.forEach((owner) {
      owner.getProperties().forEach((property) {
        if (property == index) {
          c = owner.getColor();
        }
      });
    });
    return c;
  }
}
