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
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage(
                            "images/granjero.png"), // Cambiado a la imagen local
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
      body: Column(
        children: [
          Text(
            "El tiempo",
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          SizedBox(height: 10),
          Text(
            "Mi parcela",
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          SizedBox(height: 10),
          Text(
            "Mis tareas",
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
        ],
      ),
    );
  }
}
