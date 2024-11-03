import 'dart:io';

import 'package:camera_app/pages/take_photo.dart';
import 'package:flutter/material.dart';

class PreviewPhoto extends StatefulWidget {
  @override
  _PreviewPhotoState createState() => _PreviewPhotoState();
}

class _PreviewPhotoState extends State<PreviewPhoto> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera App'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              width: 250,
              height: 445,
              color: Colors.grey[200],
              child: (imageFile != null)
                  ? Image.file(imageFile!)
                  : const SizedBox(),
            ),
            ElevatedButton(
              child: const Text('Take Picture'),
              onPressed: () async {
                final result = await Navigator.push<File>(
                  context,
                  MaterialPageRoute(builder: (_) => TakePhoto()),
                );
                if (result != null) {
                  setState(() {
                    imageFile = result;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
