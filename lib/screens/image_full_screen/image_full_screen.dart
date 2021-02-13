import 'dart:io';

import 'package:flutter/material.dart';

class ImageFullScreen extends StatelessWidget {
  final File image;
  ImageFullScreen(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: BoxDecoration(color: Colors.black87.withOpacity(0.75)),
        child: Image.file(
          image,
          fit: BoxFit.contain,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }
}
