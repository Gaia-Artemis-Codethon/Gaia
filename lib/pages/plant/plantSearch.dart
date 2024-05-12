import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/const/colors.dart';
import 'plantDetail.dart';

class SearchPage extends StatefulWidget {
  final Guid userId;

  const SearchPage(this.userId, {super.key});

  @override
  _PlantSearchState createState() => _PlantSearchState();
}

class _PlantSearchState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  List<dynamic> _plants = [];

  void _showPlantDetails(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantDetail(plantId: id, user_id: widget.userId),
      ),
    );
  }

  static const String PERENUAL_TOKEN = 'sk-CgNd6623dc0d606905197';

  //Use this second token if the limit of requests is reached
  static const String PERENUAL_TOKEN_AUX = 'sk-FM4q66298823e4ac15244';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: OurColors().backgroundColor,
          title: Text('Search for plants'),
        ),
        body: Container(
          color: OurColors().backgroundColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Scientific/common name of the plant',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      // Border radius
                      borderSide: BorderSide(
                          color:
                              OurColors().primaryBorderColor), // Border color
                    ),
                    filled: true,
                    fillColor:
                        Colors.white.withOpacity(0.8), // Background color
                  ),
                  onChanged: _searchPlants,
                ),
              ),
              Expanded(
                  child: Container(
                child: ListView.builder(
                  itemCount: _plants.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        var id = _plants[index]['id'];
                        _showPlantDetails(id);
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            child: ListTile(
                              leading: _plants[index]['default_image'] != null &&
                                  _plants[index]['default_image']
                                  ['thumbnail'] !=
                                      null
                                  ? Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                child: Image.network(
                                  _plants[index]['default_image']
                                  ['thumbnail'],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: OurColors().backgroundColor,
                                        borderRadius:
                                        BorderRadius.circular(15),
                                      ),
                                      child: Icon(
                                        Icons.local_florist,
                                        size: 30,
                                        color: OurColors().primary,
                                      ),
                                    );
                                  },
                                ),
                              )
                                  : Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: OurColors().backgroundColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.local_florist,
                                  size: 30,
                                  color: OurColors().primary,
                                ),
                              ),
                              title: Text(
                                _plants[index]['scientific_name'][0] ??
                                    'Scientific Name not available',
                                style:
                                TextStyle(color: OurColors().backgroundText),
                              ),
                              subtitle: Text(_plants[index]['common_name'] ?? ''),
                            ),
                          ),
                          Divider(height: 2, color: Colors.grey),
                        ],
                      ),
                    );
                  },
                ),
              )),
            ],
          ),
        ));
  }

  void _searchPlants(String query) async {
    try {
      final response = await http.get(Uri.parse(
          'https://perenual.com/api/species-list?key=$PERENUAL_TOKEN_AUX&q=$query'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'];
        setState(() {
          _plants = data;
        });
      } else {
        print('Failed to fetch data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
