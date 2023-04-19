import 'dart:io';

import 'package:cat_dog_classifier/detector.dart';
import 'package:cat_dog_classifier/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? selectedImage = null;
  late Detector detector;
  String results = "";

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    detector = Detector();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      detector.detectorInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cat and Dog Classifier",
          style: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: selectedImage != null
                ? Container(
                    margin: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(
                          File(
                            selectedImage!.path,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                  ),
          ),
          Expanded(
            child: Column(
              children: [
                isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        results,
                      ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text(
                    "Gallery",
                  ),
                  onPressed: () async {
                    await pickImage(
                      ImageSource.gallery,
                    );
                    await detectImage();
                  },
                ),
                SizedBox(
                  width: context.dynamicWidth(
                    0.1,
                  ),
                ),
                ElevatedButton(
                  child: const Text(
                    "Camera",
                  ),
                  onPressed: () async {
                    await pickImage(
                      ImageSource.camera,
                    );
                    await detectImage();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  pickImage(source) async {
    final ImagePicker picker = ImagePicker();

    selectedImage = await picker.pickImage(source: source);

    setState(() {});
  }

  detectImage() async {
    isLoading = true;
    setState(() {});
    final classes = ["Dog", "Cat"];
    InputImage inputImage = InputImage.fromFilePath(
      selectedImage!.path,
    );

    List result = await detector.detectImage(inputImage);

    for (var element in result) {
      results +=
          "  Class: ${classes[element.index]} Confidence: ${element.confidence.toStringAsFixed(2)} \n";
    }
    isLoading = false;
    setState(() {});
  }
}
