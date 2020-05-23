import 'dart:io';
import 'package:flutter/material.dart';

class GalleryItemThumbnail extends StatelessWidget {
  GalleryItemThumbnail({Key key, this.imageFile, this.onTap}) : super(key: key);

  final File imageFile;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: imageFile.path,
          child: Image.file(imageFile),
        ),
      ),
    );
  }
}
