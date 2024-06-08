import 'package:flutter/material.dart';
import 'package:manual_camera_pro/camera.dart';
import 'package:manual_camera_test/component/flushbar/flush_bar.dart';
import 'package:manual_camera_test/features/camera/camera_screen.dart';
import 'package:manual_camera_test/provider/camera_provider.dart';
import 'package:provider/provider.dart';
List<CameraDescription> cameras = [];
BuildContext? context;
Future <void> main() async{

  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
   FlushBarMessage().flushBarMessage(message: "${e.code}${e.description}");
   // logError(e.code, e.description);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<CameraProvider>(create: (context) => CameraProvider()),
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Manual Camera',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:CameraScreen(cameras: cameras,),
      ),
    );
  }
}
