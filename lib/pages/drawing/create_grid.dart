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
  }

  void _getGridData() async {
    Auth session = Auth();
    GridDto? data =
        await GridSupabase().getGridDataByCommunityId(session.community);
    setState(() {
      gridDao = data!;
      owners = <Owner>[];
      gridDao.tileDistribution.forEach((key, value) {
        if(key.contains("-")){
          String currentColor = key.substring(key.indexOf("-")+1,key.length);
          print(currentColor);
          Color c = getColorFromHex(currentColor);
          owners.add(Owner(key, c, value));
        }else{
          Color c = getRandomColor();
          owners.add(Owner(key+"-"+c.toHex(), getRandomColor(), value));
        }
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
  void _changeGridSize(int x, int y) async{
    Map<String,List<int>> clearTileDistribution = {};
    gridDao.tileDistribution.forEach((key, value) {
      clearTileDistribution[key] = [];
    });

    GridDto newData= GridDto(
      id: gridDao.id,
      communityId: gridDao.communityId,
      dimensionsX: x,
      dimensionsY: y,
      tileDistribution: clearTileDistribution,
    );
    bool isUpdated = await GridSupabase().updateGridDataByCommunityId(gridDao);

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
      generatedColor = Color.fromRGBO( //128+random(128) generates pastel colors instead of eyeball bleeding
        128+random.nextInt(128), // Red value
        128+random.nextInt(128), // Green value
        128+random.nextInt(128), // Blue value
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Community's farm"),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return InputDialog();
                  },
                );
              },
            ),
          ],
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
                                border: Border.all(color: Colors.blue, width: 2)),
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
                                      if(session.isAdmin){
                                        setState(() {
                                          currentOwner = owners[index];
                                        });
                                      }
                                    },
                                    text: Text(owners[index].name.substring(0,owners[index].name.indexOf("-"))),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(owners[index].getColor()),
                                      foregroundColor: MaterialStateProperty.all(getFontColorForText(owners[index].getColor()))
                                    ),
                                  );
                              },
                            )
                          : Container(child: CircularProgressIndicator())),
                ],
              )
            : CircularProgressIndicator()
        ,

    floatingActionButtonLocation:
    FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child:
        session.isAdmin ?
        ElevatedButton(
          onPressed: () {},
          child: Center(
            child:                       Button(
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
            )
          ),
        ):Container(),
      ),
    );
  }

  Color getFontColorForText(Color background) {
    return (background.computeLuminance() > 0.179)? Colors.black : Colors.white;
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

class InputDialog extends StatefulWidget {
  @override
  _InputDialogState createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  TextEditingController _x = TextEditingController();
  TextEditingController _y = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: _x,
            decoration: InputDecoration(labelText: 'Plot Width'),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^[1-9]|10$')), // Only allow numbers from 1 to 10
            ],
          ),
          TextFormField(
            controller: _y,
            decoration: InputDecoration(labelText: 'Plot Height'),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^[1-9]|10$')), // Only allow numbers from 1 to 10
            ],
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
            // Close the dialog and show a new dialog if conditions are met
            if (_isValidInput()) {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('WARNING!'),
                    content: Text('By changing the size of the plot the distribution will be erased.\nDo you really want to continue?.'),
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
                          if(int.parse(_x.text)>1 && int.parse(_x.text)<10 && int.parse(_y.text)>1 && int.parse(_y.text)<10){ //Just in case
                            //_changeGridSize(int.parse(_x.text),int.parse(_y.text));
                          }
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else {

            }
          },
          child: Text('OK'),
        ),
      ],
    );
  }
  bool _isValidInput() {
    return _x.text.isNotEmpty && _y.text.isNotEmpty;
  }

  @override
  void dispose() {
    _x.dispose();
    _y.dispose();
    super.dispose();
  }
}
