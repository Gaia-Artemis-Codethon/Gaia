import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/const/colors.dart';
import 'plantDetail.dart';

void main() {
  runApp(SearchMenu());
}


class SearchMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Busca plantas para añadir a tus cultivos'),
        ),
        body: PlantSearch(),
      ),
    );
  }
}

class PlantSearch extends StatefulWidget {
  @override
  _PlantSearchState createState() => _PlantSearchState();
}

class _PlantSearchState extends State<PlantSearch> {
  TextEditingController _controller = TextEditingController();
  List<dynamic> _plants = [];

  void _showPlantDetails(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantDetail(plantId: id),
      ),
    );
  }


  static const String TREFLE_TOKEN = '70FT47uZLLK6BjzbzKHlTo4rEHqsx8Mhcm_4kSY6i2w';
  // The reference is in https://docs.trefle.io/reference

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Introduce el nombre de la planta',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0), // Border radius
                borderSide: BorderSide(color: OurColors().primaryBorderColor), // Border color
              ),
              filled: true,
              fillColor: OurColors().backgroundColor, // Background color
            ),
            onChanged: _searchPlants,
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: _plants.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    int id = _plants[index]['id'];
                    _showPlantDetails(id);
                  },
                  child: Column(
                    children: [
                      ListTile(
                        leading: _plants[index]['image_url'] != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            _plants[index]['image_url'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: OurColors().backgroundColor, // Background color
                            borderRadius: BorderRadius.circular(15), // Rounded corners
                          ),
                          child: Icon(
                            Icons.local_florist, // Plant icon
                            size: 30,
                            color: OurColors().primary, // Icon color
                          ),
                        ),
                        title: Text(
                          _plants[index]['scientific_name'],
                          style: TextStyle(color: OurColors().backgroundText),
                        ),
                        subtitle: Text(_plants[index]['common_name'] ?? ''),
                      ),
                      Divider(height: 1, color: Colors.grey), // Divider between tiles
                    ],
                  ),
                );
              },
            ),

          )

        ),

      ],
    );
  }

  void _searchPlants(String query) async {
    final String url = 'https://trefle.io/api/v1/plants/search?token=' + TREFLE_TOKEN + '&q=$query';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          _plants = json['data'];
        });
      } else {
        throw Exception('Failed to search plants: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching plants: $e');
    }
  }
}
