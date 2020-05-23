import 'package:flutter/foundation.dart' as foundation;
import 'package:image/image.dart' as img;
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:flutter_text_art_filter/model/saved_image.dart';

class AppStateModel extends foundation.ChangeNotifier {
  List<SavedImage> savedImagesList = [];

  void loadApp() {
    print('#####################');
    print('loadApp');
    loadSavedImages();
  }

  void loadSavedImages() async {
    Directory dir = await getApplicationDocumentsDirectory();
    print('dir: $dir');
    SavedImage currentSavedImage;
    dir
        .list(recursive: true, followLinks: false)
        .listen((FileSystemEntity entity) {
      // print(entity.path);

      if (entity is Directory) {
        String dirName = _nameFromPath(entity.path);
        int millisecondsFromEpoch = int.parse(dirName);
        DateTime dateAdded =
            DateTime.fromMillisecondsSinceEpoch(millisecondsFromEpoch);
        File originalImage = File('${entity.path}/original.png');
        currentSavedImage = SavedImage(
          dateAdded: dateAdded,
          originalImage: originalImage,
        );
        savedImagesList.add(currentSavedImage);
        print('Directory: ${entity.path}');
      } else if (entity is File) {
        // Proceed if entity is not a dot file or if it is not original image
        if (!_isDotFile(entity.path) &&
            _nameFromPath(entity.path) != 'original.png') {
          print('File: ${entity.path}');
          currentSavedImage.textArtImagesList.add(File(entity.path));
        }
      }
      notifyListeners();
    });
  }

  // Returns name of directory or file
  // Eg. a/b/c.dart -> c.dart
  String _nameFromPath(String path) {
    return path.split('/').last;
  }

  // Returns true if dot file
  bool _isDotFile(String path) {
    String fileName = _nameFromPath(path);
    print('_isDotFile fileName: $fileName');
    return fileName[0] == '.';
  }

  // Called when adding new image from Camera or Gallery
  void addNewImageFile(File imageFile) async {
    Directory dir = await getApplicationDocumentsDirectory();
    DateTime dateAdded = DateTime.now();
    // Need to create new directory because the directory for new image
    // doesn't exist yet
    String newDirName = dateAdded.millisecondsSinceEpoch.toString();
    Directory newDirectory = Directory('${dir.path}/$newDirName/');
    await newDirectory.create(recursive: true);
    await imageFile.copy('${dir.path}/$newDirName/original.png');
    File originalImage = File('${dir.path}/$newDirName/original.png');
    SavedImage imageFileSavedImage =
        SavedImage(dateAdded: dateAdded, originalImage: originalImage);
    savedImagesList.add(imageFileSavedImage);

    img.Image textArtImageBuffer = await createTextArtImage(originalImage);
    File textArtImageFile =
        await _saveImageBufferToPng(textArtImageBuffer, newDirName);
    imageFileSavedImage.textArtImagesList.add(textArtImageFile);
    notifyListeners();
  }

  // Save image buffer as PNG and return the saved image file
  Future<File> _saveImageBufferToPng(
      img.Image imageBuffer, String dirName) async {
    Directory dir = await getApplicationDocumentsDirectory();
    DateTime dateAdded = DateTime.now();
    String newFileName = dateAdded.millisecondsSinceEpoch.toString();
    File('${dir.path}/$dirName/$newFileName.png')
        .writeAsBytesSync(img.encodePng(imageBuffer));
    File savedFile = File('${dir.path}/$dirName/$newFileName.png');
    return savedFile;
  }

  // Return Text Art Image as Image Buffer from an image file
  Future<img.Image> createTextArtImage(File imageFile) async {
    String chars =
        "\$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\\|()1{}[]?-_+~<>i!lI;:,\"^`'. ";
    List<String> charsList = chars.split('').toList();
    int charLength = charsList.length;
    double interval = charLength / 256;

    double scaleFactor = 0.09;
    int oneCharWidth = 10;
    int oneCharHeight = 18;

    getChar(int inputint) {
      return charsList[(inputint * interval).floor()];
    }

    img.Image imageBuffer = img.decodeImage(imageFile.readAsBytesSync());

    List<int> xywh = img.findTrim(imageBuffer);
    int width = xywh[2];
    int height = xywh[3];
    img.Image resizedImageBuffer = img.copyResize(imageBuffer,
        width: (scaleFactor * width).round(),
        height:
            (scaleFactor * height * (oneCharWidth / oneCharHeight)).round());
    List<int> resizedXywh = img.findTrim(resizedImageBuffer);
    int resizedWidth = resizedXywh[2];
    int resizedHeight = resizedXywh[3];

    img.Image outputImageBuffer =
        img.Image(oneCharWidth * resizedWidth, oneCharHeight * resizedHeight);

    print('resized width: $resizedWidth');
    print('resized height: $resizedHeight');
    img.fill(outputImageBuffer, img.getColor(0, 0, 0));
    for (int i = 0; i < resizedHeight; i++) {
      for (int j = 0; j < resizedWidth; j++) {
        int pixel32 = resizedImageBuffer.getPixelSafe(j, i);
        int col = img.getLuminance(pixel32);
        img.drawString(outputImageBuffer, img.arial_14, j * oneCharWidth,
            i * oneCharHeight, getChar(col),
            color: pixel32);
      }
    }

    return outputImageBuffer;
  }
}
