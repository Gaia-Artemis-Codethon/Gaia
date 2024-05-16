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

class OwnPlantDetail extends StatefulWidget {
  final int plantId;
  final Guid user_id;

  OwnPlantDetail({super.key, required this.plantId, required this.user_id});

  @override
  _OwnPlantDetailsPageState createState() => _OwnPlantDetailsPageState();
}

class _OwnPlantDetailsPageState extends State<OwnPlantDetail> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColors().backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: OurColors().backgroundColor,
        title: const Text('Plant Details'),
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
                      Text(
                        _plantDetails['scientific_name'][0] ?? 'No name',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _plantDetails['common_name'] ??
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
                                  '${_plantDetails['sunlight'].toString()}',
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
    );
  }
}
