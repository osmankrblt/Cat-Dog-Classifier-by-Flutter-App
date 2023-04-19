import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Detector {
  Future<dynamic> predict(File image) async {
    List<int> imageBytes = image.readAsBytesSync();

    String base64Image = base64Encode(imageBytes);

    try {
      http.Response response = await http.post(
        Uri.parse('http://192.168.0.102:5000/predict'),
        body: <String, String>{
          'file': base64Image,
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('A network error occurred');
      }

      final result = jsonDecode(response.body);
      return "Label: ${result[0]} , Confidence: ${result[1]}";
    } catch (e) {
      return "Connection error: " + e.toString();
    }
  }
}
