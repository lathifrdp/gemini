import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gemini/global_variables.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController textEditingController = TextEditingController();
  String answer = '';
  XFile? image;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          title: const Text(
            'Gemini',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Lottie.asset('assets/lottie.json', width: 200, height: 200),
              TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    hintText: 'Masukin kata kata',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  )),
              const SizedBox(height: 20),
              image != null
                  ? Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                          color: image == null ? Colors.grey.shade200 : null,
                          image: image != null
                              ? DecorationImage(
                                  image: FileImage(File(image!.path)))
                              : null),
                    )
                  : Container(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ImagePicker().pickImage(source: ImageSource.gallery).then(
                    (value) {
                      setState(() {
                        image = value;
                      });
                    },
                  );
                },
                child: const Text('Pick Image'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  GenerativeModel model = GenerativeModel(
                      model: 'gemini-1.5-flash-latest', apiKey: apiKey);

                  // model.generateContent([
                  //   Content.text(textEditingController.text),
                  // ]).then((value) {
                  //   setState(() {
                  //     answer = value.text.toString();
                  //   });
                  // });

                  model.generateContent([
                    Content.multi([
                      TextPart(textEditingController.text),
                      if (image != null)
                        DataPart(
                            "image/jpeg", File(image!.path).readAsBytesSync())
                    ])
                  ]).then((value) {
                    setState(() {
                      answer = value.text.toString();
                      isLoading = false;
                    });
                  });
                },
                child: const Text('Send'),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const UnconstrainedBox(
                      child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator()),
                    )
                  : Text(answer),
            ],
          ),
        ));
  }
}
