import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Gallery extends StatefulWidget {
  Gallery({@required this.galleryItems, this.initialIndex});

  final List<File> galleryItems;
  final int initialIndex;

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    print(currentIndex);
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: currentIndex);
    return Scaffold(
      body: Container(
        constraints:
            BoxConstraints.expand(height: MediaQuery.of(context).size.height),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: BouncingScrollPhysics(),
              itemCount: widget.galleryItems.length,
              pageController: _pageController,
              builder: _buildItem,
              onPageChanged: onPageChanged,
            ),
            Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Image ${currentIndex + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions(
      imageProvider: FileImage(widget.galleryItems[index]),
      heroAttributes:
          PhotoViewHeroAttributes(tag: widget.galleryItems[index].path),
    );
  }
}
