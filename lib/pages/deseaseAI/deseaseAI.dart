import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/const/colors.dart';
import 'package:flutter_application_huerto/service/deseaseAiService.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class DeseaseAI extends StatefulWidget {
  const DeseaseAI({super.key});

  @override
  State<DeseaseAI> createState() => _MyDeseaseAIState();
}

class _MyDeseaseAIState extends State<DeseaseAI> {
  String BASE_URL = "https://api.openai.com/v1";
  String API_KEY = "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";
  final apiService = DeseaseAiService();
  File? _selectedImage;
  String diseaseName = '';
  String diseasePrecautions = '';
  bool detecting = false;
  bool precautionLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  detectDisease() async {
    setState(() {
      detecting = true;
    });
    try {
      diseaseName =
          await apiService.sendImageToGPT4Vision(image: _selectedImage!);
    } catch (error) {
      _showErrorSnackBar(error);
    } finally {
      setState(() {
        detecting = false;
      });
    }
  }

  showPrecautions() async {
    setState(() {
      precautionLoading = true;
    });
    try {
      if (diseasePrecautions == '') {
        diseasePrecautions =
            await apiService.sendMessageGPT(diseaseName: diseaseName);
      }
      _showSuccessDialog(diseaseName, diseasePrecautions);
    } catch (error) {
      _showErrorSnackBar(error);
    } finally {
      setState(() {
        precautionLoading = false;
      });
    }
  }

  void _showErrorSnackBar(Object error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error.toString()),
      backgroundColor: Colors.red,
    ));
  }

  void _showSuccessDialog(String title, String content) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: title,
      desc: content,
      btnOkText: 'Got it',
      btnOkColor: OurColors().themeColor,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.23,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    // Top right corner
                    bottomLeft: Radius.circular(50.0), // Bottom right corner
                  ),
                  color: OurColors().themeColor,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    // Top right corner
                    bottomLeft: Radius.circular(50.0), // Bottom right corner
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      // Shadow color with some transparency
                      spreadRadius: 1,
                      // Extend the shadow to all sides equally
                      blurRadius: 5,
                      // Soften the shadow
                      offset: const Offset(2, 2), // Position of the shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: OurColors().themeColor,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'OPEN GALLERY',
                            style: TextStyle(color: OurColors().textColor),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.image,
                            color: OurColors().textColor,
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _pickImage(ImageSource.camera);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: OurColors().themeColor,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('START CAMERA',
                              style: TextStyle(color: OurColors().textColor)),
                          const SizedBox(width: 10),
                          Icon(Icons.camera_alt, color: OurColors().textColor)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _selectedImage == null
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Image.asset("images/pick1.png"),
                )
              : Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
          if (_selectedImage != null)
            detecting
                ? SpinKitWave(
                    color: OurColors().themeColor,
                    size: 30,
                  )
                : Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: OurColors().themeColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        // Set some horizontal and vertical padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // Rounded corners
                        ),
                      ),
                      onPressed: () {
                        detectDisease();
                      },
                      child: const Text(
                        'DETECT',
                        style: TextStyle(
                          color: Colors.white, // Set the text color to white
                          fontSize: 16, // Set the font size
                          fontWeight:
                              FontWeight.bold, // Set the font weight to bold
                        ),
                      ),
                    ),
                  ),
          if (diseaseName != '')
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DefaultTextStyle(
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                        child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                            repeatForever: false,
                            displayFullTextOnTap: true,
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TyperAnimatedText(
                                diseaseName.trim(),
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
                precautionLoading
                    ? const SpinKitWave(
                        color: Colors.blue,
                        size: 30,
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        onPressed: () {
                          showPrecautions();
                        },
                        child: Text(
                          'PRECAUTION',
                          style: TextStyle(
                            color: OurColors().textColor,
                          ),
                        ),
                      ),
              ],
            ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
