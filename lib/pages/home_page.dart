import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_huerto/pages/create_community.dart';
import 'package:flutter_application_huerto/pages/join_community.dart';
import 'package:flutter_application_huerto/service/community_supabase.dart';
import 'package:flutter_application_huerto/service/supabaseService.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

import '../components/button.dart';
import '../models/community.dart';

class HomePage extends StatelessWidget {
 const HomePage({super.key});

 Future<String> _readCommunityName() async {
    Guid guid = await SupabaseService().getUserId() as Guid;
    String name = await CommunitySupabase().readCommunityNameByUserCommunityId(guid) as String;
    return name;
 }

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: FutureBuilder<String>(
          future: _readCommunityName(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show a loading indicator while waiting for the future to complete
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Show error message if the future completes with an error
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 const Text(
                    'MI COMUNIDAD',
                    style: TextStyle(color: Colors.black),
                 ),
                 Text(
                    snapshot.data ?? 'Default Community Name', // Use the data from the future, or a default value if the future is null
                    style: TextStyle(color: Colors.black),
                 ),
                ],
              );
            }
          },
        ),
        leading: const CircleAvatar(
          backgroundImage: AssetImage(
            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
          ),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Crear Comunidad'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
 }
}