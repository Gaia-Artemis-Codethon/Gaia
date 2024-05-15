import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/pages/create_community.dart';
import 'package:flutter_application_huerto/pages/join_community.dart';
import 'package:http/http.dart' as http;

import '../components/button.dart';

class FirstHomePage extends StatelessWidget {
  const FirstHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/firstH.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome!',
                  style: TextStyle(color: Colors.black, fontSize: 28),
                ),
                SizedBox(height: 20),
                Text(
                  'What do you want to do?',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width:
                      double.infinity, // Ajustar el ancho al máximo disponible
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const JoinCommunity(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OurColors().primaryButton,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Join a Community",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width:
                      double.infinity, // Ajustar el ancho al máximo disponible
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateCommunity(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OurColors().primaryButton,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Create a Community",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
