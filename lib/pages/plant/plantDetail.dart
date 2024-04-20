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

  static const String TREFLE_TOKEN = '70FT47uZLLK6BjzbzKHlTo4rEHqsx8Mhcm_4kSY6i2w';

  @override
  void initState() {
    super.initState();
    _fetchPlantDetails();
  }

  Future<void> _fetchPlantDetails() async {
    final String apiUrl =
        'http://trefle.io/api/v1/plants/${widget.plantId}?token=' + TREFLE_TOKEN; // Replace {defaultHost} with your host

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
    if (_plantDetails == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Plant Details'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Plant Details'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _plantDetails['scientific_name'] ?? 'Not available',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'How to Grow:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                _plantDetails['growth'] ?? 'No information available',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
}
