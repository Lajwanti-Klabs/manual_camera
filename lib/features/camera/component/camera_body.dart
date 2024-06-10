import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manual_camera_pro/camera.dart';
import 'package:manual_camera_test/provider/camera_provider.dart';
import 'package:provider/provider.dart';

class CameraBody extends StatelessWidget {
  final List<CameraDescription> cameras;
  const CameraBody({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
    return Column(
      children: [
        Expanded(
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: Colors.grey,
                width: 3.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Consumer<CameraProvider>(
                  builder: (context, controllerValue, child) {
                return Center(
                    child: controllerValue.controller == null ||
                            !controllerValue.controller!.value.isInitialized
                        ? null
                        : AspectRatio(
                            aspectRatio:
                                controllerValue.con!.value.aspectRatio,
                            child: CameraPreview(controllerValue.con!),
                          ));
              }),
            ),
          ),
        ),
        Consumer<CameraProvider>(builder:(context,vl,child){
          return Text("values: ${(vl.iosValue*100).toStringAsFixed(0)},${(vl.shutterSpeedValue*100).toStringAsFixed(0)},${(vl.value*100).toStringAsFixed(2)} ");
        }),
        Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("ISO"),
                ),
                Consumer<CameraProvider>(builder: (context, iosValue, child) {
                  return Slider(
                      min: 0,
                      max: 1,
                      value: iosValue.iosValue,
                      onChanged: (val) {
                        iosValue.setIOSValue(val);

                      });
                }),
              ],
            ),
         Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Shutter Speed"),
              ),
              Consumer<CameraProvider>(builder: (context, shutterSpeedValue, child) {
                return Slider(
                    min: 0,
                    max: 1,
                    value: shutterSpeedValue.shutterSpeedValue,
                    onChanged: (val) {
                        shutterSpeedValue.setShutterSpeedValue(val);

                    });
              }),
            ],
          ),

    Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Focus Distance"),
            ),
            Consumer<CameraProvider>(builder: (context, focusDistanceValue, child) {
              return Slider(
                  min: 0,
                  max: 1,
                  value: focusDistanceValue.value,
                  onChanged: (val) {
                    focusDistanceValue.setValue(val);

                  });
            }),
          ],
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const SizedBox(),
              Consumer<CameraProvider>(builder: (context, controller, child) {
                return IconButton(
                  padding: EdgeInsets.only(bottom: 10,left: controller.imagePath != null?40:0),
                      icon: const Icon(Icons.camera_alt),
                      color: Colors.grey,
                      onPressed: controller.controller != null &&
                              controller.controller!.value.isInitialized
                          ? cameraProvider.onTakePictureButtonPressed
                      //  cameraProvider.printExifOf;



                          : null,
                    );
              }),
              Consumer<CameraProvider>(
                  builder: (context, imagePathController, child) {
                return imagePathController.imagePath == null
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 64.0,
                        height: 64.0,
                        child: Image.file(File(imagePathController.pathImage)));
              }),
            ],
          ),
        )
      ],
    );
  }
}
