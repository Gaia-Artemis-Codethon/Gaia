import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/pages/home_page.dart';
import 'package:flutter_application_huerto/service/user_supabase.dart';
import 'package:flutter_guid/flutter_guid_error.dart';
import '../components/button.dart';
import '../const/colors.dart';
import '../models/userLoged.dart';
import '../service/supabaseService.dart';

import 'package:flutter_guid/flutter_guid.dart';
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

  Future<Community> _createCommunityByName() async {
    String communityName = _communityNameController.text;
    Community community = Community(id: Guid.newGuid, name: communityName);
    // Llamar a addCommunityByName con el Map de la comunidad
    await CommunitySupabase()
        .addCommunityByNameAndId(community.id, community.name);
    return community;
  }

  Future<Guid?> _updateUserIdCommunity(Community community) async {
    try {
      Guid? Id = await SupabaseService().getUserId();
      if (Id == null) {
        print("User ID is null");
      }
      UserLoged user = await UserSupabase().getUserById(Id!) as UserLoged;
      UserLoged updatedUser = UserLoged(
          id: user.id,
          name: user.name,
          email: user.email,
          community_id: community.id);
      await UserSupabase().updateUser(Id, updatedUser);
      print("User updated successfully");
      return Id;
    } catch (e) {
      print("Error updating user: $e");
      return await SupabaseService().getUserId();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OurColors().backgroundColor,
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
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              onPressed: _isButtonEnabled
                  ? () async {
                      Community communityAux = await _createCommunityByName();
                      Guid? id = await _updateUserIdCommunity(communityAux);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(id!),
                        ),
                      );
                    }
                  : null,
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: OurColors().backgroundColorButton,
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
