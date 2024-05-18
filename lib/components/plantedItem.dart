import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/pages/plant/userPlants.dart';
import 'package:flutter_application_huerto/service/planted_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';
import '../models/planted.dart';
import '../pages/plant/ownPlantDetail.dart';
import '../pages/plant/plantDetail.dart';
import '../service/crop_supabase.dart';
import '../models/crop.dart';
import '../const/colors.dart';

class PlantedItem extends StatefulWidget {
  final Planted plant;
  final Guid userId;

  const PlantedItem({super.key, required this.plant, required this.userId});

  @override
  State<PlantedItem> createState() => _PlantedItemState();
}

class _PlantedItemState extends State<PlantedItem> {
  late String cropName;
  late String imgURL;

  @override
  void initState() {
    super.initState();
    imgURL = '';
    cropName = '';
    fetchCrop(widget.plant.crop_id);
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove plant"),
          content: Text("Do you want to delete this plant?"),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  await PlantedSupabase().deletePlantedById(widget.plant.id);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UserPlants(widget.userId))); // Close the dialog
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      color: OurColors().primary,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Text(
                    "Yes",
                    style: TextStyle(color: OurColors().primaryTextColor),
                  ),
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      color: OurColors().deleteButton,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Text(
                    "No",
                    style: TextStyle(color: OurColors().primaryTextColor),
                  ),
                )),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchCrop(widget.plant.crop_id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OwnPlantDetail(
                          plantId: widget.plant.perenual_id,
                          user_id: widget.userId),
                    ),
                  );
                },
                child: Container(
                  height: 140,
                  width: 300,
                  child: Card(
                      elevation: 0,
                      color: OurColors().primaryTextColor,
                      margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 10),
                      child: Center(
                        child: ListTile(
                          visualDensity: VisualDensity(vertical: 4),
                          leading: imgURL != null || imgURL != ''
                              ? SizedBox(
                                  height: 120,
                                  width: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: Container(
                                                width:
                                                    300, // Adjust the width as needed
                                                height:
                                                    330, // Adjust the height as needed
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.network(
                                                    imgURL.replaceFirst(
                                                        'thumbnail', 'regular'),
                                                    width: 300,
                                                    height: 330,
                                                    fit: BoxFit.fill,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Container(
                                                        width: 120,
                                                        height: 120,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: OurColors()
                                                              .backgroundColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Icon(
                                                          Icons.local_florist,
                                                          size: 60,
                                                          color: OurColors()
                                                              .primary,
                                                        ),
                                                      );
                                                    }, // Adjust the fit property as needed
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Image.network(
                                        imgURL,
                                        width: 80,
                                        height: 120,
                                        fit: BoxFit.fill,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 60,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color:
                                                  OurColors().backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Icon(
                                              Icons.local_florist,
                                              size: 40,
                                              color: OurColors().primary,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 60,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: OurColors().backgroundColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(
                                    Icons.local_florist,
                                    size: 40,
                                    color: OurColors().primary,
                                  ),
                                ),
                          title: Text(cropName),
                          subtitle: Text(
                              'Planted on: ${widget.plant.planted_time.toString().split(' ')[0] ?? 'Unknown Date'}\n' +
                                  'Status: ${Planted.parseStatus(widget.plant.status)}'),
                          trailing: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              showConfirmationDialog(context);
                            },
                          ),
                        ),
                      )),
                ));
          }
        });
  }

  Future<void> fetchCrop(Guid crop_id) async {
    print('Fetching crop');
    Crop? crop = await CropSupabase().getCropById(crop_id);
    if (crop == null) {
      cropName = 'Unknown';
      imgURL = '';
    } else {
      cropName = crop.name;
      imgURL = crop.thumbnail;
    }
  }
}
