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
    _communityIdController.text =
        "f32b22dd-31d4-42b9-ad73-6a28c06ca83d"; //Debug purposes, do not upload to prod
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
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            'Únete a una Comunidad',
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/verdep2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/verdep2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                "Juntate con tus vecinos!",
                textAlign: TextAlign.left,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                style: TextStyle(fontSize: 18),
                "Únete ahora mismo a una comunidad y comienza a plantar un futuro sostenible junto a tus vecinos",
                textAlign: TextAlign.left,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                "ID de la comunidad",
                textAlign: TextAlign.left,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "PREGUNTA ESTE CÓDIGO A ALGÚN VECINO",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18),
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
              child: Container(
                width: 140, // Ancho ajustado del botón
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'images/boton.png'), // Imagen de fondo del botón
                    fit: BoxFit.cover,
                  ),
                ),
                child: TextButton(
                  onPressed: _isButtonEnabled
                      ? () async {
                          Community? community = await _readCommunityById();
                          if (community != null) {
                            // Aquí ya se ha navegado a HomePage con el userId en _readCommunityById
                            // Asegúrate de que el userId se obtenga correctamente antes de la navegación
                            Guid? userId =
                                await _updateUserIdCommunity(community);
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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14, top: 5),
                    child: const Text(
                      "Continuar",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
