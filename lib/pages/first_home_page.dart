import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_huerto/pages/create_community.dart';
import 'package:flutter_application_huerto/pages/join_community.dart';
import 'package:http/http.dart' as http;

import '../components/button.dart';

class FirstHomePage extends StatelessWidget {
  const FirstHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'SIN COMUNIDAD',
            style: TextStyle(color: Colors.black),
          ),
        ),
        leading: const CircleAvatar(
          backgroundImage:
              AssetImage("images/granjero.png"), // Cambiado a la imagen local
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/stardew.jpg'),
                fit: BoxFit.cover,
              ),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
  }
}
