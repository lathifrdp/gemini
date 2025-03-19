import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController textEditingController = TextEditingController();
  String answer = '';
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber.shade100,
          title: const Text('Gemini AI Demo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your request here',
                    border: OutlineInputBorder(),
                  )),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                    color: image == null ? Colors.grey.shade200 : null,
                    image: image != null
                        ? DecorationImage(image: FileImage(File(image!.path)))
                        : null),
              ),
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
                onPressed: () {},
                child: const Text('Send'),
              ),
              const SizedBox(height: 20),
              Text(answer),
            ],
          ),
        ));
  }
}
