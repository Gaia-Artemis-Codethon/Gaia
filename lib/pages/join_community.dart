import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/pages/home_page.dart';
import 'package:flutter_guid/flutter_guid.dart';
import '../components/button.dart';
import '../models/community.dart';
import '../models/userLoged.dart';
import '../service/supabaseService.dart';
import 'package:flutter/widgets.dart';

import '../service/community_supabase.dart';
import '../service/user_supabase.dart';

class JoinCommunity extends StatefulWidget {
  const JoinCommunity({Key? key}) : super(key: key);

  @override
  _JoinCommunityState createState() => _JoinCommunityState();
}

class _JoinCommunityState extends State<JoinCommunity> {
  final TextEditingController _communityIdController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _communityIdController.addListener(_updateButtonState);
    _communityIdController.text = "544b7be4-a82f-4425-80e1-390004064742"; //Debug purposes, do not upload to prod
  }

  @override
  void dispose() {
    _communityIdController.removeListener(_updateButtonState);
    _communityIdController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _communityIdController.text.isNotEmpty;
    });
  }

  Future<Community?> _readCommunityById() async {
    try {
      Guid communityId = Guid(_communityIdController.text);
      Community? community =
          await CommunitySupabase().readCommunityById(communityId);
      if (community == null) {
        _showErrorDialog(
            context, "La comunidad con el ID proporcionado no existe.");
        return null;
      }
      Guid? userId = await _updateUserIdCommunity(community);
      if (userId != null) {
        // Navega a HomePage con el userId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userId),
          ),
        );
      }
      return community;
    } catch (e) {
      _showErrorDialog(context, "Error al leer la comunidad: ID incorrecto.");
      return null;
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Guid?> _updateUserIdCommunity(Community community) async {
    try {
      Guid? userId = await SupabaseService().getUserId();
      if (userId == null) {
        print("User ID is null");
        return null;
      }
      UserLoged user = await UserSupabase().getUserById(userId) as UserLoged;
      UserLoged updatedUser = UserLoged(
          id: user.id,
          name: user.name,
          email: user.email,
          community_id: community.id);
      await UserSupabase().updateUser(userId, updatedUser);
      print("User updated successfully");
      return userId; // Devuelve el userId
    } catch (e) {
      print("Error updating user: $e");
      return null;
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
            'ÚNETE A UNA COMUNIDAD',
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
              "Únete a una comunidad",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Únete ahora mismo a una comunidad y comienza a plantar un futuro sostenible junto a tus vecinos!",
              textAlign: TextAlign.left,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "ID de la comunidad",
              textAlign: TextAlign.left,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "PREGUNTA ESTE CÓDIGO A ALGÚN VECINO",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _communityIdController,
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
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _isButtonEnabled
                  ? () async {
                      Community? community = await _readCommunityById();
                      if (community != null) {
                        // Aquí ya se ha navegado a HomePage con el userId en _readCommunityById
                        // Asegúrate de que el userId se obtenga correctamente antes de la navegación
                        Guid? userId = await _updateUserIdCommunity(community);
                        if (userId != null) {
                          // Navega a HomePage con el userId
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(userId),
                            ),
                          );
                        }
                      }
                    }
                  : null,
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: OurColors().accent,
                alignment: Alignment.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
