import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/pages/start/home_page.dart';
import 'package:flutter_guid/flutter_guid.dart';
import '../../components/button.dart';
import '../../models/Auth.dart';
import '../../models/community.dart';
import '../../models/userLoged.dart';
import '../../service/supabaseService.dart';
import 'package:flutter/widgets.dart';

import '../../service/community_supabase.dart';
import '../../service/user_supabase.dart';

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
            context, "That ID isn't asociated to a community.");
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
      _showErrorDialog(context, "Error reading the community, the ID does not exist.");
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
              child: const Text('Close'),
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
          community_id: community.id,
          is_admin: false); //Is not admin by default
      await UserSupabase().updateUser(updatedUser);
      user = await UserSupabase().getUserById(userId) as UserLoged;
      Auth().initialize(
          id: user.id,
          username: user.name,
          community: user.community_id!,
          isAdmin: user.is_admin!,
        );
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/cu.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0), // Ajusta la distancia hacia abajo
                      child: Text(
                        "Join a community",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "Start planting with your neighbors!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 24.0),
                    Text(
                      "Community ID",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          controller: _communityIdController,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.green[100],
                          ),
                        ),
                      ),
                    ),
                    Button(
                      text: Text(
                        "Continue",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: OurColors().primaryButton,
                        alignment: Alignment.center,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
