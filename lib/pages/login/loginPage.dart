import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/models/userLoged.dart';
import 'package:flutter_application_huerto/pages/first_home_page.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/Auth.dart';
import '../../service/supabaseService.dart';
import '../../service/user_supabase.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      await SupabaseService().signInWithEmailAndPassword(email, password);
      Guid? userId = await SupabaseService().getUserId();
      UserLoged? user = await UserSupabase().getUserById(userId!);

      if (user != null) {
        Auth().initialize(
          id: user.id,
          username: user.name,
          community: user.community_id!,
          isAdmin: user.is_admin!,
        );
        if (user.community_id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(user.id),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FirstHomePage(),
            ),
          );
        }
      } else {
        _showError('User and/or password incorrect');
      }
    } catch (error) {
      _showError('User and/or password incorrect');
    }
  }

  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(45.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 61, 196, 86)),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF67D67B)),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              SizedBox(
                width: double.infinity,
                height: 45.0, // Match the height of the TextField
                child: ElevatedButton(
                  onPressed: _login,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF67D67B)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
