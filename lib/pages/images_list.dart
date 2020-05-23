import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_text_art_filter/model/app_state_model.dart';
import 'package:flutter_text_art_filter/model/saved_image.dart';
import 'package:image_cropper/image_cropper.dart';

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
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                            Image.file(savedImage.originalImage),
                          ] +
                          savedImage.textArtImagesList
                              .map((imageFile) => Image.file(imageFile))
                              .toList(),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: <Widget>[
                Spacer(),
                FloatingActionButton(
                  child: Icon(Icons.camera_alt),
                  onPressed: () {
                    print('pressed');
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                FloatingActionButton(
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
}
