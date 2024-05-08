import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/components/button.dart';

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
  List<bool> _isPressedList = List.generate(100, (index) => false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Parcela"),
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
                      print("Container ${index} pressed");
                      setState(() {
                        currentOwner.addProperty(index);
                        build(context);
                      });
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
            Row(
              children: [
                Button(
                  text: Text("Gabriel"),
                  onPressed: (){
                    setState(() {
                      currentOwner = owners[0];
                    });
                  },
                ),
                Button(
                  text: Text("Laijie"),
                  onPressed: (){
                    setState(() {
                      currentOwner = owners[1];
                    });
                  },
                ),
                Button(
                  text: Text("Dani"),
                  onPressed: (){
                    setState(() {
                      currentOwner = owners[2];
                    });
                  },
                ),
                Button(
                  text: Text("Luis"),
                  onPressed: (){
                    setState(() {
                      currentOwner = owners[3];
                    });
                  },
                ),
              ],
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
