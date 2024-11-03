import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TakePhoto extends StatefulWidget {
  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  late CameraController controller;

  Future<void> initializeCamera() async {
    var cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.high);
    await controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<File?> takePhoto() async {
    Directory root = await getTemporaryDirectory();
    String directoryPath = '${root.path}/Camera_App';
    await Directory(directoryPath).create(recursive: true);
    String filePath =
        '$directoryPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      XFile picture = await controller.takePicture();
      File file = File(filePath);
      await picture.saveTo(file.path);
      return file;
    } catch (e) {
      print("Error taking photo: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: initializeCamera(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width *
                          controller.value.aspectRatio,
                      child: CameraPreview(controller),
                    ),
                    Container(
                      width: 70,
                      height: 70,
                      margin: const EdgeInsets.only(top: 30),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!controller.value.isTakingPicture) {
                            File? result = await takePhoto();
                            if (result != null) {
                              Navigator.pop(context, result);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
