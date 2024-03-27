import 'package:flutter/material.dart';
import 'components/button.dart';
import 'components/navigation.dart';
import 'pages/first_home_page.dart';
import 'service/supabase.dart';
import 'package:flutter/widgets.dart';

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
