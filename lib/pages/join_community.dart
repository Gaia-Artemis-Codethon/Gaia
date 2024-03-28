import 'package:flutter/material.dart';
import '../components/button.dart';
import 'package:flutter_application_huerto/service/supabase.dart';

import '../service/community_supabase.dart';

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

void _readCommunityById() {
 String communityId = _communityIdController.text;
 CommunitySupabase().readCommunityById(communityId).then((data) {
    // Handle the data returned from readCommunityById
    print("Data: $data");
 }).catchError((error) {
    // Handle any errors
    print("Error: $error");
 });
}

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: () {}, child: const Icon(Icons.arrow_back)),
            const Text('ÚNETE A UNA COMUNIDAD'),
          ],
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
              ),
              onPressed: _isButtonEnabled ? _readCommunityById : null,
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