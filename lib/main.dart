import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/pages/first_home_page.dart';
import 'package:flutter_application_huerto/service/supabaseService.dart';
import 'package:flutter_application_huerto/service/user_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/userLoged.dart';


void main() async {
  await SupabaseService().signInWithEmailAndPassword('user@example.com', 'qwerty');
  final userId = await SupabaseService().getUserId();
  final user = await UserSupabase().getUserById(userId!);
  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.user}) : super(key: key);

  final UserLoged user;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: user.community_id == null? FirstHomePage() : null,
      debugShowCheckedModeBanner: false,
    );
  }
}
