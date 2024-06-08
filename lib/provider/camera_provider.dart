import 'dart:developer';
import 'dart:io';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';

import 'package:manual_camera_pro/camera.dart';
import 'package:path_provider/path_provider.dart';
import '../component/flushbar/flush_bar.dart';

class CameraProvider with ChangeNotifier{


  String? imagePath;
  String get pathImage => imagePath!;



  CameraController? controller;
  set setController(CameraController? value){
    controller = value;
    notifyListeners();
  }


  double _value = 1.0;
  double get value => _value;

  void setValue(double val){
    _value = val;
    notifyListeners();
  }



  void onNewCameraSelected(CameraDescription? cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }
    controller = CameraController(
        cameraDescription!,
        ResolutionPreset.medium,
        iso: value.toInt(),
        focusDistance: value,
        shutterSpeed: value.toInt());

    // If the controller is updated then update the UI.
    controller!.addListener(() {
       notifyListeners();
      if (controller!.value.hasError) {
        log('Camera error ${controller!.value.errorDescription}');
       }
    });

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      log('Camera exception: $e');
      _showCameraException(e);
    }
    notifyListeners();
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String? filePath)async {
      if (filePath != null) {
          imagePath = filePath;
          final fileBytes = File(imagePath!).readAsBytesSync();
          final data = await readExifFromBytes(fileBytes);
          log("metadata==>$data");
        notifyListeners();
        log("image details==>$imagePath");
      }
    });
  }


  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String?> takePicture() async {
    if (!controller!.value.isInitialized) {
      FlushBarMessage()
          .flushBarMessage(message: 'Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/manual_camera';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller!.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    FlushBarMessage().flushBarMessage(message: "${e.code}${e.description}");
  }


}