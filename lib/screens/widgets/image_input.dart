import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;
  final _imagePicker = ImagePicker();

  Future<void> pickImage() async {
    final pickedImage = await _imagePicker.getImage(
      source: ImageSource.camera,
      maxHeight: 600,
      maxWidth: 600.0,
    );
    if (pickedImage == null) return;
    setState(() {
      _storedImage = File(pickedImage.path);
    });
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    _storedImage = await _storedImage
        .copy('${appDir.path}/${path.basename(_storedImage.path)}');
    widget.onSelectImage(_storedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 100,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          alignment: Alignment.center,
          child: _storedImage == null
              ? Text(
                  'No Image Selected',
                  textAlign: TextAlign.center,
                )
              : Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            onPressed: pickImage,
          ),
        ),
      ],
    );
  }
}
