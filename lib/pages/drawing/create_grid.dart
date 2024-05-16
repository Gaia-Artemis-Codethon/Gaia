import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_huerto/components/button.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/models/sketch.dart';
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

  Owner currentOwner = Owner("Artemis", Colors.white, <int>[]);

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
    build(context);
  }

  void _getGridData() async {
    Auth session = Auth();
    GridDto? data =
        await GridSupabase().getGridDataByCommunityId(session.community);
    setState(() {
      if (data != null) {
        gridDao = data!;
        owners = <Owner>[];
        gridDao.tileDistribution.forEach((key, value) {
          if (key.contains("-")) {
            String currentColor =
                key.substring(key.indexOf("-") + 1, key.length);
            print(currentColor);
            Color c = getColorFromHex(currentColor);
            owners.add(Owner(key, c, value));
          } else {
            Color c = getRandomColor();
            owners.add(Owner(key + "-" + c.toHex(), getRandomColor(), value));
          }
        });
      }
      build(context);
    });
  }

  void _updateGridData() async {
    bool isUpdated = await GridSupabase().updateGridDataByCommunityId(gridDao);
    if (isUpdated) {
      _getGridData();
    }
  }

  void _changeGridSize(int x, int y) async {
    Map<String, List<int>> clearTileDistribution = {};
    gridDao.tileDistribution.forEach((key, value) {
      clearTileDistribution[key] = [];
    });

    GridDto newData = GridDto(
      id: gridDao.id,
      communityId: gridDao.communityId,
      dimensionsX: x,
      dimensionsY: y,
      tileDistribution: clearTileDistribution,
    );
    bool isUpdated = await GridSupabase().updateGridDataByCommunityId(newData);
    if (isUpdated) {
      _getGridData();
    }
  }

  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    int hexValue = int.parse(hexColor, radix: 16);
    return Color(hexValue).withOpacity(1.0);
  }

  Color getRandomColor() {
    Random random = Random();
    Color targetColor = OurColors().primaryButton;
    const int threshold = 50;

    Color generatedColor;
    do {
      generatedColor = Color.fromRGBO(
        //128+random(128) generates pastel colors instead of eyeball bleeding
        128 + random.nextInt(128), // Red value
        128 + random.nextInt(128), // Green value
        128 + random.nextInt(128), // Blue value
        1.0,
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

  bool areDimensionsOk() {
    return !(gridDao.dimensionsX * gridDao.dimensionsY > 100 ||
        gridDao.dimensionsX > 10 ||
        gridDao.dimensionsY > 10 ||
        gridDao.dimensionsX * gridDao.dimensionsY < 0);
  }

  @override
  Widget build(BuildContext context) {
    return gridDao == null
        ? Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              title: Text("Community's farm"),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 117),
                  Image.asset(
                    'images/junimo.png',
                    width: 200,
                    height: 200,
                  ),
                  Text(
                    'Don\'t you have tasks to do?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ))
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Text("Community's farm"),
              actions: [
                session.isAdmin && gridDao.id != Guid.defaultValue
                    ? IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              TextEditingController widthController =
                                  TextEditingController();
                              TextEditingController heightController =
                                  TextEditingController();
                              int height = 10;
                              int width = 10;
                              return AlertDialog(
                                title: Text('Enter Data'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    TextField(
                                      controller: widthController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]'))
                                      ],
                                      decoration: InputDecoration(
                                        labelText: 'Width [0-10]',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (text) {
                                        try {
                                          if (int.parse(text) > 10 ||
                                              int.parse(text) < 1) {
                                            widthController.text = "";
                                          }
                                        } catch (NumberFormatException) {}
                                      },
                                    ),
                                    TextField(
                                      controller: heightController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]'))
                                      ],
                                      decoration: InputDecoration(
                                        labelText: 'Height [0-10]',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (text) {
                                        try {
                                          if (int.parse(text) > 10 ||
                                              int.parse(text) < 1) {
                                            heightController.text = "";
                                          }
                                        } catch (NumberFormatException) {}
                                      },
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      // Close the dialog without performing any action
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      try {
                                        height =
                                            int.parse(heightController.text);
                                        width =
                                            int.parse(heightController.text);
                                      } catch (NumberFormatException) {
                                        height = 10;
                                        width = 10;
                                      }
                                      Navigator.of(context).pop();
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Warning'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                    'If you proceed changing the tile distribution, '
                                                    'the current distribution will be erased.\n'
                                                    'Do you still wish to continue?'),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _changeGridSize(
                                                      width, height);
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text("Ok"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )
                    : SizedBox(),
              ],
            ),
            body: gridDao.id != Guid.defaultValue
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          itemCount: //In case of being bigger than 100 tiles or smaller than 0 takes default size
                              areDimensionsOk()
                                  ? gridDao.dimensionsX * gridDao.dimensionsY
                                  : DEFAULT_GRID_SIZE,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: areDimensionsOk()
                                ? gridDao.dimensionsX > gridDao.dimensionsY
                                    ? gridDao.dimensionsX
                                    : gridDao.dimensionsY
                                : 10,
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
                                    border: Border.all(
                                        color: Colors.blue, width: 2)),
                                child: Text("${index}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                            );
                          }),
                      SizedBox(
                          height: 275,
                          child: gridDao.communityId != Guid.defaultValue
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: owners.length,
                                  itemBuilder: (context, index) {
                                    return Button(
                                      onPressed: () {
                                        if (session.isAdmin) {
                                          setState(() {
                                            currentOwner = owners[index];
                                          });
                                        }
                                      },
                                      text: Text(owners[index].name.substring(
                                          0, owners[index].name.indexOf("-"))),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  owners[index].getColor()),
                                          foregroundColor: MaterialStateProperty
                                              .all(getFontColorForText(
                                                  owners[index].getColor()))),
                                    );
                                  },
                                )
                              : Container(child: CircularProgressIndicator())),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 117),
                        Image.asset(
                          'images/junimo.png',
                          width: 200,
                          height: 200,
                        ),
                        Text(
                          'Your community does not have a plot :(',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Container(
              height: 50,
              margin: const EdgeInsets.all(10),
              child: (session.isAdmin && gridDao.id != Guid.defaultValue)
                  ? ElevatedButton(
                      onPressed: () {},
                      child: Center(
                          child: Button(
                        text: Text(
                          "Save changes",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              OurColors().primaryButton),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Save changes'),
                                content: Text(
                                    'Are you sure you want to update the distribution?'),
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
                      )),
                    )
                  : Container(),
            ),
          );
  }

  Color getFontColorForText(Color background) {
    return (background.computeLuminance() > 0.179)
        ? Colors.black
        : Colors.white;
  }

  Color getColorByOwner(int index) {
    Color c = Colors.white;
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
