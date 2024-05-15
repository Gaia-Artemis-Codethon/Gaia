import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/pages/plant/userPlants.dart';
import 'package:flutter_application_huerto/service/crop_supabase.dart';
import 'package:flutter_application_huerto/service/planted_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../models/crop.dart';
import '../../models/planted.dart';
import '../../models/planted_log.dart';
import '../../service/planted_log_supabase.dart';

class PlantDetail extends StatefulWidget {
  final int plantId;
  final Guid user_id;

  PlantDetail({super.key, required this.plantId, required this.user_id});

  @override
  _PlantDetailsPageState createState() => _PlantDetailsPageState();
}

class _PlantDetailsPageState extends State<PlantDetail> {
  late Map<String, dynamic> _plantDetails;

  static const String PERENUAL_TOKEN = 'sk-CgNd6623dc0d606905197';

  static const String PERENUAL_TOKEN_AUX = 'sk-FM4q66298823e4ac15244';

  @override
  void initState() {
    super.initState();
    _plantDetails = {};
    _fetchPlantDetails().then((_) {
      build(context);
    });
  }

  Widget growthCard(String title, String body, IconData iconData) {
    return Container(
      width: 280,
      height: 100,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: OurColors().primary,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: OurColors().primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              iconData,
              color: OurColors().sectionBackground,
              size: 50,
            ),
          ),
          SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: OurColors().sectionBackground),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 150,
                child: Text(body,
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: OurColors().sectionBackground)),
              )
            ],
          )
        ],
      ),
    );
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add plant"),
          content: Text("Are you sure you want to add this plant?"),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  Guid newPlantedId = Guid.newGuid;
                  Guid newCropId = Guid(
                      Uuid().v5(Uuid.NAMESPACE_URL, widget.plantId.toString()));
                  final crop = await CropSupabase().getCropById(Guid(Uuid()
                      .v5(Uuid.NAMESPACE_URL, widget.plantId.toString())));
                  if (crop == null) {
                    print('Crop does not exist');
                    try {
                      await CropSupabase().addCrop(Crop(
                        id: newCropId,
                        name: _plantDetails['scientific_name'][0] ?? 'No name',
                        descript: _plantDetails['description'] ??
                            'No information available',
                        difficulty:
                            Crop.parseDifficulty(_plantDetails['care_level']),
                        thumbnail: _plantDetails['default_image']['thumbnail'],
                        season: _plantDetails['flowering_season'] ??
                            'No information',
                      ));
                    } catch (e) {
                      print('Error $e');
                    }
                  }

                  await PlantedSupabase().addPlant(
                    Planted(
                        id: newPlantedId,
                        crop_id: newCropId,
                        land_id: Guid(
                            '11ec8d5f-19b3-4c4a-b9bd-7046cdf411d0'), //The Land Id associated with the community Id
                        planted_time: DateTime.now(),
                        status: 0,
                        user_id: widget.user_id,
                        perenual_id: widget.plantId),
                  );

                  await PlantedLogSupabase().addPlantLog(PlantedLog(
                      id: newPlantedId,
                      user_id: widget.user_id,
                      planted_id: newPlantedId,
                      name: _plantDetails['common_name'] ?? 'No name',
                      description: _plantDetails['description'] ??
                          'No information available',
                      date: DateTime.now()));
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserPlants(widget.user_id)));
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
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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

  Future<void> _fetchPlantDetails() async {
    final String apiUrl =
        'https://perenual.com/api/species/details/${widget.plantId}?key=$PERENUAL_TOKEN_AUX';

    debugPrint(apiUrl);

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          _plantDetails = json;
        });
      } else {
        throw Exception('Failed to load plant details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching plant details: $e');
    }
  }

  String parseArray(String inp) {
    return inp.substring(1, inp.length - 1);
  }

  String capitalizeFirstChar(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColors().backgroundColor,
      appBar: AppBar(
        backgroundColor: OurColors().backgroundColor,
        title: const Text('Plant Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          // Background Icon
          Positioned.fill(
            child: Icon(
              Icons.local_florist, // Replace with your desired icon
              color: OurColors().sectionBackground, // Icon color
              size: 400, // Icon size
            ),
          ),
          // Existing content
          _plantDetails.isEmpty // Check if plant details are empty
              ? Center(
                  child: CircularProgressIndicator()) // Show loading indicator
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Container(
                                    width: 300, // Adjust the width as needed
                                    height: 330, // Adjust the height as needed
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        _plantDetails['default_image']
                                            ['regular_url'],
                                        width: 300,
                                        height: 350,
                                        fit: BoxFit.fill,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color:
                                                  OurColors().backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Icon(
                                              Icons.local_florist,
                                              size: 60,
                                              color: OurColors().primary,
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
                            _plantDetails['default_image']['thumbnail'],
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: OurColors().backgroundColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.local_florist,
                                  size: 90,
                                  color: OurColors().primary,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: 350,
                        child: Text(
                          capitalizeFirstChar(_plantDetails['common_name'] ??
                              'No name available'),
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _plantDetails['scientific_name'][0] ??
                            'No information available',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Container(
                          color: OurColors().backgroundColor,
                          padding:
                              EdgeInsets.only(left: 30, right: 30, bottom: 20),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                child: const Text(
                                  'Description',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                _plantDetails['description'] ??
                                    'No information available',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: OurColors().backgroundText),
                              ),
                              SizedBox(height: 20),
                              const Text(
                                'How to Grow:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              growthCard(
                                  'Placement',
                                  (_plantDetails['indoor'] == false)
                                      ? 'Outdoor plant'
                                      : 'Indoor plant',
                                  Icons.window_outlined),
                              SizedBox(
                                height: 10,
                              ),
                              growthCard(
                                  'Difficulty',
                                  (_plantDetails['care_level']),
                                  Icons.landscape),
                              const SizedBox(height: 10),
                              growthCard(
                                  'Maximum height',
                                  '${_plantDetails['dimensions']['max_value']} feet',
                                  Icons.height),
                              const SizedBox(height: 10),
                              growthCard(
                                  'Watering frequency',
                                  '${_plantDetails['watering_general_benchmark']['value']} days',
                                  Icons.water_drop_outlined),
                              const SizedBox(height: 10),
                              growthCard(
                                  'Light requirements',
                                  parseArray(
                                      _plantDetails['sunlight'].toString()),
                                  Icons.wb_sunny_outlined),
                              const SizedBox(height: 20),
                              const Text(
                                'Other considerations:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Time to water: ${_plantDetails['watering_period']}',
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: true,
        child: ClipOval(
          child: FloatingActionButton(
            mini: false,
            heroTag: null,
            tooltip: 'Add plant to your crops',
            onPressed: () {
              showConfirmationDialog(context);
            },
            backgroundColor: OurColors().primeWhite,
            child: Icon(
              Icons.add,
              size: 35,
              color: OurColors().sectionBackground,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
