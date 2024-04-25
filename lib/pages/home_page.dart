import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/pages/deseaseAI/deseaseAI.dart';
import 'package:flutter_application_huerto/pages/map/mapPage.dart';
import 'package:flutter_application_huerto/pages/toDo/toDo.dart';
import 'package:flutter_application_huerto/service/community_supabase.dart';
import 'package:flutter_application_huerto/service/supabaseService.dart';
import 'package:flutter_guid/flutter_guid.dart';
import '../components/button.dart';

class HomePage extends StatelessWidget {
  final Guid userId;
  const HomePage(this.userId, {super.key});

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
          title: FutureBuilder<String>(
            future: _readCommunityName(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Muestra un indicador de carga mientras se espera la respuesta
              } else if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); // Muestra un mensaje de error si la future se completa con un error
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
                                  'Default Community Name', // Usa los datos de la future, o un valor predeterminado si la future es null
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
        body: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Column(
            children: [
              const Text(
                "El tiempo",
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
              const SizedBox(height: 10),
              const Text(
                "Mi parcela",
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
              const SizedBox(height: 10),
              const Text(
                "ToDo",
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
              Button(
                text: const Text(
                  "ToDo",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ToDo(userId),
                    ),
                  );
                },
              ),
              const Text(
                "Map",
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
              Button(
                text: const Text(
                  "Mapa",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapPage(userId)),
                  );
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "AI Plant",
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
              Button(
                text: const Text(
                  "AI Plant",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeseaseAI(),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
