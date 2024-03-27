import 'package:flutter/material.dart';
import 'components/button.dart';
import 'components/navigation.dart';
import 'service/supabase.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GOD HUERTUS'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 350,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.lightGreen[200],
                  borderRadius: BorderRadius.circular(43),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Text(
                        'Container 1',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Positioned(
                        bottom: 8,
                        right: 20,
                        child: Button(
                            text: "Comenzar",
                            icon: Icon(Icons.arrow_forward),
                            onPressed: () {})),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 350,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.lightGreen[200],
                  borderRadius: BorderRadius.circular(43),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Text(
                        'Container 2',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Positioned(
                        bottom: 8,
                        right: 20,
                        child:
                            Button(text: "Comenzar",
                            icon: Icon(Icons.arrow_forward), 
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange
                            ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
