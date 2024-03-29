import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_huerto/pages/create_community.dart';
import 'package:flutter_application_huerto/pages/join_community.dart';
import 'package:http/http.dart' as http;

import '../components/button.dart';

class FirstHomePage extends StatelessWidget {
  const FirstHomePage({Key? key}) : super(key: key);

  Future<DecorationImage?> _fetchBackgroundImage() async {
    const url =
        "https://pxafmjqslgpswndqzfvm.supabase.co/storage/v1/object/sign/images/fondo%20stardew.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpbWFnZXMvZm9uZG8gc3RhcmRldy5qcGciLCJpYXQiOjE3MTE3MzE5MDgsImV4cCI6MTc0MzI2NzkwOH0.-SOPg_DugDXrRy3ECACu4yrupCMQBZMaPfcT_Bzz59g&t=2024-03-29T17%3A05%3A09.286Z";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return DecorationImage(
          image: MemoryImage(response.bodyBytes),
          fit: BoxFit.cover,
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching background image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchBackgroundImage(),
      builder: (context, AsyncSnapshot<DecorationImage?> snapshot) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              'Your App Title',
              style: TextStyle(color: Colors.black),
            ),
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              if (snapshot.hasData)
                Container(
                  decoration: BoxDecoration(
                    image: snapshot.data,
                  ),
                ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                        height:
                            kToolbarHeight), // Para dejar espacio para el AppBar
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 350,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.lightGreen[200]?.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(43),
                            ),
                            child: Stack(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Únete a una comunidad',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 24),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Si tus vecinos ya tienen una',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 20,
                                  child: Button(
                                    text: const Text(
                                      "Comenzar",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const JoinCommunity()),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: 350,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.lightGreen[200]?.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(43),
                            ),
                            child: Stack(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Crea una comunidad',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 24),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Se el primer vecino',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 20,
                                  child: Button(
                                    text: const Text(
                                      "Comenzar",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CreateCommunity()),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
