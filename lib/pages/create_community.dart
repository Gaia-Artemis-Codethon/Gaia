import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/pages/first_home_page.dart';
import '../components/button.dart';
import '../service/supabase.dart';

import '../models/community.dart';
import '../service/community_supabase.dart';

class CreateCommunity extends StatefulWidget {
  const CreateCommunity({Key? key}) : super(key: key);

  @override
  _CreateCommunityState createState() => _CreateCommunityState();
}

class _CreateCommunityState extends State<CreateCommunity> {
  final TextEditingController _communityNameController =
      TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _communityNameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _communityNameController.removeListener(_updateButtonState);
    _communityNameController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _communityNameController.text.isNotEmpty;
    });
  }

  void _createCommunityByName() {
    String communityName = _communityNameController.text;
    // Llamar a addCommunityByName con el Map de la comunidad
    CommunitySupabase().addCommunityByName(communityName).then((_) {
      print("Comunidad añadida con éxito");
    }).catchError((error) {
      print("Error al añadir la comunidad: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'CREA UNA COMUNIDAD',
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Crea una nueva comunidad",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24), // Aumenta el tamaño de la fuente aquí
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Disfruta creando el mejor huerto urbano de Valencia",
              textAlign: TextAlign.left,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Nombre de la comunidad",
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _communityNameController,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green[100],
                ),
              ),
            ),
          ),
          Center(
            child: Button(
              text: const Text(
                "Continuar",
                textAlign: TextAlign.center,
              ),
              onPressed:
                  _isButtonEnabled ? () => {_createCommunityByName()} : null,
              icon: const Icon(Icons.arrow_forward),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF6917B),
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
