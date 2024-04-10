import 'package:flutter/material.dart';
import '../../models/land.dart';

class LandDetailPage extends StatelessWidget {
  final Land land;
  const LandDetailPage(this.land, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Detalles'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(children: [
              const Text(
      'Detalles',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
              ),
              const SizedBox(
      height: 10.0,
              ),
              Text(land.size.toString()),
              Text(land.location.toString()),
            ]),
    );
  }
}