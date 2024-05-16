import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_huerto/components/button.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../const/colors.dart';
import '../../models/Auth.dart';

class QrViewerPage extends StatefulWidget {
  QrViewerPage();

  @override
  QrViewerPageState createState() => QrViewerPageState();
}

class QrViewerPageState extends State<QrViewerPage> {
  late Auth session;

  @override
  void initState() {
    session = Auth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Community\'s QR'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              color: OurColors().primeWhite,
              child: QrImageView(
                embeddedImage: AssetImage('images/gaiaLogo.png'),
                data: session.community.value,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                Clipboard.setData(ClipboardData(text: session.community.value))
                    .then((_) {
                  _showSuccess("Community ID copied successfully!");
                });
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(OurColors().primeWhite),
                foregroundColor: MaterialStateProperty.all(Colors.black),
              ),
              child: Text(
                "Copy Community ID",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
      backgroundColor: Colors.green,
    ));
  }
}
