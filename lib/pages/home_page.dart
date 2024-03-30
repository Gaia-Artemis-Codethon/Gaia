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
    String name = await CommunitySupabase()
        .readCommunityNameByUserCommunityId(guid) as String;
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: // Espacio entre el avatar y el texto
            Expanded(
          child: FutureBuilder<String>(
            future: _readCommunityName(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show a loading indicator while waiting for the future to complete
              } else if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); // Show error message if the future completes with an error
              } else {
                return Row(children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://pxafmjqslgpswndqzfvm.supabase.co/storage/v1/object/sign/images/garanjero.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpbWFnZXMvZ2FyYW5qZXJvLnBuZyIsImlhdCI6MTcxMTgyMDc1MiwiZXhwIjoxNzQzMzU2NzUyfQ.qD5udNgpp3AM2tuGfbRD6PJgYzBWnO56ThtCmkIsi8U&t=2024-03-30T17%3A45%3A52.037Z",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MI COMUNIDAD',
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          snapshot.data ??
                              'Default Community Name', // Use the data from the future, or a default value if the future is null
                          style: const TextStyle(color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ]);
              }
            },
          ),
        ),
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
