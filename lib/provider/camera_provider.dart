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
  CameraController? get con => controller;

 void setController(CameraController? value){
    controller = value;
   //updateCameraSettings();
    notifyListeners();
  }

  double _value = 0.3;
  double get value => _value;

  void setValue(double val){
    _value = val;
    log("focus distance==>${value*100}");
    notifyListeners();
  }


  double _iosValue = 0.1;
  double get iosValue => _iosValue;

  void setIOSValue(double val){
    _iosValue = val;
    log("IOS VALUE==>${(_iosValue*100).toInt()}");
    notifyListeners();
  }


  double _shutterSpeedValue = 0.2;
  double get shutterSpeedValue => _shutterSpeedValue;

  void setShutterSpeedValue(double val){
    _shutterSpeedValue = val;

    notifyListeners();
    log("shutter speed==>${ (shutterSpeedValue*100).toInt()}");
  }




  Future<void> onNewCameraSelected(CameraDescription? cameraDescription) async {
    // if (controller != null) {
    //   await controller!.dispose();
    // }
    final isoVal = (iosValue*100).toStringAsFixed(0);
    log("oos==>${int.parse(isoVal).toString()}");
    final ssVal = (shutterSpeedValue*100).toStringAsFixed(0);
    log("ss==>${int.parse(ssVal).toString()}");
    final fdVal = (value*100).toStringAsFixed(2);
    log("fd==>${fdVal.toString()}");



      controller = CameraController(
        cameraDescription!,
        ResolutionPreset.medium,
        iso: int.parse(isoVal) ,
        focusDistance: double.parse(fdVal),
        shutterSpeed: int.parse(ssVal),

      );

    // If the controller is updated then update the UI.
    controller!.addListener(() {
      log("ob;;");
    notifyListeners();
      if (controller!.value.hasError) {
        log('Camera error ${controller!.value.errorDescription}');
       }
    });

    try {
      await controller!.initialize();
      log("ob in");
      notifyListeners();
    } on CameraException catch (e) {
      log('Camera exception: $e');
      _showCameraException(e);
    }
    notifyListeners();
  }


  Future<void> updateCameraSettings() async {
    final isoVal = (iosValue*100).toStringAsFixed(0);
    log("oos==>${int.parse(isoVal).toString()}");
    final ssVal = (shutterSpeedValue*100).toStringAsFixed(0);
    log("ss==>${int.parse(ssVal).toString()}");
    final fdVal = (value*100).toStringAsFixed(2);
    log("fd==>${fdVal.toString()}");
    
    
   // if (controller != null && controller!.value.isInitialized) {
      try {

        controller = CameraController(
            controller!.description,
            ResolutionPreset.medium,
            iso: int.parse(isoVal) ,
            focusDistance: double.parse(fdVal),
            shutterSpeed: int.parse(ssVal),

        );
        log("message");
        notifyListeners();

      } on CameraException catch (e) {
        log('Error updating camera settings: $e');
      }


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

  // @override
  // void dispose() {
  //   controller?.dispose();
  //   super.dispose();
  // }
}