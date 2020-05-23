import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_text_art_filter/model/app_state_model.dart';
import 'package:flutter_text_art_filter/model/saved_image.dart';
import 'package:flutter_text_art_filter/UI/gallery/gallery.dart';
import 'package:flutter_text_art_filter/UI/gallery/gallery_item_thumbnail.dart';

class ImagesListPage extends StatefulWidget {
  @override
  _ImagesListPageState createState() => _ImagesListPageState();
}

class _ImagesListPageState extends State<ImagesListPage> {
  bool _isLoading;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, appState, child) {
        return Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: appState.savedImagesList.length,
                itemBuilder: (BuildContext context, int index) {
                  SavedImage savedImage = appState.savedImagesList[index];

                  List<File> imagesToShow =
                      [savedImage.originalImage] + savedImage.textArtImagesList;

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _mapIndexed(
                        imagesToShow,
                        (index, imageFile) => GalleryItemThumbnail(
                          imageFile: imageFile,
                          onTap: () {
                            _openGallery(context, index, imagesToShow);
                          },
                        ),
                      ).toList(),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: <Widget>[
                Spacer(),
                FloatingActionButton(
                  heroTag: null,
                  child: Icon(Icons.camera_alt),
                  onPressed: () {
                    print('pressed');
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                FloatingActionButton(
                  heroTag: null,
                  child: Icon(Icons.add_photo_alternate),
                  onPressed: () async {
                    print('pressed');
                    File imageFile = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (imageFile != null) {
                      print('imageFile is not null');
                      String imageFilePath = imageFile.path;
                      File croppedImageFile = await ImageCropper.cropImage(
                          sourcePath: imageFilePath);
                      croppedImageFile != null
                          ? appState.addNewImageFile(croppedImageFile)
                          : appState.addNewImageFile(imageFile);
                    }
                  },
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }

  // Function to map through a list with access to index.
  // Dart can't access index with map...
  Iterable<E> _mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    int index = 0;
    for (final item in items) {
      yield f(index, item);
      index++;
    }
  }

  // Navigate to Gallery
  void _openGallery(BuildContext context, int index, List<File> imageFiles) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Gallery(
            galleryItems: imageFiles,
            initialIndex: index,
          );
        },
      ),
    );
  }
}
