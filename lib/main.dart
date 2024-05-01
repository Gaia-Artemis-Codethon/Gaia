import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/pages/first_home_page.dart';
import 'package:flutter_application_huerto/service/supabaseService.dart';
import 'package:flutter_application_huerto/service/user_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_application_huerto/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/userLoged.dart';

UserLoged? user;
Guid? userId;
bool isInitialized =
    false; // Variable para verificar si Supabase ya está inicializado

Future<void> initializeApp() async {
  if (!isInitialized) {
    // Verifica si ya se ha inicializado
    await Supabase.initialize(
        url: "https://pxafmjqslgpswndqzfvm.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB4YWZtanFzbGdwc3duZHF6ZnZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTAzNjYzNjIsImV4cCI6MjAyNTk0MjM2Mn0.xbGjWmYqPUO3i2g1_4tmE7sWhI_c9ymFqckSA_CaFOs");
    await SupabaseService()
        .signInWithEmailAndPassword('user@example.com', 'qwerty');
    userId = await SupabaseService().getUserId();
    user = await UserSupabase().getUserById(userId!);
    isInitialized = true; // Marca que Supabase ya está inicializado
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: FutureBuilder<void>(
        future: initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return user?.community_id == null
                ? const FirstHomePage()
                : HomePage(userId!); // Aquí se utiliza HomePage.withUserId()
          } else {
            return const Center(
                child:
                    CircularProgressIndicator()); // Muestra un indicador de carga mientras se espera
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
