import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlantDetail extends StatefulWidget {
  final int plantId;

  PlantDetail({required this.plantId});

  @override
  _PlantDetailsPageState createState() => _PlantDetailsPageState();
}

class _PlantDetailsPageState extends State<PlantDetail> {
  late Map<String, dynamic> _plantDetails;

  static const String PERENUAL_TOKEN = 'sk-CgNd6623dc0d606905197';

  @override
  void initState() {
    super.initState();
    _plantDetails = {};
    _fetchPlantDetails().then((_) {
      print(_plantDetails);
      build(context);
    });
  }

  Future<void> _fetchPlantDetails() async {
    final String apiUrl =
        'https://perenual.com/api/species/details/${widget.plantId}?key=' + PERENUAL_TOKEN;

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
      appBar: AppBar(
        title: Text('Plant Details'),
      ),
      body: _plantDetails.isEmpty // Check if plant details are empty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _plantDetails['scientific_name'][0] ?? 'No name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _plantDetails['common_name'] ?? 'No information available',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'How to Grow:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _plantDetails['description'] ?? 'No information available',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
