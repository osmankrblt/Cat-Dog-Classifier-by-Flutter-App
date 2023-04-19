import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Detector {
  late final _modelPath;
  late final _options;
  late ImageLabeler _imageLabeler;
  CustomPaint? _customPaint;
  late String _text;

  Future detectorInit() async {
    _modelPath = await _getModel('assets/model_metadata.tflite');
    debugPrint(_modelPath);
    _options = LocalLabelerOptions(modelPath: _modelPath);
    _imageLabeler = ImageLabeler(options: _options);
  }

  Future<String> _getModel(String assetPath) async {
    if (Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  Future<List> detectImage(InputImage inputImage) async {
    final List<ImageLabel> labels =
        await _imageLabeler.processImage(inputImage);
    print(labels);
    return labels;
  }
}
