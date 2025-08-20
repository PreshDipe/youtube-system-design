import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(content)));
}

Future<File?> pickImage() async {
  final picker = ImagePicker();

  final xFile = await picker.pickImage(source: ImageSource.gallery);

  if (xFile != null) {
    return File(xFile.path);
  }

  return null;
}

Future<File?> pickVideo() async {
  final picker = ImagePicker();

  final xFile = await picker.pickVideo(source: ImageSource.gallery);

  if (xFile != null) {
    return File(xFile.path);
  }

  return null;
}
