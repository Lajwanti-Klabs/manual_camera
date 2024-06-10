import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:manual_camera_pro/camera.dart';
import 'package:manual_camera_test/features/camera/component/camera_appbar.dart';
import 'package:manual_camera_test/features/camera/component/camera_body.dart';
import 'package:manual_camera_test/main.dart';
import 'package:manual_camera_test/provider/camera_provider.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
 final List<CameraDescription> cameras;
  const CameraScreen({super.key,required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>  with WidgetsBindingObserver {

  @override

   initState() {
    final cameraProvider = Provider.of<CameraProvider>(this.context,listen: false);
    WidgetsBinding.instance.addObserver(this);
    try {
      log("Camera");
      cameraProvider.onNewCameraSelected(widget.cameras.first);

    } catch (e) {
      log("Error in camera when open the app==>$e");
    }
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraProvider = Provider.of<CameraProvider>(this.context,listen: false);

    // App state changed before we got the chance to initialize.
    if (cameraProvider.controller == null || !cameraProvider.controller!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraProvider.controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (cameraProvider.controller != null) {
        cameraProvider.onNewCameraSelected(cameras.first);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  const CameraAppbar(),
      body: CameraBody(cameras: cameras),
    );
  }
}
