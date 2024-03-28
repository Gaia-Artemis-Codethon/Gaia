import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/pages/create_community.dart';
import 'package:flutter_application_huerto/pages/first_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: FirstHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }

  

}
