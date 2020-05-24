import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:flutter_text_art_filter/model/app_state_model.dart';
import 'package:flutter_text_art_filter/model/saved_image.dart';
import 'package:flutter_text_art_filter/UI/gallery/gallery.dart';
import 'package:flutter_text_art_filter/UI/gallery/gallery_item_thumbnail.dart';
import 'package:flutter_text_art_filter/UI/form.dart';

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
        void _handleGetImage(ImageSource imageSource) async {
          File imageFile = await ImagePicker.pickImage(source: imageSource);
          if (imageFile != null) {
            print('imageFile is not null');
            String imageFilePath = imageFile.path;
            File croppedImageFile =
                await ImageCropper.cropImage(sourcePath: imageFilePath);
            croppedImageFile != null
                ? appState.addNewImageFile(croppedImageFile)
                : appState.addNewImageFile(imageFile);
          }
        }

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
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: <Widget>[
                              Text(_formatDate(savedImage.dateAdded)),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.image),
                                onPressed: () {
                                  print('pressed');
                                  _showCreateTextArtDialog(savedImage);
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
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
                        ),
                      ],
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
                    _handleGetImage(ImageSource.camera);
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                FloatingActionButton(
                  heroTag: null,
                  child: Icon(Icons.add_photo_alternate),
                  onPressed: () {
                    _handleGetImage(ImageSource.gallery);
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

  String _formatDate(DateTime dateTime) {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  void _showCreateTextArtDialog(SavedImage savedImage) {
    print('_showCreateTextArtDialog');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateTextArtForm(savedImage: savedImage);
      },
    );
  }
}
