import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/pages/login/loginPage.dart';
import 'package:flutter_application_huerto/service/user_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:supabase/supabase.dart';

import '../../models/userLoged.dart';
import '../../service/supabaseService.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController =
      TextEditingController(); // Nuevo controlador para el nombre

  Future<void> _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name =
        _nameController.text.trim(); // Obtener el valor del campo de nombre

    try {
      // Registro del usuario en Supabase
      final response = await SupabaseService().client.auth.signUp(
            password: password,
            email: email,
          );
      await UserSupabase().updateUser(UserLoged(
          id: Guid(response.user?.id),
          name: name, 
          email: email,
          community_id: null,
          is_admin: false,
        )
      );
      _showSuccess(response.toString());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } catch (error) {
      // Manejar otros errores
      _showError(error.toString());
    }
  }

  void _showSuccess(String message) {
    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

  void _showError(String message) {
    // Mostrar mensaje de error
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController, // Campo de nombre
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
